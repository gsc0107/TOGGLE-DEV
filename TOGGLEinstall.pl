#!/usr/bin/env perl

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
use Data::Dumper;

system("clear");

print"###################################################################################################################################
#
# This script will allow a user-space automatic installation of TOGGLE from the current Master version https://github.com/SouthGreenPlatform/TOGGLE
#
###################################################################################################################################\n";

#64bits validation

print "\n\n############################################
##\t Checking if your system is a 64 bits
############################################\n";

my $machineType=`uname -m`;
if ($machineType =~ m/x86_64/)
    {
    print "Your system is a 64 bits:\t$machineType";
    }
else
    {
	die "** It seems that your system is not 64bits.**
	**Please verify that your system is 64 bits**
	** $machineType **";
    }
    
#Software and lib validation

print "\n\n############################################
##\t Checking installed softwares and libraries
############################################\n";

my $requirements = {"software"=>{   "git" => 0,
                                    "tar" => 0,
                                    "wget"=> 0},
                    "libraries"=>{  "zlib1g-dev"=>0,
                                    "libncurses5-dev"=>0,
                                    "python-dev"=>0,
                                    "fakeroot"=>0,
                                    "python-numpy"=>0,
                                    "python-matplotlib"=>0,
                                    "java"=>0}};
#print Dumper($requirements);

#Software validation MANDATORY

foreach my $softs (keys %{$requirements->{"software"}})
    {
    my $controlCommand = "which $softs";
    my $controlRes = `$controlCommand`;
    chomp $controlRes;
    #print "\n$softs --> $controlRes\n";
    die ("The $softs software is not installed and is mandatory for continuing the installation of TOGGLE.\n\n Please contact your administrator for installing it.\n") unless $controlRes;
    $requirements->{"software"}->{$softs} = $controlRes;
    }
    
print "\nAll required sotwares (perl, git, wget and tar) are installed.\n";

#lib validation NOT MANDATORY

foreach my $libs (keys %{$requirements->{"libraries"}})
    {
    my $controlCommand = "find /usr | grep -m 1 $libs";
    my $controlRes = `$controlCommand`;
    chomp $controlRes;
    if ($controlRes)
        {
        #The lib is present
        $requirements->{"libraries"}->{$libs} = 1;
        }
    else
        {
        #The lib is absent
        warn("\nThe $libs library is absent and may block some posterior installations.\n")
        }
    }

#print Dumper($requirements);



print "\n#######################################################
## \tLicense infos for all softwares
#######################################################\n";
print "\nBy installing this software you agree to the Licenses, Copyrights or Copylefts for all the softwares used in TOGGLE, as well as the License of TOGGLE.\n";

print "\nPlease Visit the individual sites for the details of the corresponding Licenses and the citations details:\n";

sleep 2;

print "\nCutAdapt
\tLicense: https://github.com/marcelm/cutadapt/blob/master/LICENSE
\tCitation: http://journal.embnet.org/index.php/embnetjournal/article/view/200

bwa
\tLicense: http://sourceforge.net/projects/bio-bwa/
\tCitation: http://www.ncbi.nlm.nih.gov/pubmed/19451168

SAMtools
\tLicense: http://sourceforge.net/projects/samtools/
\tCitation: http://www.ncbi.nlm.nih.gov/pubmed/19505943

Picard-Tools
\tLicense: No explicit License
\tCitation: SAMtools paper and http://broadinstitute.github.io/picard/

FastQC
\tLicense: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
\tCitation: http://www.bioinformatics.bbsrc.ac.uk/projects/fastqc/

GATK
\tLicense: https://github.com/broadgsa/gatk-protected/
\tCitation:
\t\t http://www.ncbi.nlm.nih.gov/pubmed?term=20644199
\t\t http://www.ncbi.nlm.nih.gov/pubmed?term=21478889
\t\t http://onlinelibrary.wiley.com/doi/10.1002/0471250953.bi1110s43/abstract;jsessionid=D95C25686A6F9F397B710DE983CE10D8.f03t02

TopHat
\tLicense: https://github.com/infphilo/tophat/blob/master/LICENSE
\tCitation: http://bioinformatics.oxfordjournals.org/content/25/9/1105.abstract

Bowtie2
\tLicense: http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.2.5/
\tCitation: http://www.nature.com/nmeth/journal/v9/n4/full/nmeth.1923.html

FASTX-Trimmer
\tLicense: http://hannonlab.cshl.edu/fastx_toolkit/license.html
\tCitation: http://hannonlab.cshl.edu/fastx_toolkit/

HTSeq-Count
\tLicense: http://www-huber.embl.de/HTSeq/doc/overview.html#license
\tCitation: https://academic.oup.com/bioinformatics/article-lookup/doi/10.1093/bioinformatics/btu638

TOGGLE
\tLicense: https://github.com/SouthGreenPlatform/TOGGLE/blob/master/LICENSE
\tCitation: Monat et al, TOGGLE: toolbox for generic NGS analyses, BMC Bioinformatics, 2015, 16:374\n
";

sleep 2;

print "#######################################################
## \tTOGGLE installation per se
#######################################################";


my $INSTALLPATH;
print "\nPlease provide the installation path as ABSOLUTE (e.g. /home/myUserName/TOGGLE):";
$INSTALLPATH = <STDIN>;
chomp $INSTALLPATH;

#Transforming in an absolute PATH. Using -f option, all composants must exist but the last

#$INSTALLPATH = readlink -f $INSTALLPATH

while (1)
    {  
    
    print "IS THIS THE CORRECT INSTALL PATH: $INSTALLPATH ? [Y|N]: \n";
    my $yn;
    $yn = <STDIN>;
    chomp $yn;
    if ($yn =~ m/Y|y/)
        {
        print"Install path is: '$INSTALLPATH'\n ";
        last;
        }
    elsif ($yn =~ m/N|n/ )
        {print "Please, provide the correct installation path:";
         $INSTALLPATH = <STDIN>;
        chomp $INSTALLPATH;
        }
    else
        {
        print "\nPlease answer 'Y' or 'N'\n";
        next;
        }
    }

mkdir $INSTALLPATH;

#Cloning current version of TOGGLE

print "\nCloning the current Git Master Version";

my $gitCommand = "git clone https://github.com/SouthGreenPlatform/TOGGLE.git $INSTALLPATH";
system("$gitCommand") and die("\nCannot clone the current version of TOGGLE: $!\n");

system ("cd $INSTALLPATH");

#Adding binaries, libraries and a basic localConfig.pm to change

print "\nDownloading the version to be compiled for CutAdapt, bwa, SAMtools, Picard-Tools, FastQC, GATK, TopHat, Bowtie2 and FASTX-Trimmer";

my $wgetCommand = "wget http://bioinfo-web.mpl.ird.fr/toggle/bin.tar.gz";
system("$wgetCommand") and die ("\nCannot download the binaries: $!\n");

print "\nDownloading the various Perl modules";

$wgetCommand = "wget http://bioinfo-web.mpl.ird.fr/toggle/perlModules.tar.gz";
system("$wgetCommand") and die ("\nCannot download the perl libraries: $!\n");

print "\nDownloading the localConfig.pm";

$wgetCommand = "wget http://bioinfo-web.mpl.ird.fr/toggle/BAK_localConfig.pm";
system("$wgetCommand") and die ("\nCannot download the localConfig file: $!\n");

# DECLARE VARIABLES WITH PATHS 
my $CURRENTPATH=$INSTALLPATH;
my $TOGGLEPATH=$INSTALLPATH;
my $MODULES=$INSTALLPATH."/Modules";
my $BINARIES=$INSTALLPATH."/bin";

sleep 1;

#COMPILATION
print "#######################################################
## \tDecompressing, compiling and installing softwares
######################################################";

system ("tar xzvf bin.tar.gz && rm -f bin.tar.gz && mv binNew bin") and die("\nCannot untar bin files: $!\n");

system ("cd $BINARIES");

my @notCompiled;

## compiling bwa
system ("cd bwa && make && cd $BINARIES");

##compiling samtools
if ($requirements->{"libraries"}->{"libncurses5-dev"} && $requirements->{"libraries"}->{"zlib1g-dev"})
    {
    system("cd samtools && ./configure && make && cd $BINARIES");
    }
else
    {
    my $missing;
    $missing = "libncurses5-dev " unless $requirements->{"libraries"}->{"libncurses5-dev"} ;
    $missing .= "zlib1g-dev" unless $requirements->{"libraries"}->{"zlib1g-dev"};
    print "\nCannot compile samtools as some libraries are missing: $missing\n";
    push @notCompiled, "samtools";
    }

if ($requirements->{"libraries"}->{"java"})
    {
    print "\nJava is present. Please test if the current java version is ok for picard-tools and GATK\n";
    }
else
    {
    print "\nJava is not installed. The picard-tools and GATK will not work\n";
    push @notCompiled, "picard-tools";
    push @notCompiled, "GATK";
    }
##compiling picardTools
#NO NEED, JAVA ARCHIVE AVAILABLE


##compiling GATK
#NO NEED, JAVA ARCHIVE AVAILABLE

##compiling cutadapt
if ($requirements->{"libraries"}->{"python-dev"})
    {
    system ("cd cutadapt && python setup.py build_ext -i && cd $BINARIES");
    }
else
    {
    my $missing;
    $missing = "python-dev " unless $requirements->{"libraries"}->{"python-dev"} ;
    print "\nCannot compile cutadapt as some libraries are missing: $missing\n";
    push @notCompiled, "cutadapt";
    }


##compiling fastQC
#NO NEED, JAVA ARCHIVE AVAILABLE

##compiling TopHat
#NO NEED we used a Linux x64 already compiled version from original website

##compiling bowtie and bowtie2
#NO NEED we used a Linux x64 already compiled version from original website

## compiling Fastx_toolkit
#NO NEED we used a Linux x64 already compiled version from original website

if (scalar @notCompiled)
    {
    print "\nSome softwares cannot be compiled:\n";
    print "@notCompiled","\n";
    }

sleep 1;

print "\tDecompressing Perl Modules\n";

system ("cd $INSTALLPATH && tar xvzf perlModules.tar.gz && rm -Rf perlModules.tar.gz && cp -R perlModules/* $MODULES/. && rm -Rf perlModules") and die("\nCannot decompress the perl Modules:\n$!\n");


sleep 1;

print ("\nCONFIGURING YOUR PERSONAL localConfig.pm");

my $JAVASEVEN =$requirements->{"libraries"}->{"java"};

system ("cp BAK_localConfig.pm $MODULES/localConfig.pm
sed -i \"s|togglepath|$TOGGLEPATH|g\" $MODULES/localConfig.pm
sed -i \"s|java7|$JAVASEVEN|g\" $MODULES/localConfig.pm
sed -i \"s|bwabinary|$BINARIES/bwa/bwa|g\" $MODULES/localConfig.pm
sed -i \"s|cutadaptbinary|$BINARIES/cutadapt/bin/cutadapt|g\" $MODULES/localConfig.pm
sed -i \"s|samtoolsbinary|$BINARIES/samtools/samtools|g\" $MODULES/localConfig.pm
sed -i \"s|picardbinary|$BINARIES/picard-tools/picard.jar|g\" $MODULES/localConfig.pm
sed -i \"s|fastqcbinary|$BINARIES/FastQC/fastqc|g\" $MODULES/localConfig.pm
sed -i \"s|GATKbinary|$BINARIES/GenomeAnalysisTK/GenomeAnalysisTK.jar|g\" $MODULES/localConfig.pm
sed -i \"s|tophat2binary|$BINARIES/tophat/tophat2|g\" $MODULES/localConfig.pm
sed -i \"s|bowtie2-buildbinary|$BINARIES/bowtie2/bowtie2-build|g\" $MODULES/localConfig.pm
sed -i \"s|bowtie-buildbinary|$BINARIES/bowtie/bowtie-build|g\" $MODULES/localConfig.pm
sed -i \"s|fastx_trimmerbinary|$BINARIES/fastx_toolkit/fastx_trimmer|g\" $MODULES/localConfig.pm") and die ("\nCannot configuring:\n$!\n");

#Adding toggle in the user PERL5LIB path
sleep 1;

system ("echo \"\nPERL5LIB=\$PERL5LIB:$MODULES\n\" | cat - > ~/.bashrc && echo \"\nPATH=\$PATH:$TOGGLEPATH\n\" | cat - > ~/.bashr && source ~/.bashrc") and die("\nCannot add paths:\n$BINARIES!\n");

print "\n The automatic configuration is finished!\n\nPlease use first the test data as recommended on the GitHub https://github.com/SouthGreenPlatform/TOGGLE.\n\nThanks for using TOGGLE\n";

exit;