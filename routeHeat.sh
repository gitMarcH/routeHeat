#!/bin/bash

#License - GNU General Public License, Version 3
#--------------
#Copyright (C) 2014 Marc Henrion
#
#This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

#-----what this script depends on to run successfully
# bash shell (this pre-processing script)
# gpsbabel (conversion from FIT to GPX format if required)
# R (routeHeat.R -- the actual plotting script)

#-----input parameters
outFile=$1; shift # path & name of plot file
bgCol=$1; shift # background colour
trkCol=$1; shift # track line colour
tmpPrefix=$1; shift # path & name for a temporary files
latMin=$1; shift # lower latitude plot limit (set latMin==latMax for no limit)
latMax=$1; shift # upper latitude plot limit (set latMin==latMax for no limit)
longMin=$1; shift # lower longitude plot limit (set longMin==longMax for no limit)
longMax=$1; shift # upper0 longitude plot limit (set longMin==longMax for no limit)
lwd=$1; shift # plotting line width
alpha=$1; shift # plotting line transparency
outFormat=$1; shift # pdf, svg or png?
prefixGPX=$@ # path & filename start of the input filenames

baseDir=$(dirname $0)
Rscript=$baseDir/routeHeat.R
gpsBabel="gpsbabel" # change this to a full path to the gpsbabel binary if not in $PATH

echo "routeHeat v1.0"
echo "Input parameters:"
echo "prefixGPX = < $prefixGPX >"
echo "latMin = < $latMin >"
echo "latMax = < $latMax >"
echo "longMin = < $longMin >"
echo "longMax = < $longMax >"
echo "outFile = < $outFile >"
echo "bgCol = < $bgCol >"
echo "trkCol = < $trkCol >"
echo "lwd = < $lwd >"
echo "alpha = < $alpha >"
echo "tmpPrefix = < $tmpPrefix >"
echo "baseDir = < $baseDir >"
echo "Rscript = < $Rscript >"
echo "gpsBabel = < $gpsBabel >"

#-----check that input files exist and set defaults if not specified
pathGPX=`dirname $prefixGPX`
filePrefGPX=`basename $prefixGPX`
numFiles=`find $pathGPX -name $filePrefGPX* | wc -l`
if [ $numFiles -eq 0 ]; then
    echo "No input files detected (numFiles = < $numFiles >)."
    exit  
fi
if [ -z $bgCol ]; then
    bgCol="white"
fi
if [ -z $trkCol ]; then
    trkCol="red"
fi
if [ -z $tmpPrefix ]; then
    tmpPrefix="tmpFilerouteHeat"
fi
tmpFile=$tmpPrefix

#-----convert fit files to gpx if fit files provided
counter=0

pathFIT=`dirname $prefixGPX`
filePrefFIT=`basename $prefixGPX`
checkFIT=`find $pathFIT -name $filePrefFIT*.[fF][iI][tT] | wc -l`
if [ $checkFIT -gt 0 ]; then
    for file in $prefixGPX*.[fF][iI][tT]; do
	counter=`echo "$counter + 1" | bc`
	gpsbabel -i garmin_fit -f $file -o gpx -F $prefixGPX"_FIT2GPX_gpsbabel_"$counter".gpx" 
    done
fi

#-----extract longitude and latitude from files and concatenate into tmpFile
if [ -e $tmpFile ]; then rm $tmpFile; fi
touch $tmpFile

counter=0
for file in $prefixGPX*.gpx; do
    echo "DEBUG: $file"
    ((counter++))
    cat $file | grep "<trkpt" | awk -v counter="$counter" -F "\"" '{print $2,$4,counter,0}' OFS="\t" >> $tmpFile
    cat $file | grep "<startPoint" | awk -v counter="$counter" -F "\"" '{print $2,$4,counter,1}' OFS="\t" >> $tmpFile
    cat $file | grep "<endPoint" | awk -v counter="$counter" -F "\"" '{print $2,$4,counter,2}' OFS="\t" >> $tmpFile
done

#-----start R to do the plotting
R --vanilla < $Rscript --args $tmpFile $outFile $bgCol $trkCol $latMin $latMax $longMin $longMax $lwd $alpha $outFormat

#-----exit
rm $tmpFile

pathFIT2GPX=`dirname $prefixGPX\_FIT2GPX_gpsbabel`
filePrefFIT2GPX=`basename $prefixGPX\_FIT2GPX_gpsbabel`
tmpCheck=`find $pathFIT2GPX -name $filePrefFIT2GPX\_*.[gG][pP][xX] | wc -l`
if [ $tmpCheck -gt 0 ]; then
    rm $prefixGPX\_FIT2GPX_gpsbabel_*.gpx
fi
echo "This is the end." 
