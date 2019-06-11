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
  gcloud -q compute addresses delete $1 --global --project ${GCP_PROJECT}
  echo finished.
}

gcloud compute addresses list --project ${GCP_PROJECT} | awk '$1 != "NAME" {printf "__name__:%s,__network__:%s\n",$1,$5}' | while read line
do
  if [ "`echo $line | grep __name__: `" ]; then
    NAME=`echo $line | cut -d ',' -f 1 | sed -e 's/__name__://g'`
    NETWORK=`echo $line | cut -d ',' -f 2 | sed -e 's/__network__://g'`

    # DO NOT delete rules with default network
    if [ $NETWORK != "default" ]; then
      destroy $NAME
    fi
  fi
done
echo Your project is clean!!
