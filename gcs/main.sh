#!bin/sh
if [ -n "$1" ] ; then
  GCP_PROJECT=$1
fi
echo Target project is [$GCP_PROJECT]

destroy () {
  echo .
  echo ..
  echo target is detected...
  echo target is [$1]
  echo .
  echo ..
  echo start deleting...
  echo .
  gsutil -m rm -r $1
  echo .
  echo finished.
}

gsutil list -p ${GCP_PROJECT} | awk '{printf "__name__:%s\n",$1}' | while read line
do
  if [ "`echo $line | grep __name__: `" ]; then
    NAME=`echo $line | sed -e 's/__name__://g'`
    destroy $NAME
  fi
done
echo Your project is clean!!
