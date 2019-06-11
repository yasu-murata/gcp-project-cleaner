#!bin/sh
if [ -n "$1" ] ; then
  GCP_PROJECT=$1
fi
echo Target project is [$GCP_PROJECT]

destroy_topics () {
  echo .
  echo ..
  echo target is detected...
  echo target is [$1]
  echo .
  echo ..
  echo start deleting...
  gcloud -q pubsub topics delete $1 --project ${GCP_PROJECT}
  echo finished.
}

destroy_subscriptions () {
  echo .
  echo ..
  echo target is detected...
  echo target is [$1]
  echo .
  echo ..
  echo start deleting...
  echo .
  gcloud -q pubsub subscriptions delete $1 --project ${GCP_PROJECT}
  echo .
  echo finished.
}

gcloud pubsub topics list --project ${GCP_PROJECT} | awk '$1 != "---" {printf "__name__:%s\n",$2}' | while read line
do
  if [ "`echo $line | grep __name__: `" ]; then
    NAME=`echo $line | sed -e 's/__name__://g'`
    destroy_topics $NAME
  fi
done
gcloud pubsub subscriptions list --project ${GCP_PROJECT} | grep name: | awk '{printf "__name__:%s\n",$2}' | while read line
do
  if [ "`echo $line | grep __name__: `" ]; then
    NAME=`echo $line | sed -e 's/__name__://g'`
    destroy_subscriptions $NAME
  fi
done
echo Your project is clean!!
