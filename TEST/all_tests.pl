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
    
    # Change the TOGGLE addaptator configuration file for paired data
    my $sed="sed -i -e 's|-b ADAPTATOR1REVERSE -B ADAPTATOR1REVERSE|-b GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG  -B GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG|' ". $file;
    #print $sed."\n\n";
    system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
    $sed="sed -i -e 's|-b ADAPTATOR1FORWARD -B ADAPTATOR1FORWARD|-b GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG -B GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG|' ". $file;
    #print $sed."\n\n";
    system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
   
    
    $sed="sed -i -e 's|-b ADAPTATOR1REVERSE|-b GATCGGAAGAGCACACGTCTGAACTCCAGTCACATCACGATCTCGTATGCCGTCTTCTGCTTG|' ". $file;
    #print $sed."\n\n";
    system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
    $sed="sed -i -e 's|-b ADAPTATOR1FORWARD|-b GTTCGTCTTCTGCCGTATGCTCTAGCACTACACTGACCTCAAGTCTGCACACGAGAAGGCTAG|' ". $file;
    #print $sed."\n\n";
    system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
    
    
    # Add SGE part
    if ($bool)
    {
        my $sed="sed -i -e 's|#\$sge|\$sge|' ". $file;
        ## DEBUG print $sed;
        system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
        $sed="sed -i -e 's|#-q YOURQUEUE.q|-q bioinfo.q|' ". $file;
        ## DEBUG print $sed;
        system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
        $sed="sed -i -e 's|#-b Y|-b Y|' ". $file;
        ## DEBUG print $sed;
        system($sed) and die ("#### ERROR  SED COMMAND: $sed\n");
        $sed="sed -i -e 's|#-V|-V|' ". $file;
        ## DEBUG print $sed;
        system($sed) and die ("#### ERROR  SED COMMAND: $sed\n"); 
    }
    
    
}



#####################
## PATH for datas test
#####################

# references files
my $dataRefIrigin = "../DATA/Bank/referenceIrigin.fasta";
my $dataRefArcad = "../DATA/Bank/referenceArcad.fasta";
my $dataRefRnaseq = "../DATA/Bank/referenceRnaseq.fa";
my $dataRefRnaseqGFF = "../DATA/Bank/referenceRnaseq.gff3";



#####################
## FASTQ TESTS
#####################
## TOGGLE fastq pairedOneIndividuArcad
#####################

my $dataFastqpairedOneIndividuArcad = "../DATA/testData/fastq/pairedOneIndividuArcad";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoveryPaired paired ARCAD (one individu) / no SGE mode\n";
print "#################################################\n";

# Copy file config 
my $fileSNPPairedIni="../SNPdiscoveryPaired.config.txt";          # Path of the SNPdiscoveryPaired.config.txt
my $fileSNPPairedNoSGE="SNPdiscoveryPairedTest.config.txt";

my $cmd="cp $fileSNPPairedIni $fileSNPPairedNoSGE";
## DEBUG print "\n### COPY conf file SNPdiscoveryPaired : $cmd\n";
system($cmd) and die ("#### ERROR COPY CONFIG FILE: $cmd\n");     # Copy into TEST

# Change the TOGGLE addaptator configuration file
sedFunction($fileSNPPairedNoSGE);

# Remove files and directory created by previous test 
my $testingDir="../DATA-TEST/pairedOneIndividuArcad-noSGE";
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
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedOneIndividu (no SGE) list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
my $expectedOutput="LOC_Os12g32240.1	864	.	C	T	350.77	PASS	AC=2;AF=1.00;AN=2;DP=10;FS=0.000;MLEAC=2;MLEAF=1.00;MQ=60.00;MQ0=0;QD=26.71;SOR=3.258	GT:AD:DP:GQ:PL	1/1:0,10:10:30:379,30,0";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedOneIndividu (no SGE) content ');



#####################
## FASTQ TESTS
#####################
## TOGGLE fastq pairedTwoIndividusGzippedIrigin
#####################

my $dataFastqpairedTwoIndividusGzippedIrigin = "../DATA/testData/fastq/pairedTwoIndividusGzippedIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoveryPaired paired Irigin (two individus) / compressed fastq / no SGE mode\n";
print "#################################################\n";

# Remove files and directory created by previous test 
$testingDir="../DATA-TEST/pairedTwoIndividusGzippedIrigin-noSGE";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");


$runCmd = "toggleGenerator.pl -c ".$fileSNPPairedNoSGE." -d ".$dataFastqpairedTwoIndividusGzippedIrigin." -r ".$dataRefIrigin." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for pairedTwoIndividusGzippedIrigin";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedTwoIndividusGzippedIrigin (no SGE) list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="2290182	1013	.	A	G	44.17	FILTER-DP	AC=2;AF=1.00;AN=2;DP=2;FS=0.000;MLEAC=2;MLEAF=1.00;MQ=29.00;MQ0=0;QD=22.09;SOR=0.693	GT:AD:DP:GQ:PL	./.	1/1:0,2:2:6:70,6,0";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedTwoIndividusGzippedIrigin (no SGE) content ');



#####################
## FASTQ TESTS
#####################
## TOGGLE fastq pairedTwoIndividusIrigin 
#####################

my $dataFastqpairedTwoIndividusIrigin = "../DATA/testData/fastq/pairedTwoIndividusIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoveryPaired paired IRIGIN (two individu) / no SGE mode\n";
print "#################################################\n";


# Remove files and directory created by previous test 
$testingDir="../DATA-TEST/pairedTwoIndividusIrigin-noSGE";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");

$runCmd = "toggleGenerator.pl -c ".$fileSNPPairedNoSGE." -d ".$dataFastqpairedTwoIndividusIrigin." -r ".$dataRefIrigin." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for pairedTwoIndividusIrigin";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedTwoIndividusIrigin (no SGE) list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="2290182	1013	.	A	G	44.17	FILTER-DP	AC=2;AF=1.00;AN=2;DP=2;FS=0.000;MLEAC=2;MLEAF=1.00;MQ=29.00;MQ0=0;QD=22.09;SOR=0.693	GT:AD:DP:GQ:PL	./.	1/1:0,2:2:6:70,6,0";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedTwoIndividusIrigin  (no SGE) content ');


#####################
## FASTQ TESTS
#####################
## TOGGLE fastq pairedTwoIndividusIrigin en QSUB
#####################

$dataFastqpairedTwoIndividusIrigin = "../DATA/testData/fastq/pairedTwoIndividusIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoveryPaired paired Irigin (two individus) / SGE mode\n";
print "#################################################\n";

# Copy file config
$fileSNPPairedIni="../SNPdiscoveryPaired.config.txt";          # Path of the SNPdiscoveryPaired.config.txt
my $fileSNPPairedSGE="SNPdiscoveryPairedTestSGE.config.txt";

$cmd="cp $fileSNPPairedIni $fileSNPPairedSGE";
#print "\n### COPY conf file SNPdiscoveryPaired : $cmd\n";
system($cmd) and die ("#### ERROR COPY CONFIG FILE: $cmd\n");     # Copy into TEST

# Change the TOGGLE addaptator configuration file
sedFunction($fileSNPPairedSGE,1);

# Remove files and directory created by previous test 
$testingDir="../DATA-TEST/pairedTwoIndividusIrigin-SGE";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");

$runCmd = "toggleGenerator.pl -c ".$fileSNPPairedSGE." -d ".$dataFastqpairedTwoIndividusIrigin." -r ".$dataRefIrigin." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for pairedTwoIndividusIrigin SGE mode";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedTwoIndividu (SGE mode) list  ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="2290182	1013	.	A	G	44.17	FILTER-DP	AC=2;AF=1.00;AN=2;DP=2;FS=0.000;MLEAC=2;MLEAF=1.00;MQ=29.00;MQ0=0;QD=22.09;SOR=0.693	GT:AD:DP:GQ:PL	./.	1/1:0,2:2:6:70,6,0";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedTwoIndividu (SGE mode) content ');

# expected output content (qsub word)
$observedOutput=`grep "qsub" $testingDir/GLOBAL_ANALYSIS_*.o -c`;
chomp $observedOutput;
$expectedOutput=6;
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedTwoIndividu (SGE mode) found qsub command');




#####################
## FASTQ TESTS
#####################
## TOGGLE fastq singleOneIndividuIrigin
#####################

my $dataFastqsingleOneIndividuIrigin = "../DATA/testData/fastq/singleOneIndividuIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoverySingle Irigin (one individu) / no SGE mode\n";
print "#################################################\n";

# Copy file config
my $fileSNPSingleIni="../SNPdiscoverySingle.config.txt";         
my $fileSNPSingleNoSGE="SNPdiscoverySingleNoSGE.config.txt";

$cmd="cp $fileSNPSingleIni $fileSNPSingleNoSGE";
system($cmd) and die ("#### ERROR COPY CONFIG FILE: $cmd\n");     # Copy into TEST

# Change the TOGGLE addaptator configuration file
sedFunction($fileSNPSingleNoSGE);

# Remove files and directory created by previous test 
$testingDir="../DATA-TEST/singleOneIndividuIrigin-noSGE";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");

$runCmd = "toggleGenerator.pl -c ".$fileSNPSingleNoSGE." -d ".$dataFastqsingleOneIndividuIrigin." -r ".$dataRefIrigin." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for singleOneIndividusIrigin no SGE mode";


# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - singleOneIndividu (no SGE) list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	irigin2";
is($observedOutput,$expectedOutput, 'toggleGenerator - singleOneIndividu (no SGE) content ');




#####################
## FASTQ TESTS
#####################
## TOGGLE fastq singleTwoIndividuIrigin
#####################

my $dataFastqsingleTwoIndividuIrigin = "../DATA/testData/fastq/singleTwoIndividuIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoverySingle Irigin (two individus) / no SGE mode\n";
print "#################################################\n";


# Remove files and directory created by previous test 
$testingDir="../DATA-TEST/singleTwoIndividuIrigin-noSGE";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");

$runCmd = "toggleGenerator.pl -c ".$fileSNPSingleNoSGE." -d ".$dataFastqsingleTwoIndividuIrigin." -r ".$dataRefIrigin." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for singleTwoIndividusIrigin no SGE mode";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - singleTwoIndividu (no SGE) list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="2179526	467	.	T	C	64.17	FILTER-DP	AC=2;AF=1.00;AN=2;DP=2;FS=0.000;MLEAC=2;MLEAF=1.00;MQ=37.00;MQ0=0;QD=32.08;SOR=0.693	GT:AD:DP:GQ:PL	1/1:0,2:2:6:90,6,0	./.";
is($observedOutput,$expectedOutput, 'toggleGenerator - singleTwoIndividu (no SGE) content ');


#####################
## FASTQ TESTS
#####################
## TOGGLE RNASeq pairedOneIndividu
#####################

my $dataRNAseqPairedOneIndividu = "../DATA/testData/rnaseq/pairedOneIndividu";

print "\n\n#################################################\n";
print "#### TEST RNASEQPaired  (one individu) / no SGE mode\n";
print "#################################################\n";

# Copy file config
my $fileRNAPairedIni="../RNASeq.config.txt";         
my $fileRNAPairedNoSGE="RNASeqNoSGE.config.txt";

$cmd="cp $fileRNAPairedIni $fileRNAPairedNoSGE";
system($cmd) and die ("#### ERROR COPY CONFIG FILE: $cmd\n");     # Copy into TEST

# Change the TOGGLE addaptator configuration file
sedFunction($fileRNAPairedNoSGE);

# Remove files and directory created by previous test 
$testingDir="../DATA-TEST/RNAseq-pairedOneIndividu-noSGE";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");

$runCmd = "toggleGenerator.pl -c ".$fileRNAPairedNoSGE." -d ".$dataRNAseqPairedOneIndividu." -r ".$dataRefRnaseq." -g ".$dataRefRnaseqGFF." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for pairedOneIndividuRNASEQ no SGE mode";

# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('RNASeq.accepted_hits.HTSEQCOUNT.txt');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - pairedOneIndividuRNASEQ (no SGE) list ');

# expected output content
$observedOutput=`wc -l $testingDir/finalResults/RNASeq.accepted_hits.HTSEQCOUNT.txt`;
chomp $observedOutput;
$expectedOutput="2388 $testingDir/finalResults/RNASeq.accepted_hits.HTSEQCOUNT.txt";
is($observedOutput,$expectedOutput, 'toggleGenerator - pairedOneIndividuRNASEQ (no SGE) content ');


exit;



# *** RNASeq ***

#   - TOGGLE RNASeq singleOneIndividu

# *** samBam ***
#   - TOGGLE samBam oneBam


#####################
## FASTQ TESTS
#####################
## TOGGLE fastq singleOneIndividuIrigin
#####################

my $dataFastqsingleOneIndividuIrigin = "../DATA/testData/fastq/singleOneIndividuIrigin";

print "\n\n#################################################\n";
print "#### TEST SNPdiscoverySingle Irigin (one individu) / no SGE mode\n";
print "#################################################\n";

# Copy file config
my $fileSNPSingleIni="../SNPdiscoverySingle.config.txt";         
my $fileSNPSingleNoSGE="SNPdiscoverySingleNoSGE.config.txt";

$cmd="cp $fileSNPSingleIni $fileSNPSingleNoSGE";
system($cmd) and die ("#### ERROR COPY CONFIG FILE: $cmd\n");     # Copy into TEST

# Change the TOGGLE addaptator configuration file
sedFunction($fileSNPSingleNoSGE);

# Remove files and directory created by previous test 
$testingDir="../DATA-TEST/singleOneIndividuIrigin-noSGE";
$cleaningCmd="rm -Rf $testingDir";
system ($cleaningCmd) and die ("ERROR: $0 : Cannot remove the previous test directory with the command $cleaningCmd \n$!\n");

$runCmd = "toggleGenerator.pl -c ".$fileSNPSingleNoSGE." -d ".$dataFastqsingleOneIndividuIrigin." -r ".$dataRefIrigin." -o ".$testingDir;
print "\n### Toggle running : $runCmd\n";
system("$runCmd") and die "#### ERROR : Can't run TOGGLE for singleOneIndividusIrigin no SGE mode";


# check final results
print "\n### TEST Ouput list & content : $runCmd\n";
$observedOutput = `ls $testingDir/finalResults`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ('multipleAnalysis.GATKSELECTVARIANT.vcf','multipleAnalysis.GATKSELECTVARIANT.vcf.idx');

# expected output test
is_deeply(\@observedOutput,\@expectedOutput,'toggleGenerator - singleOneIndividu (no SGE) list ');

# expected output content
$observedOutput=`tail -n 1 $testingDir/finalResults/multipleAnalysis.GATKSELECTVARIANT.vcf`;
chomp $observedOutput;
$expectedOutput="#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	irigin2";
is($observedOutput,$expectedOutput, 'toggleGenerator - singleOneIndividu (no SGE) content ');



#   - TOGGLE samBam oneSam
#   - TOGGLE samBam twoBamsIrigin
# *** VCF ***
#   - TOGGLE VCF singleVCF
#   - TOGGLE VCF vcfForRecalibration

#dna fastq






#rnaseq fastq

my $dataRNAseqSingleOneIndividu = "../DATA/testData/rnaseq/singleOneIndividu";

#samBam
my $dataSamBamOneBam = "../DATA/testData/samBam/oneBam";
my $dataSamBamOneSam = "../DATA/testData/samBam/oneSam";
my $dataSamBamTwoBamsIrigin = "../DATA/testData/samBam/twoBamsIrigin";

#vcf
my $dataVcfSingleVCF = "../DATA/testData/vcf/singleVCF";
my $dataVcfVcfForRecalibration = "../DATA/testData/vcf/vcfForRecalibration";


#EFFACER les fichiers conf dans le repertoire test