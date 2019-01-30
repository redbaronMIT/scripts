#!/bin/bash
# a script to rename files based on EXIF date
shopt -s nocaseglob
if [[ $1 == 'test' ]]
then
	echo "**TESTING ONLY**"
else
	echo "**WARNING THIS WILL CHANGE FILE NAMES**"
fi

if [[ $1 == 'full' ]]
then
	echo "__Using full name minus extension__"
fi

echo $PWD
echo -e "file extensions to use"
 read extin
extin=".$extin"
echo $extin
for f in *${extin}; do
	suffix="${f##*[.]}"
	filename="${f%.*}"
	strip_nums=${filename//[0-9_]/}
	if [[ $1 == 'full' ]]
	then
		rename_base=$filename"-"
	else
		rename_base=$strip_nums
	fi
	echo $f
	echo "=suffix: "$suffix
	echo "=filename: "$filename
	echo "=strip_nums: "$strip_nums
exifname="$rename_base""$(exiftool -d "%Y%m%d_%H%M%S" -CreateDate "$f" | awk '{print $4}')"
modifname="$rename_base""$(date -r "$f" +"%Y%m%d_%H%M%S")"

if [[ $1 == 'test' ]]
then
	echo "=EXIF : "$exifname".$suffix"
	echo "=MODIF: ""$rename_base""$(date -r "$f" +"%Y%m%d_%H%M%S")"".$suffix"
else
	#	echo "FOR REALZIES"
	#{
	mv -n "$f" "$rename_base""$(exiftool -d "%Y%m%d_%H%M%S" -CreateDate "$f" | awk '{print $4}')"".$suffix"
	#} || {echo "$rename_base""$(date -r "$f" +"%Y%m%d_%H%M%S")"".$suffix"}
fi

#rename other files with same name
for g in $filename.*; do 
    ext="${g##*.}" 
    mv "$g" $exifname".$ext"
done

done

