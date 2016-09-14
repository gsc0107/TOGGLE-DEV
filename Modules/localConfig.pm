package localConfig;



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



use strict;
use warnings;
use Exporter;

our @ISA=qw(Exporter);
our @EXPORT=qw($bwa $picard $samtools $GATK $cutadapt $fastqc $java $toggle $fastxTrimmer $tophat2 $bowtie2Build $bowtieBuild $htseqcount $stacks);

#toggle path
our $toggle="/home/ravel/TOGGLE/";

#PATH for Mapping on cluster
#our $java = "/usr/java/latest/bin/java -Xmx8g -jar";
our $java = "/usr/local/java/latest/bin/java -Xmx8g -jar";

our $bwa = "/usr/local/bin/bwa";

our $picard = "$java /usr/local/picard-tools-1.130/picard.jar";

our $samtools = "/usr/local/samtools-1.2/bin/samtools";

our $GATK = "/usr/java/jre1.7.1_51/java /usr/local/GenomeAnalysisTK-3.3/GenomeAnalysisTK.jar";

our $fastqc = "/home/ravel/FastQC/fastqc";

#Path for CutAdapt
our $cutadapt = "/usr/local/cutadapt-1.8/bin/cutadapt";

##### FOR RNASEQ analysis
#Path for fastq_trimmer
our $fastxTrimmer="/usr/local/bin/fastx_trimmer";

#Path for tophat2
our $tophat2="/usr/local/tophat-2.0.14/bin/tophat2";

#path for bowtie2-build
our $bowtie2Build="/usr/local/bowtie2-2.2.5/bowtie2-build";

#path for bowtie-build
our $bowtieBuild="/usr/local/bowtie-0.12.9/bowtie-build";

#path for htseqcount
our $htseqcount = "/usr/local/bin/htseq-count";

#path for process_radtags
our $stacks = "/usr/local/stacks-1.42/bin/process_radtags";

1;
