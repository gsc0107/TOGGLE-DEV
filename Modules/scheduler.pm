package scheduler;

###################################################################################################################################
#
# Copyright 2014-2016 IRD-CIRAD-INRA-ADNid
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/> or
# write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.
#
# You should have received a copy of the CeCILL-C license with this program.
#If not see <http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.txt>
#
# Intellectual property belongs to IRD, CIRAD and South Green developpement plateform for all versions also for ADNid for v2 and v3 and INRA for v3
# Version 1 written by Cecile Monat, Ayite Kougbeadjo, Christine Tranchant, Cedric Farcy, Mawusse Agbessi, Maryline Summo, and Francois Sabot
# Version 2 written by Cecile Monat, Christine Tranchant, Cedric Farcy, Enrique Ortega-Abboud, Julie Orjuela-Bouniol, Sebastien Ravel, Souhila Amanzougarene, and Francois Sabot
# Version 3 written by Cecile Monat, Christine Tranchant, Cedric Farcy, Maryline Summo, Julie Orjuela-Bouniol, Sebastien Ravel, Gautier Sarah, and Francois Sabot
#
###################################################################################################################################

use strict;
use warnings;

use localConfig;

use toolbox;
use Switch;

##################################
#
#LAUNCHING
#
##################################

our ($commandLine, $requirement, $sample, $configInfo, $jobList, %jobHash);

#Hash for the different commands for schedulers
our %schedulerCommands={sge=>{run=>"qsub",test=>"qstat",info=>"qacct",parser=>{position=>2,motif=>"\\s"}},
			slurm=>{run=>"sbatch",test=>"squeue",info=>"sacct",parser=>{position=>3,motif=>"\\s"}},
			mprun=>{run=>"ccc_mprun",test=>"ccc_mstat",info=>"ccc_macct",parser=>{position=>3,motif=>"\\s"}},
			lsf=>{run=>"bsub",test=>"bjobs",info=>"bacct",parser=>{position=>2,motif=>"<\|>"}}};

#Requirement means the job needs to be achieved for the next steps or it is not a blocking job?
# A zero value (0) means mandatory
# Any non-zero value means not blocking job

sub launcher { #Global function for launching, will recover the command to be launch and will re-dispatch to normal or other scheduler
    
    ($commandLine,$requirement, $sample, $configInfo) = @_;
    
    #Picking up sample name
    
    $sample=`basename $sample` or die("ERROR : $0 : Cannot pickup the basename for $sample: $!\n");
    chomp $sample;
    
    my $hashCapability = &checkingCapability;
    
    my $runOutput;
       
    switch (1)
    {
        case ($hashCapability->{"sge"} && defined $$configInfo{"sge"}){$runOutput = &schedulerRun("sge")} #For SGE running
        case ($hashCapability->{"slurm"} && defined $$configInfo{"slurm"}){$runOutput = &schedulerRun("slurm")} #For SLURM running
	case ($hashCapability->{"mprun"} && defined $$configInfo{"mprun"}){$runOutput = &schedulerRun("mprun")} #For mprun running
	case ($hashCapability->{"lsf"} && defined $$configInfo{"lsf"}){$runOutput = &schedulerRun("lsf")} #For lsf running
        
        #If no scheduler available or configurated in the config info file, let's run it in a normal way
        else {$runOutput = &normalRun};
    }
    
    ##DEBUG    toolbox::exportLog("WARNING : scheduler : run output is $runOutput",2);
    
    if ($runOutput == 0 && $requirement == 0)
    {
	#The job has to succeed either it will kill all other jobs
        toolbox::exportLog("ERROR: scheduler::launcher on $sample: ".$commandLine."\nThe job cannot be achieved and is mandatory, thus the whole analysis is stop\n",0);
    
	return 0;
    }
    
    return $runOutput;
}

sub checkingCapability { #Will test the capacity of launching using various schedulers on the current system
    
    my %capabilityValue;
    
    #SGE test
    $capabilityValue{"sge"} = `qsub -help 2>/dev/null | grep usage`; #Will provide a not-empty output if SGE is installed
    chomp $capabilityValue{"sge"};
    
    #SLURM test
    $capabilityValue{"slurm"}=`sbatch -V 2>/dev/null | grep slurm`; #Will provide a not-empty output if SLURM is installed
    chomp $capabilityValue{"slurm"};
    
    #mprun test
    $capabilityValue{"mprun"}=`ccc_mprun -h 2>&1 | grep usage`; #Will provide a not-empty output if mprun is installed
    chomp $capabilityValue{"mprun"};
    
    #lsf test
    $capabilityValue{"lsf"}=`bsub -h 2>&1 | grep -i usage`; #Will provide a not-empty output if lsf is installed
    chomp $capabilityValue{"lsf"};
    
    
    #Returning infos as a reference
    return \%capabilityValue;
}


sub normalRun { #For running in normal mode, ie no scheduler
    
    #BASED ON TOOLBOX::RUN, but will not stop the whole pipeline for an error
    use Capture::Tiny qw(capture);
        
    toolbox::exportLog("INFOS: scheduler::normalRun : $commandLine\n",1);
    
    ##Execute the command
    my ($result,$stderr)=capture {` $commandLine `};
    
    ##Log export according to the error
    if ($?==0) #Success, no error
    {
	##DEBUG toolbox::exportLog("INFOS: scheduler::normalRun on $sample: ".$result."\n--".$stderr."\n",1);
	return 1;
    }
    else  #Error, the job cannot be achieved for any reason
    {
	##DEBUG
	toolbox::exportLog("WARNING: scheduler::normalRun on $sample: ".$result."\n--".$stderr."\nThe $sample data set has provoked and error, and was not analyzed anymore.\n",2);
	return 0;
    }
    
}

sub schedulerRun{
    
    my ($scheduler) = @_;
    
    my $OptionsHash=toolbox::extractHashSoft($configInfo,$scheduler);
    my $Options=toolbox::extractOptions($OptionsHash);
    
     #Picking up ENV variable
    my $envOptionsHash=toolbox::extractHashSoft($configInfo,"env");
    my $envOptions=toolbox::extractOptions($envOptionsHash,"=","\n");
    
    
    #Creating the bash script for scheduler to launch the command
    my $date =`date +%Y_%m_%d_%H_%M_%S`;
    chomp $date;
    my $scriptName="~/schedulerScript_".$date.".sh";
    my $bashScriptCreationCommand= "echo \"#!/bin/bash\n".$envOptions."\n".$commandLine."\nexit 0;\" | cat - > $scriptName && chmod 777 $scriptName";
    toolbox::run($bashScriptCreationCommand);
    ##DEBUG toolbox::exportLog("INFOS : $0 : Created the scheduler bash file",1);
    
    #Adding scheduler options
    my $launcherCommand = $schedulerCommands{$scheduler}{run}." ".$Options." ".$scriptName;
    $launcherCommand =~ s/ +/ /g; #Replace multiple spaces by a single one, to have a better view...
    ##DEBUG toolbox::exportLog($launcherCommand,2);
    my $currentJID = `$launcherCommand`;
    
    if ($!) #There are errors in the launching...
    {
        warn ("WARNING : $0 : Cannot launch the job for $sample: $!\n");
        $currentJID = "";
    }
        
    #Parsing infos and informing logs
    chomp $currentJID;
    
    unless ($currentJID) #The job has no output in STDOUT, ie there is a problem...
    {
        return 0; #Returning to launcher subprogram the error type
    }
    
    toolbox::exportLog("INFOS: $0 : Correctly launched for $sample in $scheduler mode through the command:\n\t$launcherCommand\n",1);
    
    my @infosList=split /$schedulerCommands{$scheduler}{parser}{motif}/, $currentJID; 
    $currentJID = $infosList[$schedulerCommands{$scheduler}{parser}{position}];

    return $currentJID;

}

sub waiter
{ #Global function for waiting, will recover the jobID to survey and will re-dispatch to scheduler
    
    ($jobList,my $jobsInfos) = @_;
    
    %jobHash = %{$jobsInfos};
        
    my $hashCapability = &checkingCapability;
    my $stopWaiting;
    switch (1)
    {
        case ($hashCapability->{"sge"} && defined $$configInfo{"sge"}){$stopWaiting = &schedulerWait("sge")} #For SGE running
        case ($hashCapability->{"slurm"} && defined $$configInfo{"slurm"}){$stopWaiting = &schedulerWait("slurm")} #For SLURM running
	case ($hashCapability->{"mprun"} && defined $$configInfo{"mprun"}){$stopWaiting = &schedulerWait("mprun")} #For mprun running
	case ($hashCapability->{"lsf"} && defined $$configInfo{"lsf"}){$stopWaiting = &schedulerWait("lsf")} #For lsf running

    }
    return $stopWaiting;
}

sub schedulerWait {
    my ($scheduler) = @_;
    
    my $nbRunningJobs = 1;
    my @jobsInError=();
    
    ##Waiting for jobs to finish
    while ($nbRunningJobs)
    {  
      #Picking up the number of currently running jobs
      my $queueCommand = "$schedulerCommands{$scheduler}{test} | egrep -c \"$jobList\"";
      $nbRunningJobs = `$queueCommand`;
      chomp $nbRunningJobs;
      sleep 50;
    }
    
    #Compiling infos about sge jobs: jobID, node number, exit status
    sleep 25;#Needed for system to register infos...
    
    my $formatting;
    
    switch (1)
    {
        case ($scheduler eq "sge"){$formatting = &schedulerFormatter("sge")} #For SGE running
        case ($scheduler eq "slurm"){$formatting = &schedulerFormatter("slurm")} #For SLURM running
	case ($scheduler eq "mprun"){$formatting = &schedulerFormatter("mprun")} #For mprun running
	case ($scheduler eq "lsf"){$formatting = &schedulerFormatter("lsf")} #For lsf running

    }

    return $formatting;
}

sub schedulerFormatter{
    
    my ($scheduler) = @_;
    my @jobsInError;
    
    #Preparing table reporting
    toolbox::exportLog("\n#########################################\nJOBS SUMMARY\n#########################################
#\n---------------------------------------------------------
#Individual\tJobID\tNode\tExitStatus
#---------------------------------------------------------",1);
    
    foreach my $individual (sort {$a cmp $b} keys %jobHash)
    {
      my $acctCommand = $schedulerCommands{$scheduler}{info}." -j ".$jobHash{$individual}." 2>&1";
      my $acctOutput = `$acctCommand`;
      my $outputLine= $individual."\t".$jobHash{$individual};
      
      chomp $acctOutput;
      if ($acctOutput =~ "-bash: " or $acctOutput =~ "installed")
      {
        #IF acct cannot be run on the node
        $outputLine .= "NA\tNA\n";
        toolbox::exportLog($outputLine,1);
        next;
      }

      if ($scheduler eq "sge")
      {
	my @linesAcct = split /\n/, $acctOutput;
	while (@linesAcct) #Parsing the acct output
	{
	    my $currentLine = shift @linesAcct;
	    if ($currentLine =~ m/^hostname/) #Picking up hostname
	    {
	      $currentLine =~ s/hostname     //;
	      $outputLine .= "\t".$currentLine."\t";
	    }
	    elsif ($currentLine =~ m/^exit_status/) #Picking up exit status
	    {
	      $currentLine =~ s/exit_status  //;
	      if ($currentLine == 0) #No errors
	      {
	        $currentLine = "Normal";
	      }
	      else
	      {
	        push @jobsInError, $individual;
	        $currentLine = "Error";
	      }
	      $outputLine .= $currentLine;
	    }
	    else
	    {
	      next;
	    }
	}
      }
      elsif ($scheduler eq "mprun" or $scheduler eq "slurm")
      {    
	if ($acctOutput=~ m/COMPLETED/) #No errors
	{
	    $outputLine .= "\tNA\tNormal";
	}
	else
	{
	    push @jobsInError, $individual;
	    $outputLine .= "\tNA\tError";
	}
      }
      elsif ($scheduler eq "lsf")
      {
	if ($acctOutput=~ m/Total number of done jobs: 1 Total number of exited jobs: 0/) #No errors
	{
	  $outputLine = "\tNA\tNormal";
	}
	else
	{
	  push @jobsInError, $individual;
	  $outputLine = "\tNA\tError";
	}
      }
      toolbox::exportLog($outputLine,1);
      
    }
    toolbox::exportLog("---------------------------------------------------------\n",1);#To have a better table presentation
  
    if (scalar @jobsInError)
    {
	#at least one job has failed
	return \@jobsInError;
    }
    return 1;
}

1;

=head1 NAME

    Package I<scheduler> 

=head1 SYNOPSIS

	use scheduler;
    
	scheduler::launcher($launcherCommand, $requirement, $sample, $configInfo);
    
	scheduler::waiter($jobList,$jobInfos);

=head1 DESCRIPTION

    Package scheduler will prepare and launch the different command in a scheduler if possible and requested. Either, it will launch it through the normal way, using a quite identical way to toolbox::run
    !!DIFFERENCE with toolbox::run is that an abnormal job will be a blocking one ONLY if requirement is of a zero value (0). Else, the job error will be warned but it will not block the whole system.

=head2 FUNCTIONS

=head3 scheduler::launcher

This module will prepare and decide to which scheduler sending the command. It takes as arguments the command $launcherCommand, the state of the job (0 mandatory finishing, non-0 not mandatory) $requirement, the sample name $sample and the $configInfo hash for configuration

=head3 scheduler::waiter

This module will allow the job launched through a scheduler to be wait to finish.
It takes as arguments the list of jobs $jobList and the reference of the hash for the informations about the jobs (sample name) $jobInfos



=head1 AUTHORS

Intellectual property belongs to IRD, CIRAD and South Green developpement plateform for all versions also for ADNid for v2 and v3 and INRA for v3
Written by Cecile Monat, Christine Tranchant, Cedric Farcy, Maryline Summo, Julie Orjuela-Bouniol, Sebastien Ravel, Gautier Sarah, and Francois Sabot

=head1 SEE ALSO

L<http://www.southgreen.fr/>

=cut
