package localConfig;

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


#################################################################
#..... COPYRIGHT
#################################################################

use strict;
use warnings;
use Exporter;

our @ISA=qw(Exporter);
our @EXPORT=qw($bwa $picard $samtools $GATK $cutadapt $fastqc $java $toggle $fastxTrimmer $tophat2 $bowtie2Build $bowtieBuild $htseqcount $stacks $pindel $trinity);

#toggle path
our $toggle="/home/adiall/TOGGLE-DEV";

#PATH for Mapping on cluster
our $java = "/usr/local/java/latest/bin/java -Xmx12g -jar";

our $bwa = "/usr/local/bin/bwa";
our $picard = "$java /usr/local/picard-tools-1.130/";

our $samtools = "/usr/local/samtools-1.2/bin/samtools";
our $GATK = "/usr/java/jre1.7.0_51/bin/java -Xmx12g -jar /usr/local/GenomeAnalysisTK-3.3/GenomeAnalysisTK.jar";
our $fastqc = "/usr/local/FastQC/fastqc";

#Path for CutAdapt
our $cutadapt = "/usr/local/cutadapt-1.8/bin/cutadapt";

##### FOR RNASEQ analysis
#Path for fastq_trimmer
our $fastxTrimmer="/usr/local/bin/fastx_trimmer";

#Path for tophat2
our $tophat2="/usr/local/tophat-2.0.14/bin/tophat2";
#
#path for bowtie2-build
our $bowtie2Build="/usr/local/bowtie2-2.2.5/bowtie2-build";

#path for bowtie-build
our $bowtieBuild="/usr/local/bowtie-0.12.9/bowtie-build";

#path for htseqcount
our $htseqcount = "/usr/local/bin/htseq-count";

#path for process_radtags
our $stacks = "/usr/local/stacks-1.29/bin/";

#path for pindel
our $pindel = "/usr/local/pindel-0.2.4/pindel";

#path for trinity
our $trinity = "/usr/local/trinityrnaseq-2.2.0/Trinity";

1;

