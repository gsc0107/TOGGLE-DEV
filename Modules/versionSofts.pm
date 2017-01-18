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


sub bowtieBuildVersion
{
	`$bowtieBuild --version > /tmp/out.txt` ; #We works with the STDOUT output
	my $version = `grep "bowtie-build version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::bowtieBuildVersion : Can not grep bowtieBuild version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub bowtie2BuildVersion
{
	`$bowtie2Build --version > /tmp/out.txt` ; #We works with the STDOUT output
	my $version = `grep "bowtie2-build version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::bowtie2BuildVersion : Can not grep bowtie2Build version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub bwaVersion
{
	`$bwa 2> /tmp/out.txt` ; #We works with the STDERR output
	my $version = `grep "Version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::bwaVersion : Can not grep bwa version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub cufflinksVersion
{
	`$cufflinks/cufflinks 2> /tmp/out.txt`;#We works with the STDERR output
	my $version = `grep "cufflinks v" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::cufflinksVersion : Can not grep cufflinks version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub cutadaptVersion
{
	`$cutadapt 2> /tmp/out.txt`;#We works with the STDERR output
	my $version = `grep "cutadapt version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::cutadaptVersion : Can not grep cutadapt version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub fastqcVersion
{
	my $version = `$fastqc -v` or die toolbox::exportLog("ERROR: versionSoft::fastqcVersion : Can not grep fastqc version\n", 0);;#We works with the STDERR output
	chomp($version);
	return $version;
}

sub fastxToolkitVersion
{
	`$fastxTrimmer -h 1> /tmp/out.txt`; #We works with the STDOUT output
	my $version = `grep "FASTX Toolkit" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::fastqxToolkitVersion : Can not grep fastxToolkit version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub gatkVersion
{
	my $version = `$GATK -version` or die toolbox::exportLog("ERROR: versionSoft::gatkVersion : Can not grep gatk version\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub htseqcountVersion
{
	`$htseqcount -h 1> /tmp/out.txt`; #We works with the STDOUT output
	my $version = `grep "version" /tmp/out | cut -d"," -f 2,2` or die toolbox::exportLog("ERROR: versionSoft::htseqcountVersion : Can not grep htseqcount version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub javaVersion
{
	`$java -version 2> /tmp/out.txt`; #We works with the STDERR output
	my $version = `grep "version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::javaVersion : Can not grep java version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub picardToolsVersion
{
	my $version = `$picard CheckFingerprint --version 2>&1` or die toolbox::exportLog("ERROR: versionSoft::picardToolsVersion : Can not grep picardTools version\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub stacksVersion
{
	my $version = `$stacks -v 2>&1` or die toolbox::exportLog("ERROR: versionSoft::stacksVersion : Can not grep stacks version\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub samtoolsVersion
{
	`$samtools --help 1> /tmp/out.txt`; #We works with the STDOUT output
	my $version = `grep "Version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::samtoolsVersion : Can not grep samtools version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

sub snpeffVersion
{
	my $version = `$snpEff -version 2>&1` or die toolbox::exportLog("ERROR: versionSoft::snpeffVersion : Can not grep snpeff version\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub tgiclVersion
{
	return "No version available";
}

sub tophatVersion
{
	my $version = `tophat -v` or die toolbox::exportLog("ERROR: versionSoft::tophatVersion : Can not grep tophat version\n", 0); #We works with the STDOUT output
	chomp($version);
	return $version;
}

sub trinityVersion
{
	`$trinity --version > /tmp/out.txt`; #We works with the STDOUT output
	my $version = `grep "Trinity version" /tmp/out` or die toolbox::exportLog("ERROR: versionSoft::trinityVersion : Can not grep trinity version\n", 0);
	unlink("/tmp/out.txt");
	chomp($version);
	return $version;
}

#my $configInfo=toolbox::readFileConf($fileConf);




1;

=head1 NAME

    Package I<versionSofts> 

=head1 SYNOPSIS

        use versionSofts;
    
        versionSofts::returnVersion ();
 
=head1 DESCRIPTION

    Package Version Softs
	
=head2 FUNCTIONS

=head3 versionSofts::returnVersion

This module return soft version

=head1 AUTHORS

Intellectual property belongs to IRD, CIRAD and South Green developpement plateform 
Written by Cecile Monat, Ayite Kougbeadjo, Marilyne Summo, Cedric Farcy, Mawusse Agbessi, Christine Tranchant and Francois Sabot

=head1 SEE ALSO

L<http://www.southgreen.fr/>

=cut
