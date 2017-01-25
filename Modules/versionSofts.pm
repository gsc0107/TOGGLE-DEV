package versionSofts;

###################################################################################################################################
#
# Copyright 2014-2017 IRD-CIRAD-INRA-ADNid
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
# Version 3 written by Cecile Monat, Christine Tranchant, Laura Helou, Abdoulaye Diallo, Julie Orjuela-Bouniol, Sebastien Ravel, Gautier Sarah, and Francois Sabot
#
###################################################################################################################################

use strict;
use warnings;
use localConfig;
use toolbox;
use Data::Dumper;
use Switch;

sub bowtieBuildVersion
{
	`$bowtieBuild --version > /tmp/out.txt` ; #We works with the STDOUT output
	my $version = `grep "bowtie-build version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::bowtieBuildVersion : Can not grep bowtieBuild version.\nPlease check your bowtie installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub bowtie2BuildVersion
{
	`$bowtie2Build --version > /tmp/out.txt` ; #We works with the STDOUT output
	my $version = `grep "bowtie2-build version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::bowtie2BuildVersion : Can not grep bowtie2Build version\nPlease check your bowtie2 installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub bwaVersion
{
	`$bwa 2> /tmp/out.txt` ; #We works with the STDERR output
	my $version = `grep "Version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::bwaVersion : Can not grep bwa version\nPlease check your bwa installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub cufflinksVersion
{
	`$cufflinks/cufflinks 2> /tmp/out.txt`;#We works with the STDERR output
	my $version = `grep "cufflinks v" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::cufflinksVersion : Can not grep cufflinks version\nPlease check your cufflinks installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub cutadaptVersion
{
	`$cutadapt 2> /tmp/out.txt`;#We works with the STDERR output
	my $version = `grep "cutadapt version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::cutadaptVersion : Can not grep cutadapt version\nPlease check your cutadapt installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub fastqcVersion
{
	my $version = `$fastqc -v` or die toolbox::exportLog("ERROR: versionSoft::fastqcVersion : Can not grep fastqc version\nPlease check your fastqc installation.\n", 0);;#We works with the STDERR output
	chomp($version);
	return $version;
}

sub fastxToolkitVersion
{
	`$fastxTrimmer -h 1> /tmp/out.txt`; #We works with the STDOUT output
	my $version = `grep "FASTX Toolkit" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::fastqxToolkitVersion : Can not grep fastxToolkit version\nPlease check your fastxToolkit installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub gatkVersion
{
	my $version = `$GATK -version` or die toolbox::exportLog("ERROR: versionSoft::gatkVersion : Can not grep gatk version\nPlease check your GATK installation.\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub htseqcountVersion
{
	`$htseqcount -h 1> /tmp/out.txt`; #We works with the STDOUT output
	my $version = `grep "version" /tmp/out | cut -d"," -f 2,2` or die toolbox::exportLog("ERROR: versionSoft::htseqcountVersion : Can not grep htseqcount version\nPlease check your HTseq-Count installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub javaVersion
{
	`$java -version 2> /tmp/out.txt`; #We works with the STDERR output
	my $version = `grep "version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::javaVersion : Can not grep java version\nPlease check your java installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub picardToolsVersion
{
	my $version = `$picard CheckFingerprint --version 2>&1` or die toolbox::exportLog("ERROR: versionSoft::picardToolsVersion : Can not grep picardTools version\nPlease check your picardtools installation.\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub stacksVersion
{
	my $version = `$stacks -v 2>&1` or die toolbox::exportLog("ERROR: versionSoft::stacksVersion : Can not grep stacks version\nPlease check your stacks installation.\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub samtoolsVersion
{
	`$samtools --help 1> /tmp/out.txt`; #We works with the STDOUT output
	my $version = `grep "Version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::samtoolsVersion : Can not grep samtools version\nPlease check your samtools installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub snpeffVersion
{
	my $version = `$snpEff -version 2>&1` or die toolbox::exportLog("ERROR: versionSoft::snpeffVersion : Can not grep snpeff version\nPlease check your snpeff installation.\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub tgiclVersion
{
	return "No version available";
}

sub tophatVersion
{
	my $version = `tophat -v` or die toolbox::exportLog("ERROR: versionSoft::tophatVersion : Can not grep tophat version\nPlease check your tophat installation.\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub trinityVersion
{
	`$trinity --version > /tmp/out.txt`; #We works with the STDOUT output
	my $version = `grep "Trinity version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::trinityVersion : Can not grep trinity version\nPlease check your trinity installation.\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}


sub writeLogVersion
{
	my ($fileConf, $version) = @_;
	my %softPathVersion = (	"java"		=> javaVersion,
							"toggle"	=> $version);

	toolbox::checkFile($fileConf);
	my $configInfo=toolbox::readFileConf($fileConf);
	my $hashOrder=toolbox::extractHashSoft($configInfo,"order");	#Picking up the options for the order of the pipeline

	for my $softOrder ( values %{ $hashOrder } )
	{
		print $softOrder."\n";

		switch (1)
		{
			#FOR bwa.pm
			case ($softOrder =~ m/^bwa.*/i){$softPathVersion{"bwa"}= bwaVersion if not defined $softPathVersion{"bwa"}; }

			#FOR samTools.pm
			case ($softOrder =~ m/^samtools.*/i){$softPathVersion{"samtools"}= samtoolsVersion if not defined $softPathVersion{"samtools"};}

			#FOR picardTools.pm
			case ($softOrder =~ m/^picard.*/i){$softPathVersion{"picard"}= picardToolsVersion if not defined $softPathVersion{"picard"};}

			#FOR gatk.pm
			case ($softOrder =~ m/^gatk.*/i){$softPathVersion{"GATK"}= gatkVersion if not defined $softPathVersion{"GATK"};}

			#FOR fastqc
			case ($softOrder =~ m/^fastqc/i){$softPathVersion{"fastqc"}= fastqcVersion if not defined $softPathVersion{"fastqc"}}

			#FOR fastxToolkit
			case ($softOrder =~ m/^fastx.*/i){$softPathVersion{"fastxTrimmer"}= fastxToolkitVersion if not defined $softPathVersion{"fastxTrimmer"};}

			#FOR tophat.pm
			case ($softOrder =~ m/^bowtie2.*/i){$softPathVersion{"bowtie2Build"}= bowtie2BuildVersion if not defined $softPathVersion{"bowtie2Build"}; }
			case ($softOrder =~ m/^bowtie/i){$softPathVersion{"bowtieBuild"}= bowtieBuildVersion if not defined $softPathVersion{"bowtieBuild"}; }
			case ($softOrder =~ m/^tophat.*/i){$softPathVersion{"tophat2"}= tophatVersion if not defined $softPathVersion{"tophat2"};
											   $softPathVersion{"bowtieBuild"}= bowtieBuildVersion if not defined $softPathVersion{"bowtieBuild"};
											   $softPathVersion{"bowtie2Build"}= bowtie2BuildVersion if not defined $softPathVersion{"bowtie2Build"};}

			#FOR cufflinks.pm
			case ($softOrder =~ m/^cufflinks.*/i){$softPathVersion{"cufflinks"}= cufflinksVersion if not defined $softPathVersion{"cufflinks"}; }
			case ($softOrder =~ m/^cuffdiff.*/i){$softPathVersion{"cuffdiff"}= cufflinksVersion if not defined $softPathVersion{"cuffdiff"}; }
			case ($softOrder =~ m/^cuffmerge.*/i){$softPathVersion{"cuffmerge"}= cufflinksVersion if not defined $softPathVersion{"cuffmerge"}; }

			#FOR HTSeq
			case ($softOrder =~ m/^htseq.*/i){$softPathVersion{"htseqcount"}= htseqcountVersion if not defined $softPathVersion{"htseqcount"}; }

			#FOR snpEff.pm
			case ($softOrder =~ m/^snp.*/i){$softPathVersion{"snpEff"}= snpeffVersion if not defined $softPathVersion{"snpEff"};}

			#FOR processRadtags.pm
			case ($softOrder =~ m/process.*/i){$softPathVersion{"stacks"}= stacksVersion if not defined $softPathVersion{"stacks"};}

			#FOR cutadapt functions
			case ($softOrder =~ m/^cutadapt/i){$softPathVersion{"cutadapt"}= cutadaptVersion if not defined $softPathVersion{"cutadapt"};}

			#FOR TGICL
			case ($softOrder =~ m/^tgicl/i){$softPathVersion{"TGICL"}= tgiclVersion if not defined $softPathVersion{"TGICL"};}

			#FOR trinity
			case ($softOrder =~ m/^trinity/i){$softPathVersion{"trinity"}= trinityVersion if not defined $softPathVersion{"trinity"};}

			else {toolbox::exportLog("ERROR : $0 : the $softOrder function or software is unknown to TOGGLE, cannot continue",0);}; # Name unknown to TOGGLE, must stop
		}
	}
	## DEBUG print Dumper(%softPathVersion);

	open (my $fhConfig, "<", "$toggle/Modules/localConfig.pm");
	while (my $line = <$fhConfig>)
	{
		chomp $line;
		chop $line; #Remove the last character, ie ";"
		next unless $line =~ m/^our \$/;
		my ($soft,$value) = split /=/, $line;
		$soft =~ s/our| |\$//g;
		if (defined $value)
		{
			$value =~ s/\"//g;
			$value =~ s/\w+ |\$|-//g unless $soft =~ m/java|toggle/i;
			$value =~ s/^ //;
		}
		else
		{
			$value = "NOT DEFINED";
		}
		toolbox::exportLog("$soft : $value : $softPathVersion{$soft}",1) if defined $softPathVersion{$soft};
	}




}

1;



=head1 NAME

    Package I<versionSofts> 

=head1 SYNOPSIS

        use versionSofts;
    
        versionSofts::writeLogVersion ();
 
=head1 DESCRIPTION

    Package Version Softs
	
=head2 FUNCTIONS

=head3 versionSofts::writeLogVersion

This module return soft version

=head1 AUTHORS

Intellectual property belongs to IRD, CIRAD and South Green developpement plateform 
Written by Cecile Monat, Ayite Kougbeadjo, Marilyne Summo, Cedric Farcy, Mawusse Agbessi, Christine Tranchant and Francois Sabot

=head1 SEE ALSO

L<http://www.southgreen.fr/>

=cut
