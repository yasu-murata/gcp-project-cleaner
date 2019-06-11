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
  gcloud -q compute networks delete $1 --project ${GCP_PROJECT}
  echo finished.
}

gcloud compute networks list --project ${GCP_PROJECT} | awk '$1 != "NAME" {printf "__name__:%s\n",$1}' | while read line
do
  if [ "`echo $line | grep __name__: `" ]; then
    NAME=`echo $line | sed -e 's/__name__://g'`

    # DO NOT delete rules with default network
    if [ $NAME != "default" ]; then
      destroy $NAME
    fi
  fi
done
echo Your project is clean!!
