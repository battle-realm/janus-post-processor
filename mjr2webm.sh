#!/bin/sh
set -e

FILES=$@
FAILED=""

if [ ! -x "$(command -v ffmpeg)" ]; then
  printf "\033[31mERROR\033[0m This script requires \033[1mffmpeg\033[0m\n"
  exit 1
fi

if [ ! -x "$(command -v janus-pp-rec)" ]; then
  printf "\033[31mERROR\033[0m This script requires \033[1mjanus-pp-rec\033[0m\n"
  exit 1
fi

if [ ! -d /tmp/janus-recordings ]; then
  mkdir /tmp/janus-recordings
fi

set +e
for video in $FILES
do
  echo "$video"
  filename=$(echo $video | awk -F"_" '{print $2}')
  echo "$filename"
  if [ -f "audio_"$filename ]; then
    printf "\033[36mProcessing\033[0m $filename\n"
    printf "  -> \033[35mExtracting video\033[0m\n"
    janus-pp-rec $video /tmp/janus-recordings/video.webm
    RESULT=$?
    printf "  -> \033[35mExtracting audio\033[0m\n"
    janus-pp-rec "audio_"$filename /tmp/janus-recordings/audio.opus
    RESULT=$?
    printf "  -> \033[33mMerging\033[0m\n"
    ffmpeg -i /tmp/janus-recordings/audio.opus -i /tmp/janus-recordings/video.webm -y -c:v copy -c:a copy $video.webm 
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      rm -rf /tmp/janus-recordings/video.webm
      rm -rf /tmp/janus-recordings/audio.opus
      rm -rf "$filename"*.mjr
      printf "  -> \033[32mComplete\033[0m\n"
    else
      rm -rf "$filename"*.webm
      FAILED="$FAILED "$filename
      printf "  -> \033[31mFailed\033[0m\n"
    fi
  fi
done
printf "\033[36mFinished processing\033[0m\n"
if [ -n "$FAILED" ]; then
  printf "\n\033[31mFailed converting following recordings\033[0m\n"
  for file in $FAILED; do
    printf "  $file\n"
  done
fi
