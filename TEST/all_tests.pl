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