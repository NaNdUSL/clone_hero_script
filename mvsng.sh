# This is a simple script that takes Zip folders with Clone Hero related files
# and puts them in the .clonehero/Songs/ directory with the respective song name.

SONGS_FOLDER='$HOME/.clonehero/Songs/'

move_song () {

    SONG_NAME=$(echo $1 | sed '1s/[[:blank:]]*(.*$//')
    DEST_FOLDER="$SONGS_FOLDER${SONG_NAME}/"

	echo -e "\n> Song name:" "$SONG_NAME"
	echo -e "\n> Destination folder:" "$DEST_FOLDER"
	mkdir "$DEST_FOLDER"

    unzip "${2}/$1" -d "${DEST_FOLDER}"
    echo -e "\n> Unziped $1 to $DEST_FOLDER"

    TEMP_FOLDER="${DEST_FOLDER}$(ls "$DEST_FOLDER/")/"
    CONTENTS=$(echo $(ls "$TEMP_FOLDER"))
    echo -e "\n> Folder contents: $CONTENTS"
    
    for FILE in $CONTENTS; do

        if [ $(file -b "${TEMP_FOLDER}${FILE}" | cut -d, -f2 | cut -d" " -f2) = "MP4" ]; then

            echo -e "\nConverting MP4 to WEBM"
            ffmpeg -i "${TEMP_FOLDER}video.mp4" -c:v libvpx -crf 10 -b:v 1M -c:a libopus -b:a 128k "${TEMP_FOLDER}video.webm"
            rm "${TEMP_FOLDER}video.mp4"
        fi
    done

    MV_FOLDER="${DEST_FOLDER}$(echo "$(ls "${DEST_FOLDER}/")")"
    mv "${MV_FOLDER}"/* "$DEST_FOLDER"
	echo -e "\nMoved files into" "$DEST_FOLDER"
	
    rm -r "$MV_FOLDER"
	echo -e "\n>Folder removed:" "$MV_FOLDER"
}

if [ "$#" -lt 1 -o "$#" -gt 2 ]; then
    echo -e "\nUsage: mvsng [zip]"
    echo "Usage: mvsng -d [directory]"
    exit 1
fi

if [ "$#" -eq 1 ] && [ "$(file -b "$1" | cut -d, -f1 | cut -d" " -f1)" = "Zip" ]; then

    move_song "$1" $(echo "$1" | sed "s/\/.*$//g")

elif [ "$#" -eq 2 -a "$1" = "-d" -a -d "$2" ]; then

    LIST_FILES=$(ls "$2" | sed "s/ /\.\./g")
    
    for FILE in $LIST_FILES; do

        LINE=$(echo $FILE | sed "s/\.\./ /g")
        move_song "$LINE" "$2"
    done
fi
