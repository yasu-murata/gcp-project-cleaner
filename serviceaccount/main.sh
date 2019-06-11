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
  gcloud -q iam service-accounts delete $1 --project ${GCP_PROJECT}
  echo finished.
}

# Only delete service-accounts created by user. Detect those by email address domain.
# Specified domain is given to User-created accounts, "dev-tky-fiot.iam.gserviceaccount.com"
gcloud iam service-accounts list --project ${GCP_PROJECT} --filter="EMAIL:dev-tky-fiot.iam.gserviceaccount.com" | awk '$1 != "NAME" {printf "__email__:%s\n",$2}' | while read line
do
  if [ "`echo $line | grep __email__: `" ]; then
    EMAIL=`echo $line | sed -e 's/__email__://g'`
    destroy $EMAIL
  fi
done
echo Your project is clean!!
