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

#Will test if radseq works correctly
use strict;
use warnings;
use Test::More 'no_plan'; #Number of tests, to modify if new tests implemented. Can be changed as 'no_plan' instead of tests=>11 .
use Test::Deep;
use Data::Dumper;
use lib qw(../Modules/);


########################################
#use of radseq module ok
########################################
use_ok('toolbox') or exit;                                                                  # Check if toolbox is usable
use_ok('radseq') or exit;                                                                   # Check if radseq is usable
can_ok('radseq','processRadtags');                                                          # Check if radseq::processRadtags is find
can_ok('radseq','parseKeyFile');                                                            # Check if radseq::parseKeyFile is find
can_ok('radseq','executeDemultiplexing');                                                   # Check if radseq::executeDemultiplexing is find
can_ok('radseq','checkOrder');                                                              # Check if radseq::checkOrder is find
can_ok('radseq','rmHashOrder');                                                             # Check if radseq::rmHashOrder is find

use toolbox;
use radseq;

my $expectedData="../../DATA/expectedData/";

#########################################
#Remove files and directory created by previous test
#########################################
my $testingDir="../DATA-TEST/radseqTestDir";
my $creatingDirCom="rm -Rf $testingDir ; mkdir -p $testingDir";                                    #Allows to have a working directory for the tests
system($creatingDirCom) and die ("ERROR: $0 : Cannot execute the command $creatingDirCom\n$!\n");

chdir $testingDir or die ("ERROR: $0 : Cannot go into the new directory with the command \"chdir $testingDir\"\n$!\n");


#######################################
#Creating the IndividuSoft.txt file
#######################################
my $creatingCommand="echo \"radseq\nTEST\" > individuSoft.txt";
system($creatingCommand) and die ("ERROR: $0 : Cannot create the individuSoft.txt file with the command $creatingCommand\n$!\n");


#######################################
#Cleaning the logs for the test
#######################################
my $cleaningCommand="rm -f radseq_TEST_log.*";
system($cleaningCommand) and die ("ERROR: $0 : Cannot remove the previous log files with the command $cleaningCommand \n$!\n");



##########################################
##### radseq::rmHashOrder
##########################################

my %hashOrder = (
				'1' => 'processRadtags',
				'2' => 'fastqc'
				);
my $hashOrder = \%hashOrder;

# execution test
my $hashOrderRM;
$hashOrderRM = radseq::rmHashOrder($hashOrder);

# expected content test
is_deeply($hashOrder, $hashOrderRM, "radseq::rmHashOrder - cleanning step one OK");               # TEST IF THE STRUCTURE OF THE FILE OUT IS GOOD


##########################################
##### radseq::checkOrder
##########################################


my $outputDir = "./";
my %param = (
				'-c' => '../../demultiplexingPaired.config.txt',
				'-d' => '../../DATA/testData/radseq/single/',
				'-k' => '../../DATA/testData/radseq/keyfileTestSingle'
				);


# execution test
my $initialDirContent;
#$initialDirContent = radseq::checkOrder($outputDir,%param);
#print Dumper($initialDirContent);

my @expectedOutput = ('.//demultiplexing/33-16.fq', './/demultiplexing/A239.fq', './/demultiplexing/A272.fq', './/demultiplexing/A554.fq', './/demultiplexing/A619.fq', './/demultiplexing/A632.fq', './/demultiplexing/A654.fq', './/demultiplexing/A659.fq', './/demultiplexing/A680.fq', './/demultiplexing/A682.fq', './/demultiplexing/B103.fq', './/demultiplexing/B104.fq', './/demultiplexing/B109.fq', './/demultiplexing/B10.fq', './/demultiplexing/B73Htrhm.fq', './/demultiplexing/B76.fq', './/demultiplexing/B77.fq', './/demultiplexing/B84.fq', './/demultiplexing/B97.fq', './/demultiplexing/C103.fq', './/demultiplexing/CH701-30.fq', './/demultiplexing/CI28A.fq', './/demultiplexing/CI3A.fq', './/demultiplexing/CI66.fq', './/demultiplexing/CI-7.fq', './/demultiplexing/CM105.fq', './/demultiplexing/CM174.fq', './/demultiplexing/CML14.fq', './/demultiplexing/CML157Q.fq', './/demultiplexing/CML220.fq', './/demultiplexing/CML228.fq', './/demultiplexing/CML238.fq', './/demultiplexing/CML258.fq', './/demultiplexing/CML277.fq', './/demultiplexing/CML281.fq', './/demultiplexing/CML311.fq', './/demultiplexing/CML323.fq', './/demultiplexing/CML332.fq', './/demultiplexing/CML333.fq', './/demultiplexing/CML45.fq', './/demultiplexing/CML52.fq', './/demultiplexing/CML91.fq', './/demultiplexing/CML92.fq', './/demultiplexing/CO106.fq', './/demultiplexing/CO125.fq', './/demultiplexing/DE-2.fq', './/demultiplexing/DE-3.fq', './/demultiplexing/EMPTY.fq', './/demultiplexing/EP1.fq', './/demultiplexing/F6.fq', './/demultiplexing/F7.fq', './/demultiplexing/H91.fq', './/demultiplexing/H95.fq', './/demultiplexing/I137TN.fq', './/demultiplexing/I29.fq', './/demultiplexing/IDS28.fq', './/demultiplexing/K55.fq', './/demultiplexing/Ki11.fq', './/demultiplexing/Ki14.fq', './/demultiplexing/L317.fq', './/demultiplexing/M14.fq', './/demultiplexing/NC230.fq', './/demultiplexing/NC250.fq', './/demultiplexing/NC262.fq', './/demultiplexing/NC290A.fq', './/demultiplexing/NC298.fq', './/demultiplexing/NC300.fq', './/demultiplexing/NC318.fq', './/demultiplexing/NC320.fq', './/demultiplexing/NC328.fq', './/demultiplexing/NC338.fq', './/demultiplexing/NC356.fq', './/demultiplexing/NC364.fq', './/demultiplexing/NC368.fq', './/demultiplexing/Oh40B.fq', './/demultiplexing/Oh43E.fq', './/demultiplexing/Oh603.fq', './/demultiplexing/Os420.fq', './/demultiplexing/Pa875.fq', './/demultiplexing/R109B.fq', './/demultiplexing/R168.fq', './/demultiplexing/SC213R.fq', './/demultiplexing/Sg18.fq', './/demultiplexing/tripsacum.fq', './/demultiplexing/Tzi25.fq', './/demultiplexing/Va22.fq', './/demultiplexing/Va35.fq', './/demultiplexing/Va59.fq', './/demultiplexing/Va99.fq', './/demultiplexing/W117Ht.fq', './/demultiplexing/W153R.fq', './/demultiplexing/W182B.fq', './/demultiplexing/W22.fq', './/demultiplexing/WD.fq' );
is_deeply(radseq::checkOrder($outputDir,%param),\@expectedOutput,'radseq::checkOrder - running');

# expected output test
#Check if files created
my @expectedOutput = ('33-16.fq', 'A239.fq', 'A272.fq', 'A554.fq', 'A619.fq', 'A632.fq', 'A654.fq', 'A659.fq', 'A680.fq', 'A682.fq', 'B103.fq', 'B104.fq', 'B109.fq', 'B10.fq', 'B73Htrhm.fq', 'B76.fq', 'B77.fq', 'B84.fq', 'B97.fq', 'C103.fq', 'CH701-30.fq', 'CI28A.fq', 'CI3A.fq', 'CI66.fq', 'CI-7.fq', 'CM105.fq', 'CM174.fq', 'CML14.fq', 'CML157Q.fq', 'CML220.fq', 'CML228.fq', 'CML238.fq', 'CML258.fq', 'CML277.fq', 'CML281.fq', 'CML311.fq', 'CML323.fq', 'CML332.fq', 'CML333.fq', 'CML45.fq', 'CML52.fq', 'CML91.fq', 'CML92.fq', 'CO106.fq', 'CO125.fq', 'DE-2.fq', 'DE-3.fq', 'EMPTY.fq', 'EP1.fq', 'F6.fq', 'F7.fq', 'H91.fq', 'H95.fq', 'I137TN.fq', 'I29.fq', 'IDS28.fq', 'K55.fq', 'Ki11.fq', 'Ki14.fq', 'L317.fq', 'M14.fq', 'NC230.fq', 'NC250.fq', 'NC262.fq', 'NC290A.fq', 'NC298.fq', 'NC300.fq', 'NC318.fq', 'NC320.fq', 'NC328.fq', 'NC338.fq', 'NC356.fq', 'NC364.fq', 'NC368.fq', 'Oh40B.fq', 'Oh43E.fq', 'Oh603.fq', 'Os420.fq', 'Pa875.fq', 'R109B.fq', 'R168.fq', 'SC213R.fq', 'Sg18.fq', 'tripsacum.fq', 'Tzi25.fq', 'Va22.fq', 'Va35.fq', 'Va59.fq', 'Va99.fq', 'W117Ht.fq', 'W153R.fq', 'W182B.fq', 'W22.fq', 'WD.fq' );
my $observedOutput = `ls demultiplexing`;
my @observedOutput = split /\n/,$observedOutput;

is_deeply(\@observedOutput,\@expectedOutput,'radseq::checkOrder - Files demultiplexing');


exit();
__END__;


#Copying keyFile into testingDir
my $originalKeyFile = "../DATA/expectedData/radseq/keyFileTest.txt";        # Keyfile
my $keyFile = "$testingDir/keyFileTest.txt";                                # Keyfile for test
my $FileCopyCom = "cp $originalKeyFile $keyFile";                           # command to copy the original keyFile into the test directory
system ($FileCopyCom) and die ("ERROR: $0 : Cannot copy the file $originalKeyFile in the test directory with the command $FileCopyCom\n$!\n");    # RUN the copy command

#Copying fastq directory into testingDir
my $originalInitialDir = "../DATA/expectedData/radseq/initialDir/";         # initialDir with two fastq files
my $initialDir = "$testingDir/";                                            # initialDir for test
$FileCopyCom = "cp -r $originalInitialDir $initialDir";                     # command to copy the original initialDir into the test directory
system ($FileCopyCom) and die ("ERROR: $0 : Cannot copy the file $originalInitialDir in the test directory with the command $FileCopyCom\n$!\n");    # RUN the copy command
$initialDir = "$testingDir/initialDir/";
my $options="-e apeKI ";                                                             #options de radseq::processRadtags are empty by default
######################


#######################################

### Test of radseq::processRadtags ###
is ((radseq::processRadtags($keyFile, $initialDir, $options)),1, 'radseq::processRadtags');         # TEST IF FONCTION WORKS
my $expectedOutput = `ls ../DATA/expectedData/radseq/outputRadseq/` or die ("ERROR: $0 : Cannot list the directory ../DATA/expectedData/radseq/outputRadseq with the command ls \n$!\n");
my @expectedOutput = split(/\n/,$expectedOutput);

my $observedOutput = `ls $testingDir/outputRadseq/` or die ("ERROR: $0 : Cannot list the directory .$testingDir/outputRadseq/ with the command ls \n$!\n");
my @observedOutput = split(/\n/,$observedOutput);

is_deeply (\@expectedOutput, \@observedOutput, "radseq output checkout");                             # TEST IF THE STRUCTURE OF THE FILE OUT IS GOOD
##############################

exit;
