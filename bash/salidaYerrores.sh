(
  (  ./script.sh 2>&1 1>&3 |
     tee errores.log
  ) 3>&1 1>&2
) > ambos.log 2>&1
