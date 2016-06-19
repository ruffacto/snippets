
in_bash_1() {
  rm f1 f2 f3 err.log both.log
  touch f1 f2 f3
  bash -i

  exec 1<>f1
  exec 2<>f2
  exec 3<>f3
  #./cmd 2>&1 1>&3
  #(./cmd 2>&1 1>&3 | tee err.log )
  #((./cmd 2>&1 1>&3 | tee err.log ) 3>&1 1>&2 )
  ((./cmd 2>&1 1>&3 | tee err.log ) 3>&1 1>&2 ) > both.log 2>&1
  lsof -a -p $$ -d0,1,2,3
  exit
}

in_bash_2(){
  rm both.log err.log
  bash -i
  pp=$PWD
  { coproc temm { tee $pp/err.log ;} >&3 ;} 3>&1
  exec 1>./both.log
  ./cmd 2>&${temm[1]}
  exit
}

in_ksh(){
  rm both.log err.log
  ksh -i

  tee ./err.log |&
  exec 4<&p
  exec 1>./both.log
  cat <&4 &
  exec 3>&p
  ./cmd 2>&3
  exit
}

ksh_in_production(){
  #######################

  # we start tee in the background
  # redirecting its output to the stdout of the script
  { coproc tee { tee logfile  } >&3  } 3>&1
  # we redirect stding and stdout of the script to our coprocess
  exec >&${tee[1]} 2>&1

  ## -----------------------------------------------------
   # sends output to standard output and to a log file
   # if executed using Tidal, shows log in Tidal Output tab
   # -----------------------------------------------------
  tee ${logFile} |&
  exec 4<&p
  cat <&4 &
  exec 3>&p
  exec 1>&-
  exec 1>&3
  exec 2>&1
}
