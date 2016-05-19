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
use Test::More 'no_plan'; 
use Test::Deep;


######################
## SUB
######################

sub sedFunction
{
    my $file=$_[0];
    my $bool=defined($_[1])? $_[1] : 0;
    
    # Change the TOGGLE addaptator configuration file
    my $sed="sed -i -e 's|-b ADAPTATOR1REVERSE -B ADAPTATOR1REVERSE|-b GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG  -B GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG|' ". $file;
    #print $sed."\n\n";
    system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
    $sed="sed -i -e 's|-b ADAPTATOR1FORWARD -B ADAPTATOR1FORWARD|-b GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG -B GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG|' ". $file;
    #print $sed."\n\n";
    system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
    
    if ($bool)
    {
        my $sed="sed -i -e 's|#\$sge|\$sge|' ". $file;
        print $sed;
        system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
        $sed="sed -i -e 's|#-q YOURQUEUE.q|-q bioinfo.q|' ". $file;
        print $sed;
        system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
        $sed="sed -i -e 's|#-b Y|-b Y|' ". $file;
        print $sed;
        system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
        $sed="sed -i -e 's|#-V|-V|' ". $file;
        print $sed;
        system($sed) and die ("#### ERROR  SED COMMAND: $sed\n"); 
    }
    
    
}








#####################
## PATH for datas test
#####################

# references files
my $dataRefIrigin = "../DATA/Bank/referenceIrigin.fasta";
my $dataRefArcad = "../DATA/Bank/referenceArcad.fasta";
my $dataRefRnaseq = "../DATA/Bank/referenceRnaseq.fasta";
my $dataRefRnaseqGFF = "../DATA/Bank/referenceRnaseq.gff3";






#####################
## FASTQ TESTS
#####################
## TOGGLE fastq pairedOneIndividuArcad
#####################

my $dataFastqpairedOneIndividuArcad = "../DATA/testData/fastq/pairedOneIndividuArcad";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoveryPaired paired ARCAD / non SGE mode\n";
print "#################################################\n";

# Copy file config SNPdiscoveryPaired for no SGE mode
my $fileSNPPairedIni="../SNPdiscoveryPaired.config.txt";          # Path of the SNPdiscoveryPaired.config.txt
my $fileSNPPairedNoSGE="SNPdiscoveryPairedTest.config.txt";

my $cmd="cp $fileSNPPairedIni $fileSNPPairedNoSGE";
print "\n### COPY conf file SNPdiscoveryPaired : $cmd\n";
system($cmd) and die ("#### ERROR COPY CONFIG FILE: $cmd\n");     # Copy into TEST

# Change the TOGGLE addaptator configuration file
sedFunction($fileSNPPairedNoSGE);

#run with new fileconf SNPdiscoveryPaired for no SGE mode to pairedOneIndividuArcad
my $testingDir="../DATA-TEST/pairedOneIndividuArcad";
my $cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");


my $runCmd = "toggleGenerator.pl -c ".$fileSNPPairedNoSGE." -d ".$dataFastqpairedOneIndividuArcad." -r ".$dataRefArcad." -o ".$testingDir;
print "\n### $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for pairedOneIndividuArcad";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
my $observedOutput = `ls $testingDir/finalResults`;
my @observedOutput = split /\n/,$observedOutput;
my @expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedOneIndividu list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
my $expectedOutput="LOC_Os12g32240.1	864	.	C	T	350.77	PASS	AC=2;AF=1.00;AN=2;DP=10;FS=0.000;MLEAC=2;MLEAF=1.00;MQ=60.00;MQ0=0;QD=26.71;SOR=3.258	GT:AD:DP:GQ:PL	1/1:0,10:10:30:379,30,0";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedOneIndividu content ');



#####################
## FASTQ TESTS
#####################
## TOGGLE fastq pairedTwoIndividusGzippedIrigin
#####################

my $dataFastqpairedTwoIndividusGzippedIrigin = "../DATA/testData/fastq/pairedTwoIndividusGzippedIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoveryPaired / compressed fastq\n";
print "#################################################\n";

#run with new fileconf SNPdiscoveryPaired for no SGE mode to pairedOneIndividuArcad
$testingDir="../DATA-TEST/pairedTwoIndividusGzippedIrigin";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");


$runCmd = "toggleGenerator.pl -c ".$fileSNPPairedNoSGE." -d ".$dataFastqpairedTwoIndividusGzippedIrigin." -r ".$dataRefArcad." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for pairedTwoIndividusGzippedIrigin";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedTwoIndividusGzippedIrigin list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	irigin1	irigin3";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedTwoIndividusGzippedIrigin content ');



#####################
## FASTQ TESTS
#####################
## TOGGLE fastq pairedTwoIndividusIrigin 
#####################

my $dataFastqpairedTwoIndividusIrigin = "../DATA/testData/fastq/pairedTwoIndividusIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoveryPaired / paired IRIGIN\n";
print "#################################################\n";

#run with new fileconf SNPdiscoveryPaired for no SGE mode to pairedTwoIndividusIrigin 
$testingDir="../DATA-TEST/pairedTwoIndividusIrigin";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");


$runCmd = "toggleGenerator.pl -c ".$fileSNPPairedNoSGE." -d ".$dataFastqpairedTwoIndividusIrigin." -r ".$dataRefArcad." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for pairedTwoIndividusIrigin";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedTwoIndividusIrigin  list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	irigin1	irigin3";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedTwoIndividusIrigin  content ');


#####################
## FASTQ TESTS
#####################
## TOGGLE fastq pairedTwoIndividusIrigin en QSUB
#####################

$dataFastqpairedTwoIndividusIrigin = "../DATA/testData/fastq/pairedTwoIndividusIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoveryPaired / paired IRIGIN / qsub mode\n";
print "#################################################\n";

# Copy file config SNPdiscoveryPaired for no SGE mode
$fileSNPPairedIni="../SNPdiscoveryPaired.config.txt";          # Path of the SNPdiscoveryPaired.config.txt
my $fileSNPPairedSGE="SNPdiscoveryPairedTestSGE.config.txt";

$cmd="cp $fileSNPPairedIni $fileSNPPairedSGE";
print "\n### COPY conf file SNPdiscoveryPaired : $cmd\n";
system($cmd) and die ("#### ERROR COPY CONFIG FILE: $cmd\n");     # Copy into TEST

# Change the TOGGLE addaptator configuration file
sedFunction($fileSNPPairedSGE,1);

$testingDir="../DATA-TEST/pairedTwoIndividusIrigin";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");


$runCmd = "toggleGenerator.pl -c ".$fileSNPPairedSGE." -d ".$dataFastqpairedTwoIndividusIrigin." -r ".$dataRefArcad." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for pairedTwoIndividusIrigin SGE mode";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedOneIndividu list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	irigin1	irigin3";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedOneIndividu content ');


exit;



#   - 
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

#dna fastq



my $dataFastqsingleOneIndividuIrigin = "../DATA/testData/fastq/singleOneIndividuIrigin";
my $dataFastqsingleTwoIndividuIrigin = "../DATA/testData/fastq/singleTwoIndividuIrigin";

#rnaseq fastq
my $dataRNAseqPairedOneIndividu = "../DATA/testData/rnaseq/pairedOneIndividu";
my $dataRNAseqSingleOneIndividu = "../DATA/testData/rnaseq/singleOneIndividu";

#samBam
my $dataSamBamOneBam = "../DATA/testData/samBam/oneBam";
my $dataSamBamOneSam = "../DATA/testData/samBam/oneSam";
my $dataSamBamTwoBamsIrigin = "../DATA/testData/samBam/twoBamsIrigin";

#vcf
my $dataVcfSingleVCF = "../DATA/testData/vcf/singleVCF";
my $dataVcfVcfForRecalibration = "../DATA/testData/vcf/vcfForRecalibration";