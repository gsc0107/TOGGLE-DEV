TOGGLE : Toolbox for generic NGS analyses
===========

![TOGGLE Logo](./docs/images/toggleLogo.png)

Dear Biologist, have you ever dream of using the whole power of those numerous NGS tools that your bioinformatician colleagues use through this awful list of command line ?

Dear Bioinformatician, have you ever guess how to design really fastly a new NGS pipeline without having to retype again dozens of code lines to readapt your scripts or starting from scratch ?

**So, be Happy ! TOGGLE is for you !!**

TOGGLE (TOolbox for Generic nGs anaLysEs) is a suite of 19 packages and more than 110 modules able to manage a large set of NGS softwares
and utilities to easily design pipelines able to handle hundreds of samples. Moreover, TOGGLE offers an easy way to manipulate the various
options of the different softwares through the pipelines in using a single basic configuration file, that can be changed for each assay without
having to change the code itself.

Users can also create their own pipeline through an easy and user-friendly approach. The pipelines can start from Fastq (plain or gzipped), SAM, BAM or VCF (plain or gzipped) files, with parallel and global analyses. Samples pipelines are provided for SNP discovery and RNAseq counts.

The system is able to detect parallel/scheduling launching and to manage large amount of samples on large cluster machines.


##  Contributing

* Licencied under CeCill-C (http://www.cecill.info/licences/Licence_CeCILL-C_V1-en.html) and GPLv3
* Intellectual property belongs to IRD, CIRAD, ADNid and SouthGreen development platform
* Written by Cecile Monat, Christine Tranchant, Ayite Kougbeadjo, Cedric Farcy, Mawusse Agbessi, Enrique Ortega-Abboud, Sébastien Ravel, Julie Orjuela-Bouniol, Souhila Amanzougarene, Gauthier Sarah, Marilyne Summo, and Francois Sabot
* Copyright 2014-2016

## Contact

For bug tracking purpose you can use the GitHub or questions about TOGGLE, you can contact the mainteners using the following email addresses:

* christine.tranchant@ird.fr
* francois.sabot@ird.fr

##  Citation
**TOGGLE: Toolbox for generic NGS analyses**. Cécile Monat, Christine Tranchant-Dubreuil, Ayité Kougbeadjo, Cédric Farcy, Enrique
Ortega-Abboud, Souhila Amanzougarene, Sébastien Ravel, Mawussé Agbessi, Julie Orjuela-Bouniol, Maryline Summo and François Sabot.

[*BMC Bioinformatics* 2015, 16:374  doi:10.1186/s12859-015-0795-6][paperLink]

##  INSTALLATION

[Follow the INSTALLATION instructions][installLink]

## MANUAL

[You can find a detailed MANUAL here][manualLink]

## KNOWN ISSUES

[You can find detailed known issues][knownIssues]

## Release Notes

[Current Release Notes][releaseLink]

## REQUIREMENTS

#### Perl

* [Capture::Tiny](http://search.cpan.org/~dagolden/Capture-Tiny-0.30/lib/Capture/Tiny.pm)
* [Data::Translate](http://search.cpan.org/~davieira/Data_Translate-0.3/Translate.pm)
* [Data::Dumper](http://search.cpan.org/~smueller/Data-Dumper-2.154/Dumper.pm)
* [Getopt::ArgParse](http://search.cpan.org/~mytram/Getopt-ArgParse-1.0.2/lib/Getopt/ArgParse.pm)
* [List::Compare](http://search.cpan.org/~jkeenan/List-Compare-0.53/lib/List/Compare.pm)
* [Switch](https://metacpan.org/pod/Switch)
* [Test::More](http://search.cpan.org/~exodist/Test-Simple-1.001014/lib/Test/More.pm)
* [Test::Deep](http://search.cpan.org/~rjbs/Test-Deep-0.119/lib/Test/Deep.pm)

#### Bioinformatics software (minimal version)

<table border="2">
<thead>
<tr>
	<th> Category        </th>
	<th> Software        </th>
	<th> Minimal version </th>
	<th> Tools included  </th>
</tr>
</thead>
<tbody>
<tr>
	<td rowspan="2"> <b>System<b>   </td>
	<td> <a href="https://www.java.com">Java</a> Please use non open JDK version</td>
	<td>1.7</td>
	<td></td>
</tr>
<tr>
	<td> [Perl](https://www.perl.org/)                 </td>
	<td>5.16</td>
	<td>                                  </td>
</tr>
<tr>
	<td rowspan="7"> <b>Mapping<b>  </td>
	<td> [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)</td>
	<td>2.2.9</td>
	<td></td>
</tr>
<tr>
	<td> [BWA](http://bio-bwa.sourceforge.net/)                          </td>
	<td>0.7.2</td>
	<td> bwaAln</br>bwaSampe</br>bwaSamse</br>bwaMem</br>bwaIndex</br></td>
</tr>
	<td> [Tophat](https://ccb.jhu.edu/software/tophat/index.shtml)       </td>
	<td>2.1.1</td>
	<td></td>
</tr>
</tbody>
</table>


* [SAMtools 0.1.18](http://samtools.sourceforge.net/)
* [PicardTools 1.63](http://broadinstitute.github.io/picard/)
* [GATK 3.3](https://www.broadinstitute.org/gatk/)
* [FastQC 0.10.1](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [Cutadapt 1.2.1](https://pypi.python.org/pypi/cutadapt)
* [FastxToolkit 0.0.13](http://hannonlab.cshl.edu/fastx_toolkit/)

* [Snpeff 4.2](http://snpeff.sourceforge.net/)
* [Stacks 1.43](http://catchenlab.life.illinois.edu/stacks/)
* [HTSeq-Count](http://www-huber.embl.de/HTSeq/doc/count.html)
* [Trinity 2.2.0](https://github.com/trinityrnaseq/trinityrnaseq/wiki)
* [TGICL](https://sourceforge.net/projects/tgicl/files/)
* [Pindel 0.2.4](http://gmt.genome.wustl.edu/packages/pindel/)
* [Breakdancer 1.4.5](http://breakdancer.sourceforge.net/)
#### Bioinformatics tools included


##### SamTools (http://samtools.sourceforge.net/)

- samToolsFaidx
- samToolsIndex
- samToolsView
- samToolsSort
- mergeHeader
- samToolsMerge
- samToolsIdxstats
- samToolsDepth
- samToolsFlagstat
- samToolsMpileUp

##### PicardTools (http://broadinstitute.github.io/picard/)

- picardToolsMarkDuplicates
- picardToolsCreateSequenceDictionary
- picardToolsSortSam
- picardToolsAddOrReplaceReadGroup
- picardToolsValidateSamFile
- picardToolsCleanSam
- picardToolsSamFormatConverter


##### GATK (https://www.broadinstitute.org/gatk/)

- gatkBaseRecalibrator
- gatkRealignerTargetCreator
- gatkIndelRealigner
- gatkHaplotypeCaller
- gatkSelectVariants
- gatkVariantFiltration
- gatkReadBackedPhasing
- gatkUnifiedGenotyper
- gatkBaseRecalibrator
- gatkPrintReads

##### Fastqc (http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

- fastqc

##### FastxToolkit (http://hannonlab.cshl.edu/fastx_toolkit/)

- fastxTrimmer

##### Tophat (https://ccb.jhu.edu/software/tophat/index.shtml)

- bowtiebuild
- bowtie2build
- tophat2

##### Snpeff (http://snpeff.sourceforge.net/)

- snpeffAnnotation

##### Cutadapt (https://pypi.python.org/pypi/cutadapt)

- cutadapt

##### Stacks (http://catchenlab.life.illinois.edu/stacks/)

- process_radtags

#### OPTIONAL
- Graphviz v2.xx (http://www.graphviz.org/)



[paperLink]:http://www.biomedcentral.com/1471-2105/16/374
[installLink]:https://github.com/SouthGreenPlatform/TOGGLE/blob/master/docs/INSTALL.md
[manualLink]:https://github.com/SouthGreenPlatform/TOGGLE/blob/master/docs/MANUAL.md
[knownIssues]:https://github.com/SouthGreenPlatform/TOGGLE-DEV/blob/master/docs/KnownIssues.md
[releaseLink]:https://github.com/SouthGreenPlatform/TOGGLE/blob/master/docs/ReleaseNotes.md
