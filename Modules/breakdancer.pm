package breakdancer;

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


sub bam2cfgRun
{
    my($listOfBam,$breakdancerConfigFile,$optionsHachees)=@_;
     if (toolbox::sizeFile($listOfBam)==1)
     { ##Check if entry file exist and is not empty

        my $bamFiles_names="";
        foreach my $file (@{$listOfBam})       # for each BAM file(s)
        {
            if (toolbox::checkSamOrBamFormat($file)==2 and toolbox::sizeFile($file)==1)        # if current file is not empty
            {
                $bamFiles_names.=" ".$file." ";       # recovery of informations fo command line used later
            }
            else        # if current file is empty
            {
                toolbox::exportLog("ERROR: gatk::gatkHaplotypeCaller : The file $file is uncorrect\n", 0);      # returns the error message
                return 0;
            }
        }
        
          my $options="";
          if ($optionsHachees) {
               $options=toolbox::extractOptions($optionsHachees); ##Get given options
          }
          my $command=$bam2cfg." ".$options." ".$bamFiles_names." > ".$breakdancerConfigFile;
          #toolbox::exportLog($command."\n",1);
          #Execute command
          if(toolbox::run($command)==1)
          {
               return 1;#Command Ok
          }
          else
          {
               toolbox::exportLog("ERROR: breakdancer::breakdancerRun : Uncorrectly done\n",0);
               return 0;#Command not Ok
          }
     }
     else
     {
        toolbox::exportLog("ERROR: breakdancer::breakdancerRun : The file $listOfBam is uncorrect\n",0);
        return 0;#File not Ok
     }
}

sub breakdancerRun
{
    my($breakdancerConfigFile,$optionsHachees)=@_;
    if (toolbox::sizeFile($breakdancerConfigFile)==1)
    { ##Check if entry file exist and is not empty
        
        my $options="";
        if ($optionsHachees)
        {
            $options=toolbox::extractOptions($optionsHachees); ##Get given options
        }
        my $command=$breakdancer." ".$options." ".$breakdancerConfigFile;
        #toolbox::exportLog($command."\n",1);
        #Execute command
        if(toolbox::run($command)==1)
        {
            return 1;#Command Ok
        }
        else
        {
            toolbox::exportLog("ERROR: breakdancer::breakdancerlRun : Uncorrectly done\n",0);
            return 0;#Command not Ok
        }
    }
    else
    {
       toolbox::exportLog("ERROR: breakdancer::breakdancerRun : The file $breakdancerConfigFile is uncorrect\n",0);
       return 0;#File not Ok
    }
}

1;