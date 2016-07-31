
export makemkvcon=/Applications/MakeMKV.app/Contents/MacOS/makemkvcon
export HandBrakeCLI=~/Documents/scripts/HandBrakeCLI/HandBrakeCLI
decrypt_and_backup(){  # make a full decrypted disc backup
  mountedDiscFolder=${1:-NONO}
  # your new Movie Folder in $2
  newMovieFolder=${2:-NONO}
  if [ "$newMovieFolder" = "NONO" -o "$mountedDiscFolder" = "NONO" ]
  then
    echo "decrypt_and_backup <mountedDiscFolder> <newMovieFolder>"
    echo "decrypt_and_backup /Volumes/MovieName ~/Movies/MovieName"
  else
    echo "should not see this"
    ${makemkvcon} --decrypt backup disc:${mountedDiscFolder} ${newMovieFolder}
  fi
}

print_info(){
  # your Movie Folder in $1
  MovieFolder=${1:-NONO}
  if [ "$MovieFolder" = "NONO" ]
  then
    echo "print_info <MovieFolder>"
    echo "print_info  ~/Movies/MovieName"
  else
    ${makemkvcon}  -r --cache=1 info file:${MovieFolder}
  fi
}

create_mkv(){
  # your Movie Folder in $1
  MovieFolder=${1:-NONO}
  MKVFolder=${2:-NONO}
  if [ "$MovieFolder" = "NONO" -o "$MKVFolder" = "NONO" ]
  then
    echo "create_mkv <MovieFolder> <MKVFolder>"
    echo "create_mkv  ~/Movies/MovieName ~/Movies"
  else
    ${makemkvcon} --cache=1024 -r mkv file:${MovieFolder} 0 /Users/ruffact/Movies
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
    # name=BIG_BANG_S05_D01_E01
    echo; echo Processing $name; echo
    inFile=${name}.mkv
    outFile=${name}.mp4
    out="-o ${outPath}/${outFile}"
    source="-i ${inPath}/${inFile} --subtitle 1 "
    ${HandBrakeCLI} $source $out --preset="Android Tablet" --vfr
  done
}
