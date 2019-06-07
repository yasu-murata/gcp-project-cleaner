#!bin/sh
if [ -n "$1" ] ; then
  GCP_PROJECT=$1
fi
echo Target project is [$GCP_PROJECT]

list_digest () {
  gcloud container images list-tags $1 --project ${GCP_PROJECT}  | awk '$1 != "DIGEST" {printf "__digest__:%s\n",$1}' | while read line
  do
    if [ "`echo $line | grep __digest__: `" ]; then
      DIGEST=`echo $line | sed -e 's/__digest__://g'`
      destroy $1 $DIGEST
    fi
  done
}

destroy () {
  echo .
  echo ..
  echo target is detected...
  echo target is [$1]@[$2]
  echo .
  echo ..
  echo start deleting...
  echo .
  gcloud -q container images delete --force-delete-tags $1@sha256:$2 --project ${GCP_PROJECT}
  echo .
  echo finished.
}

gcloud container images list --project ${GCP_PROJECT} | awk '$1 != "NAME" {printf "__name__:%s\n",$1}' | while read line
do
  if [ "`echo $line | grep __name__: `" ]; then
    NAME=`echo $line | sed -e 's/__name__://g'`
    list_digest $NAME
  fi
done
echo Your project is clean!!
