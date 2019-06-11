#!bin/sh
if [ -n "$1" ] ; then
  GCP_PROJECT=$1
fi
echo Target project is [$GCP_PROJECT]

destroy () {
  echo .
  echo ..
  echo target is detected...
  echo target is [$1] in [$2]
  echo .
  echo ..
  echo start deleting...
  gcloud -q compute instances delete $1 --zone $2 --project ${GCP_PROJECT}
  echo finished.
}

gcloud compute instances list --project ${GCP_PROJECT} | awk '$1 != "NAME" {printf "__name__:%s,__zone__:%s\n",$1,$2}' | while read line
do
  if [ "`echo $line | grep __name__: `" ]; then
    NAME=`echo $line | cut -d ',' -f 1 | sed -e 's/__name__://g'`
    ZONE=`echo $line | cut -d ',' -f 2 | sed -e 's/__zone__://g'`
    destroy $NAME $ZONE
  fi
done
echo Your project is clean!!
