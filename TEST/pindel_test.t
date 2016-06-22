#!/usr/bin/perl

###################################################################################################################################
#
# Copyright 2014-2015 IRD-CIRAD-INRA-ADNid
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

#Will test if pindel works correctly
use strict;
use warnings;
use Test::More 'no_plan'; #Number of tests, to modify if new tests implemented. Can be changed as 'no_plan' instead of tests=>11 .
use Test::Deep;
use Data::Dumper;
use lib qw(../Modules/);

########################################
#Test of the use of gatk modules
########################################
use_ok('toolbox') or exit;
use_ok('pindel') or exit;

can_ok('pindel','pindelRun');

use toolbox;
use pindel;

my $expectedData="../../DATA/expectedData/";

#########################################
#Remove files and directory created by previous test
#########################################
my $testingDir="../DATA-TEST/pindelTestDir";
my $creatingDirCom="rm -Rf $testingDir ; mkdir -p $testingDir";                                    #Allows to have a working directory for the tests
system($creatingDirCom) and die ("ERROR: $0 : Cannot execute the command $creatingDirCom\n$!\n");

chdir $testingDir or die ("ERROR: $0 : Cannot go into the new directory with the command \"chdir $testingDir\"\n$!\n");


#######################################
#Creating the IndividuSoft.txt file
#######################################
my $creatingCommand="echo \"pindel\nTEST\" > individuSoft.txt";
system($creatingCommand) and die ("ERROR: $0: Cannot create the individuSoft.txt file with the command $creatingCommand \n$!\n");

#######################################
#Cleaning the logs for the test
#######################################
my $cleaningCommand="rm -Rf pindel_TEST_log.*";
system($cleaningCommand) and die ("ERROR: $0: Cannot clean the previous log files for this test with the command $cleaningCommand \n$!\n");


##########################################
#pindelRun test
##########################################

#Input file
my $refFile = "../../DATA/Bank/referencePindelChr1.fasta";
my $pindelConfigFile = $expectedData."configChr1Pindel";


#my $originalRefFile = $expectedData."/".$refFile;    
#my $cpCmd = "cp $originalRefFile ."; # command to copy the original Ref fasta file into the test directory
#system ($cpCmd) and die ("ERROR: $0 : Cannot copy the file $originalRefFile in the test directory with the command $cpCmd\n$!\n"); 

#Output file
my $outputPindelPrefix = "referencePindelChr1.PINDEL";

#execution test
is(pindel::pindelRun($pindelConfigFile,$outputPindelPrefix,$refFile),1,'pindel::pindelRun');

# expected output test
my $observedOutput = `ls`;
my @observedOutput = split /\n/,$observedOutput;
my @expectedOutput = ('individuSoft.txt','pindel_TEST_log.e','pindel_TEST_log.o','referencePindelChr1.PINDEL_BP','referencePindelChr1.PINDEL_CloseEndMapped','referencePindelChr1.PINDEL_D','referencePindelChr1.PINDEL_INT_final','referencePindelChr1.PINDEL_INV','referencePindelChr1.PINDEL_LI','referencePindelChr1.PINDEL_RP','referencePindelChr1.PINDEL_SI','referencePindelChr1.PINDEL_TD');
#

is_deeply(\@observedOutput,\@expectedOutput,'pindel::pindelRun - output list');
#
## expected content test

$observedOutput = `wc -l *`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ("    2 individuSoft.txt","    0 pindel_TEST_log.e","    2 pindel_TEST_log.o","    0 referencePindelChr1.PINDEL_BP","    0 referencePindelChr1.PINDEL_CloseEndMapped","  139 referencePindelChr1.PINDEL_D","    0 referencePindelChr1.PINDEL_INT_final","   12 referencePindelChr1.PINDEL_INV","    0 referencePindelChr1.PINDEL_LI","    0 referencePindelChr1.PINDEL_RP","  105 referencePindelChr1.PINDEL_SI","    5 referencePindelChr1.PINDEL_TD","  265 total" );

is_deeply(\@observedOutput,\@expectedOutput,'pindel::pindelRun - output number line liste');

my $cmd = 'grep "\@FCD0REEACXX:8:1204:12111:37630#GTTACTTG_32/2" '.$outputPindelPrefix.'_D';
#print $cmd;
my $expectedLastLine="                                                                    GAATCTGGGTCGTCCGATGCGAACGAGCACTCGGCGTCGGGTCGGAGGTGAGGTCTCGAAACCCTAGCTGCTCCG		-	30066	37	pindelBam	\@FCD0REEACXX:8:1204:12111:37630#GTTACTTG_32/2";  
my $observedLastLine=`$cmd`;
chomp($observedLastLine);
#my @withoutName = split ("LN:", $observedLastLine); 
#$observedLastLine = $withoutName[0];       # just to have the md5sum result
is($observedLastLine,$expectedLastLine,'pindel::pindelRun- output content');

##########################################
#pindelConfig test
##########################################

#Input file
my $bam = "../../DATA/testData/samBam/samBamSV/pindelBam.bam";

my $listOfBam;
push (@{$listOfBam}, $bam);

#my $originalRefFile = $expectedData."/".$refFile;    
#my $cpCmd = "cp $originalRefFile ."; # command to copy the original Ref fasta file into the test directory
#system ($cpCmd) and die ("ERROR: $0 : Cannot copy the file $originalRefFile in the test directory with the command $cpCmd\n$!\n"); 

#Output file
#my $outputPindelPrefix = "referencePindelChr1.PINDEL";

#execution test
is(pindel::pindelConfig($listOfBam),1,'pindel::pindelConfig');
exit;
_END_

# expected output test
my $observedOutput = `ls`;
my @observedOutput = split /\n/,$observedOutput;
my @expectedOutput = ('individuSoft.txt','pindel_TEST_log.e','pindel_TEST_log.o','referencePindelChr1.PINDEL_BP','referencePindelChr1.PINDEL_CloseEndMapped','referencePindelChr1.PINDEL_D','referencePindelChr1.PINDEL_INT_final','referencePindelChr1.PINDEL_INV','referencePindelChr1.PINDEL_LI','referencePindelChr1.PINDEL_RP','referencePindelChr1.PINDEL_SI','referencePindelChr1.PINDEL_TD');
#

is_deeply(\@observedOutput,\@expectedOutput,'pindel::pindelRun - output list');
#
## expected content test

$observedOutput = `wc -l *`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ("    2 individuSoft.txt","    0 pindel_TEST_log.e","    2 pindel_TEST_log.o","    0 referencePindelChr1.PINDEL_BP","    0 referencePindelChr1.PINDEL_CloseEndMapped","  139 referencePindelChr1.PINDEL_D","    0 referencePindelChr1.PINDEL_INT_final","   12 referencePindelChr1.PINDEL_INV","    0 referencePindelChr1.PINDEL_LI","    0 referencePindelChr1.PINDEL_RP","  105 referencePindelChr1.PINDEL_SI","    5 referencePindelChr1.PINDEL_TD","  265 total" );

is_deeply(\@observedOutput,\@expectedOutput,'pindel::pindelRun - output number line liste');

my $cmd = 'grep "\@FCD0REEACXX:8:1204:12111:37630#GTTACTTG_32/2" '.$outputPindelPrefix.'_D';
#print $cmd;
my $expectedLastLine="                                                                    GAATCTGGGTCGTCCGATGCGAACGAGCACTCGGCGTCGGGTCGGAGGTGAGGTCTCGAAACCCTAGCTGCTCCG		-	30066	37	pindelBam	\@FCD0REEACXX:8:1204:12111:37630#GTTACTTG_32/2";  
my $observedLastLine=`$cmd`;
chomp($observedLastLine);
#my @withoutName = split ("LN:", $observedLastLine); 
#$observedLastLine = $withoutName[0];       # just to have the md5sum result
is($observedLastLine,$expectedLastLine,'pindel::pindelRun- output content');

1;
