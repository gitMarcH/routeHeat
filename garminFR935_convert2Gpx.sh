inDir=$1; shift
outDir=$1; shift
gpsBabel="gpsbabel" # change this to a full path to the gpsbabel binary if not in $PATH


#-----notes
# info below posted by user Fletnix on Garmin forum:
# https://forums.garmin.com/forum/into-sports/running/forerunner-920xt-aa/80255-saved-file-name
#
# The Garmin Forerunner 220 and 620 (FR220 and FR620) save their activity
# files with a cryptic name on the watch. Based on Jeff Pethybridge's
# (ZUKJEFF) analysis and my own findings, these would be the filename codes:
#
# Example: 43S64121.FIT
#
# Char 1 is year: 3 (2013), 4 (2014) ... Will clash in ten years time!
# Char 2 is month: 1-9 and A, B, C (10, 11, 12).
# Char 3 is daynr: 1-9 and A-V (10-31).
# Char 4 is hour: 0-9 and A-N (10-23).
# Chars 5 and 6 are the minutes: 00-59.
# Chars 7 and 8 are the seconds: 00-59.
#
# Above .FIT is 201(4), March (3), the 28:th (S), 6 AM (6), min (41), sec (21)
# and that is when the activity was _started_.
#
# Code below also based in part on code from Fletnix.

#-----getting info on current decade, setting up lookup tables etc
dateYear=$(date +%Y)
dateMillenium=${dateYear:0:1}
dateCentury=${dateYear:1:1}
dateDecade=${dateYear:2:1}

function convertgarminchar {
  case $GCHAR in
    '0')
      NCHAR=0
      ;;
    '1')
      NCHAR=1
      ;;
    '2')
      NCHAR=2
      ;;
    '3')
      NCHAR=3
      ;;
    '4')
      NCHAR=4
      ;;
    '5')
      NCHAR=5
      ;;
    '6')
      NCHAR=6
      ;;
    '7')
      NCHAR=7
      ;;
    '8')
      NCHAR=8
      ;;
    '9')
      NCHAR=9
      ;;
    'A')
      NCHAR=10
      ;;
    'B')
      NCHAR=11
      ;;
    'C')
      NCHAR=12
      ;;
    'D')
      NCHAR=13
      ;;
    'E')
      NCHAR=14
      ;;
    'F')
      NCHAR=15
      ;;
    'G')
      NCHAR=16
      ;;
    'H')
      NCHAR=17
      ;;
    'I')
      NCHAR=18
      ;;
    'J')
      NCHAR=19
      ;;
    'K')
      NCHAR=20
      ;;
    'L')
      NCHAR=21
      ;;
    'M')
      NCHAR=22
      ;;
    'N')
      NCHAR=23
      ;;
    'O')
      NCHAR=24
      ;;
    'P')
      NCHAR=25
      ;;
    'Q')
      NCHAR=26
      ;;
    'R')
      NCHAR=27
      ;;
    'S')
      NCHAR=28
      ;;
    'T')
      NCHAR=29
      ;;
    'U')
      NCHAR=30
      ;;
    'V')
      NCHAR=31
      ;;
    'W')
      NCHAR=32
      ;;
    'X')
      NCHAR=33
      ;;
    'Y')
      NCHAR=34
      ;;
    'Z')
      NCHAR=35
      ;;
    *)
    esac
}

mkdir -p $outDir


#-----convert filenames
counter=0

fitFiles=`find $inDir -name *.[fF][iI][tT]`;
checkFIT=`find $inDir -name *.[fF][iI][tT] | wc -l`
if [ $checkFIT -gt 0 ]; then
    for file in $fitFiles; do
	garminFilename=`basename $file`
	garminFilename="${garminFilename%%.*}"

	# split the garmin filename
	garminChar1=${garminFilename:0:1}
	garminChar2=${garminFilename:1:1}
	garminChar3=${garminFilename:2:1}
	garminChar4=${garminFilename:3:1}
	garminChar56=${garminFilename:4:2}
	garminChar78=${garminFilename:6:2}

	garminFilenameReconstructed=$garminChar1$garminChar2$garminChar3$garminChar4$garminChar56$garminChar78

	# check that the input filename does not have extra characters
	if ! test "$garminFilenameReconstructed" == "$garminFilename"; then
	    #echo "The provided filename ($garminFilename.FIT/fit) does not match the expected format ($garminFilenameReconstructed.FIT/fit).";
	    #echo "I will skip this file"
	    continue
	fi

	# convert the filename
	outYear=$dateMillenium$dateCentury$dateDecade$garminChar1
	outMonth=`GCHAR=$garminChar2; convertgarminchar; echo "$NCHAR"`
	outDay=`GCHAR=$garminChar3; convertgarminchar; echo "$NCHAR"`
	outHour=`GCHAR=$garminChar4; convertgarminchar; echo "$NCHAR"`
	outMin=$garminChar56
	outSec=$garminChar78

	outMonth=`printf "%02d" $outMonth` # padding with a leading 0 if needed
	outDay=`printf "%02d" $outDay` # padding with a leading 0 if needed
	outHour=`printf "%02d" $outHour` # padding with a leading 0 if needed

	convertedName=$outYear"-"$outMonth"-"$outDay"-"$outHour"-"$outMin"-"$outSec"_"$garminFilename

	# convert the FIT file to GPX using the recoded base filename (only if it does not already exist)
	if ! test -f $outDir"/"$convertedName".gpx"; then
	    echo "Converting $file to $outDir/$convertedName.gpx;"
	    gpsbabel -i garmin_fit -f $file -o gpx -F $outDir"/"$convertedName".gpx" 

	    counter=`echo "$counter + 1" | bc`
	fi
    done
fi


#-----exit
echo "This is the end, my friend. I have converted $counter files."
