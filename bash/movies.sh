
export makemkvcon=/Applications/MakeMKV.app/Contents/MacOS/makemkvcon
export HandBrakeCLI=~/Documents/scripts/HandBrakeCLI/HandBrakeCLI
decrypt_and_backup(){  # make a full decrypted disc backup
  mountedDiscNumber=${1:-NONO}
  newMovieFolder=${2:-NONO}
  if [ "$newMovieFolder" = "NONO" -o "$mountedDiscNumber" = "NONO" ]
  then
    echo "List all available drives" ; echo
    ${makemkvcon}  -r --cache=1 info disc:9999
    echo
    echo "decrypt_and_backup <mountedDiscNumber> <newMovieFolder>"
    echo "decrypt_and_backup 2 ~/Movies/MovieName"; echo
  else
    ${makemkvcon} --decrypt backup disc:${mountedDiscNumber} ${newMovieFolder}
  fi
}

print_info(){
  MovieFolder=${1:-NONO}
  if [ "$MovieFolder" = "NONO" ]
  then
    echo; echo "print_info <MovieFolder>"
    echo "print_info  ~/Movies/MovieName"; echo
  else
    TMPFILE=$(mktemp -q /tmp/print_info.XXXXXX)
    if [ $? -ne 0 ]; then
           echo "$0: Can't create temp file, exiting..."
           #exit 1
    fi
    ${makemkvcon}  -r --cache=1 info file:${MovieFolder} > ${TMPFILE}
    grep apter ${TMPFILE}
    echo; echo "full info can be found here: $TMPFILE"
  fi
}

create_mkv(){
  MovieFolder=${1:-NONO}
  TitleNumber=${2:-NONO}
  MKVFolder=${3:-NONO}
  if [ "$MovieFolder" = "NONO" -o "$MKVFolder" = "NONO" -o "$TitleNumber" = "NONO" ]
  then
    echo "create_mkv <MovieFolder> <TitleNumber> <MKVFolder>"
    echo "create_mkv  ~/Movies/MovieName 2 ~/Movies"
  else
    ${makemkvcon} --cache=1024 -r mkv file:${MovieFolder} ${TitleNumber} ${MKVFolder}
  fi
}

azulMKV_mp4(){
  outPath=${2:-NONO}
  inPath=${1:-NONO}

  if [ "$outPath" = "NONO" -o "$inPath" = "NONO" ]
  then
    echo "azulMKV_mp4 <MKVFolder> <mp4_Folder>"
    echo "azulMKV_mp4  ~/Movies/MovieName ~/Movies"
  else

    for full_path_name in $(ls ${inPath}/*mkv 2>/dev/null)
    do
      full_name=$(basename $full_path_name)
      name=${full_name%.*}
      echo; echo Processing $name; echo
      inFile=${name}.mkv
      outFile=${name}.mp4
      out="-o ${outPath}/${outFile}"
      source="-i ${inPath}/${inFile} --subtitle 1 "
      ${HandBrakeCLI} $source $out --preset="Android Tablet" --vfr
    done
  fi
}
