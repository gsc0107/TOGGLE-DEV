package trinity;

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
use Data::Dumper;


sub trinityRun
{
     my($outputDir,$single,$paired,$optionsHachees)=@_;  ## if paired reads give $single as --left and $paired as --right; else give only $single
     if ($single ne "NA" and toolbox::checkFormatFastq($single)==1 )
     { ##Check if entry file exist and is not empty
        my $command="";
        my $options="";
        if ($optionsHachees)
        {
             $options=toolbox::extractOptions($optionsHachees); ##Get given options
        }
        #print $options,"\n";
        if ($options !~ m/--max_memory\s\w+/) # The type of walker is not informed in the options
        {
            $options .= " --max_memory 20G";
        }      
        
        if ($paired ne "NA") ## we have paired reads
        { ##Check if entry file exist and is not empty
            if (toolbox::checkFormatFastq($paired)==1)
            {
                if ($options !~ m/--seqType fq/) # The type of walker is not informed in the options
                {
                    $options .= " --seqType fq";
                }
                $command=$trinity." ".$options." --left ".$single." --right ".$paired.' --output '. $outputDir;
            }
            else
            {
                toolbox::exportLog("ERROR: trinity::trinityRun : The file $paired is not a Fastq\n",0);
                return 0;#File not Ok
            }
        }
        else  ## $paired is empty or doesn't exist
        {
            if ($options !~ m/--seqType fq/) # The type of walker is not informed in the options
            {
                $options .= " --seqType fq";
            }
            $command=$trinity." ".$options." --single ".$single.' --output '.$outputDir;
        }
        
        #toolbox::exportLog($command."\n",1);
        #Execute command
        if(toolbox::run($command)==1)
        {
             return 1;#Command Ok
        }
        else
        {
             toolbox::exportLog("ERROR: trinity::trinityRun : Uncorrectly done\n",0);
             return 0;#Command not Ok
        }
     }
     else
     {
        toolbox::exportLog("ERROR: trinity::trinityRun : The file $single is uncorrect or is not a Fastq\n",0);
        return 0;#File not Ok
     }
}

1;