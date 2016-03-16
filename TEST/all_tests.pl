#!/usr/bin/env perl

###################################################################################################################################
#
# Copyright 2014 IRD-CIRAD
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
# Intellectual property belongs to IRD, CIRAD and South Green developpement plateform
# Written by Cecile Monat, Christine Tranchant, Ayite Kougbeadjo, Cedric Farcy, Mawusse Agbessi, Marilyne Summo, and Francois Sabot
#
###################################################################################################################################



# TESTS :
# *** FASTQ ***
#   - TOGGLE fastq pairedOneIndividuArcad
#   - TOGGLE fastq pairedTwoIndividusGzippedIrigin
#   - TOGGLE fastq pairedTwoIndividusIrigin 
#   - TOGGLE fastq pairedTwoIndividusIrigin en QSUB
#   - TOGGLE fastq singleOneIndividuIrigin
#   - TOGGLE fastq singleTwoIndividuIrigin

# *** RNASeq ***
#   - TOGGLE RNASeq pairedOneIndividu
#   - TOGGLE RNASeq singleOneIndividu
# *** samBam ***
#   - TOGGLE samBam oneBam
#   - TOGGLE samBam oneSam
#   - TOGGLE samBam twoBamsIrigin
# *** VCF ***
#   - TOGGLE VCF singleVCF
#   - TOGGLE VCF vcfForRecalibration



use strict;
use warnings;


######################
## SUB
######################

sub sedFunction(my $file):
{
    # Change the TOGGLE addaptator configuration file
    my $sed="sed -i -e 's|-b ADAPTATOR1REVERSE -B ADAPTATOR1REVERSE|-b GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG  -B GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG|' ". $file;
    #print $sed."\n\n";
    system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
    $sed="sed -i -e 's|-b ADAPTATOR1FORWARD -B ADAPTATOR1FORWARD|-b GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG -B GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG|' ". $file;
    #print $sed."\n\n";
    system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
}








#####################
## PATH for datas test
#####################
#fastq
my $dataFastqpairedOneIndividuArcad = "../DATA/testData/fastq/pairedOneIndividuArcad";
my $dataFastqpairedTwoIndividusGzippedIrigin = "../DATA/testData/fastq/pairedTwoIndividusGzippedIrigin";
my $dataFastqpairedTwoIndividusIrigin = "../DATA/testData/fastq/pairedTwoIndividusIrigin";
my $dataFastqsingleOneIndividuIrigin = "../DATA/testData/fastq/singleOneIndividuIrigin";
my $dataFastqsingleTwoIndividuIrigin = "../DATA/testData/fastq/singleTwoIndividuIrigin";
#rnaseq
my $dataRNAseqPairedOneIndividu = "../DATA/testData/rnaseq/pairedOneIndividu";
my $dataRNAseqSingleOneIndividu = "../DATA/testData/rnaseq/singleOneIndividu";
#samBam
my $dataSamBamOneBam = "../DATA/testData/samBam/oneBam";
my $dataSamBamOneSam = "../DATA/testData/samBam/oneSam";
my $dataSamBamTwoBamsIrigin = "../DATA/testData/samBam/twoBamsIrigin";
#vcf
my $dataVcfSingleVCF = "../DATA/testData/vcf/singleVCF";
my $dataVcfVcfForRecalibration = "../DATA/testData/vcf/vcfForRecalibration";
# references files
my $dataRefIrigin = "../DATA/Bank/referenceIrigin.fasta";
my $dataRefArcad = "../DATA/Bank/referenceArcad.fasta";
my $dataRefRnaseq = "../DATA/Bank/referenceRnaseq.fasta";
my $dataRefRnaseqGFF = "../DATA/Bank/referenceRnaseq.gff3";



#####################
## SNPdiscoveryPaired for no SGE mode pairedOneIndividuArcad
#####################
# Copy file config SNPdiscoveryPaired for no SGE mode
my $fileSNPPairedIni="../SNPdiscoveryPaired.config.txt";          # Path of the SNPdiscoveryPaired.config.txt
my $fileSNPPairedNoSGE="SNPdiscoveryPairedTest.config.txt";

my $cmd="cp $fileSNPPairedIni $fileSNPPairedNoSGE";
print "#### Copy conf file SNPdiscoveryPaired : $cmd\n";
system($cmd) and die ("#### ERROR COPY CONFIG FILE: $cmd\n");     # Copy into TEST

# Change the TOGGLE addaptator configuration file

sedFunction($fileSNPPairedNoSGE);
exit;

my $sed="sed -i -e 's|-b ADAPTATOR1REVERSE -B ADAPTATOR1REVERSE|-b GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG  -B GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG|' ". $fileSNPPairedNoSGE;
#print $sed."\n\n";
system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
$sed="sed -i -e 's|-b ADAPTATOR1FORWARD -B ADAPTATOR1FORWARD|-b GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG -B GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG|' ". $fileSNPPairedNoSGE;
#print $sed."\n\n";
system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");

#run with new fileconf SNPdiscoveryPaired for no SGE mode to pairedOneIndividuArcad
my $testingDir="../DATA-TEST/pairedOneIndividuArcad";
my $cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");

my $runcmd = "toggleGenerator.pl -c ".$fileSNPPairedNoSGE." -d ".$dataFastqpairedOneIndividuArcad." -r ".$dataRefArcad." -o ".$testingDir;
system("$runcmd") and die "#### ERROR : Can't run TOGGLE for pairedOneIndividuArcad";

# check final results














my $fileSNPSingleIni="../SNPdiscoverySingle.config.txt";          # Path of the SNPdiscoverySingle.config.txt
my $fileSNPSingle="SNPdiscoverySingleTest.config.txt";


my $fileRNASeqIni="../RNASeq.config.txt";          # Path of the RNASeq.config.txt
my $fileRNASeq="RNASeqTest.config.txt";




# *** FASTQ ***
#   - TOGGLE fastq pairedOneIndividuArcad

