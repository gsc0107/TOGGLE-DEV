#Will test if transabyss works correctly
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
use_ok('transabyss') or exit;

can_ok('transabyss','transabyssRun');

use toolbox;
use transabyss;

#my $expectedData="../../DATA/expectedData/contigTransabyss.fasta";

#########################################
#Remove files and directory created by previous test
#########################################
my $testingDir="../DATA-TEST/transabyssTestDir";
my $creatingDirCom="rm -Rf $testingDir ; mkdir -p $testingDir";                                    #Allows to have a working directory for the tests
system($creatingDirCom) and die ("ERROR: $0 : Cannot execute the command $creatingDirCom\n$!\n");

chdir $testingDir or die ("ERROR: $0 : Cannot go into the new directory with the command \"chdir $testingDir\"\n$!\n");


#######################################
#Creating the IndividuSoft.txt file
#######################################
my $creatingCommand="echo \"transabyss\nTEST\" > individuSoft.txt";
system($creatingCommand) and die ("ERROR: $0: Cannot create the individuSoft.txt file with the command $creatingCommand \n$!\n");

#######################################
#Cleaning the logs for the test
#######################################
my $cleaningCommand="rm -Rf transabyss_TEST_log.*";
system($cleaningCommand) and die ("ERROR: $0: Cannot clean the previous log files for this test with the command $cleaningCommand \n$!\n");

##########################################
#transabyssCreateSequenceDictionary test
##########################################

#Input file
my $forwardFastqFileIn = "../../DATA/testData/fastq/assembly/pairedPacaya/g02L6Mapped_R1.fq";
my @forwardFastqList = ($forwardFastqFileIn);
my @forwardFastqsList = ($forwardFastqFileIn,$forwardFastqFileIn);
    

my $reverseFastqFileIn = "../../DATA/testData/fastq/assembly/pairedPacaya/g02L6Mapped_R1.fq";
my @reverseFastqList = ($reverseFastqFileIn);
my @reverseFastqsList = ($reverseFastqFileIn,$reverseFastqFileIn);


my $singleFastqFileIn = "../../DATA/testData/fastq/assembly/singlePacaya/g02L5Single_R1.fq";
my @singleFastqFile = ($singleFastqFileIn);
my @emptyList = ();

my $transabyssPairedOutDir = "./transabyssPairedOutdir/"; # output directory must contain the word 'transabyss' as a safety precaution, given that auto-deletion can take place
my $transabyssSingleOutDir = "./transabyssSingleOutdir/";
my $transabyssSeveralOutDir = "./transabyssSeveralOutdir/";

#Output file
my $readGroup = 'g02'; ## ATTENTION: si modifié, à adapter aussi dans onTheFly/all_tests.pl (partie Transbyss)

#########################################################
###  Test for transabyssRun with single mode
#########################################################

is(transabyss::transabyssRun($transabyssSingleOutDir,$readGroup,\@singleFastqFile,\@emptyList),1,'transabyss::transabyssRun');
# expected output test
my $observedOutput = `ls $transabyssSingleOutDir`;
my @observedOutput = split /\n/,$observedOutput;
my @expectedOutput = ('coverage.hist',$readGroup.'-1.adj',$readGroup.'-1.fa',$readGroup.'-3.adj',$readGroup.'-3.fa',$readGroup.'-bubbles.fa',$readGroup.'.DBG.COMPLETE',$readGroup.'.FINAL.COMPLETE',$readGroup.'-final.fa',$readGroup.'-jn.fa',$readGroup.'-jn.path',$readGroup.'.JUNCTIONS.COMPLETE',$readGroup.'.REFERENCES.COMPLETE',$readGroup.'-ref.fa',$readGroup.'-ref.path',$readGroup.'.UNITIGS.COMPLETE');

is_deeply(\@observedOutput,\@expectedOutput,'transabyss::transabyssRun - output list - single mode');
#
## expected content test

my $cmd = 'grep -c "^>" '.$transabyssSingleOutDir.$readGroup.'-final.fa';
#print $cmd;
my $expectedAnswer="9";
my $observedAnswer=`$cmd`;
chomp($observedAnswer);
is($observedAnswer,$expectedAnswer,'transabyss::transabyssRun- output content - single mode');

exit;
__END__
#########################################################
###  Test for transabyssRun with one bank (paired files)
#########################################################

is(transabyss::transabyssRun($transabyssPairedOutDir,$readGroup,\@forwardFastqsList,\@reverseFastqList),1,'transabyss::transabyssRun');

# expected output test
$observedOutput = `ls $transabyssPairedOutDir`;
@observedOutput = split /\n/,$observedOutput;

@expectedOutput = ($readGroup.'_both.fa',$readGroup.'_both.fa.ok',$readGroup.'_both.fa.read_count',$readGroup.'_inchworm.K25.L25.DS.fa',$readGroup.'_inchworm.K25.L25.DS.fa.finished',$readGroup.'_inchworm.kmer_count',$readGroup.'_jellyfish.kmers.fa',$readGroup.'_jellyfish.kmers.fa.histo',$readGroup.'_left.fa.ok',$readGroup.'_partitioned_reads.files.list',$readGroup.'_partitioned_reads.files.list.ok',$readGroup.'_recursive_transabyss.cmds',$readGroup.'_recursive_transabyss.cmds.completed',$readGroup.'_recursive_transabyss.cmds.ok',$readGroup.'_right.fa.ok',$readGroup.'_Transabyss.fasta',$readGroup.'_Transabyss.timing');

is_deeply(\@observedOutput,\@expectedOutput,'transabyss::transabyssRun - output list - One paired bank');
#
## expected content test

$cmd = 'grep -c "^>" '.$transabyssPairedOutDir.$readGroup.'_Transabyss.fasta';
#print $cmd;
$expectedAnswer="17";
$observedAnswer=`$cmd`;
chomp($observedAnswer);

is($observedAnswer,$expectedAnswer,'transabyss::transabyssRun- output content - One paired bank');

#########################################################
###  Test for transabyssRun with several banks
#########################################################

is(transabyss::transabyssRun($transabyssSeveralOutDir,$readGroup,\@forwardFastqsList,\@reverseFastqsList),1,'transabyss::transabyssRun');

# expected output test
$observedOutput = `ls $transabyssSeveralOutDir`;
@observedOutput = split /\n/,$observedOutput;
@expectedOutput = ($readGroup.'_both.fa',$readGroup.'_both.fa.ok',$readGroup.'_both.fa.read_count',$readGroup.'_inchworm.K25.L25.DS.fa',$readGroup.'_inchworm.K25.L25.DS.fa.finished',$readGroup.'_inchworm.kmer_count',$readGroup.'_jellyfish.kmers.fa',$readGroup.'_jellyfish.kmers.fa.histo',$readGroup.'_left.fa.ok',$readGroup.'_partitioned_reads.files.list',$readGroup.'_partitioned_reads.files.list.ok',$readGroup.'_recursive_transabyss.cmds',$readGroup.'_recursive_transabyss.cmds.completed',$readGroup.'_recursive_transabyss.cmds.ok',$readGroup.'_right.fa.ok',$readGroup.'_Transabyss.fasta',$readGroup.'_Transabyss.timing');
#

is_deeply(\@observedOutput,\@expectedOutput,'transabyss::transabyssRun - output list - Several banks');
#
## expected content test

$cmd = 'grep -c "^>" '.$transabyssSeveralOutDir.$readGroup.'_Transabyss.fasta';
#print $cmd;
$expectedAnswer="15";
$observedAnswer=`$cmd`;
chomp($observedAnswer);

is($observedAnswer,$expectedAnswer,'transabyss::transabyssRun- output content - Several banks');

1;

#exit;
#__END__