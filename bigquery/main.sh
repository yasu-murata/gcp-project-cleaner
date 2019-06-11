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
  bq rm --project_id ${GCP_PROJECT} -r -f $1
  echo finished.
}

bq ls --project_id ${GCP_PROJECT} | awk 'NR >= 3 {printf "__dataset__:%s\n",$1}' | while read line
do
  if [ "`echo $line | grep __dataset__: `" ]; then
    DATASET=`echo $line | sed -e 's/__dataset__://g'`
    destroy $DATASET
  fi
done
echo Your project is clean!!
