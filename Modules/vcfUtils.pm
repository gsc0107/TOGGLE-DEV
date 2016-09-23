package vcfUtils;

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
use warnings;
use localConfig;
use toolbox;

#For gz files
use IO::Compress::Gzip qw(gzip $GzipError);
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);

1;

=head1 NAME

    Package I<fastqUtils> 

=head1 SYNOPSIS

        use fastqUtils;
    
        fastqUtils::checkEncodeByASCIIcontrol ($fileName);
    
        fastqUtils::changeEncode ($fileIn,$fileOut,$formatInit,$formatOut);
	
	fastqUtils::convertLinePHRED64ToPHRED33 ($initialQuality);
	
	fastqUtils::convertLinePHRED33ToPHRED64 ($initialQuality);

=head1 DESCRIPTION

Package fastqUtils is a set of modules which deals with issues relative to FASTQ format files

=head2 FUNCTIONS
 

=head3 fastqUtils::checkEncodeByASCIIcontrol

This module check the FASTQ format of a given file, in plain text or in gz
It takes only one argument, the file you want to know the encoding



=head3 fastqUtils::changeEncode

This module change a FASTQ PHRED format in another
it takes four arguments: the file you want to change encoding (plain or gz), the name of the output file, the PHRED format of your initial file, the PHRED format you want in the output file



=head3 fastqUtils::convertLinePHRED64ToPHRED33

This module change a PHRED 64 quality line in PHRED 33
It takes only one argument, the initial quality of your file



=head3 fastqUtils::convertLinePHRED33ToPHRED64

This module change a PHRED 33 quality line in PHRED 64
It takes only one argument, the initial quality of your file



=head1 AUTHORS

Intellectual property belongs to IRD, CIRAD and South Green developpement plateform 
Written by Cecile Monat, Ayite Kougbeadjo, Marilyne Summo, Cedric Farcy, Mawusse Agbessi, Christine Tranchant and Francois Sabot

=head1 SEE ALSO

L<http://www.southgreen.fr/>

=cut
