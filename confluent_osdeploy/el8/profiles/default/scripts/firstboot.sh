#!/bin/sh

# This script is executed on the first boot after install has
# completed. It is best to edit the middle of the file as
# noted below so custom commands are executed before
# the script notifies confluent that install is fully complete.

nodename=$(grep ^NODENAME /etc/confluent/confluent.info|awk '{print $2}')
apikey=$(cat /etc/confluent/confluent.apikey)
mgr=$(grep deploy_server /etc/confluent/confluent.deploycfg|awk '{print $2}')
profile=$(grep ^profile: /etc/confluent/confluent.deploycfg|awk '{print $2}')
cat /etc/confluent/tls/*.pem >> /etc/pki/tls/certs/ca-bundle.crt
export nodename mgr profile
. /etc/confluent/functions


# Here is the most appropriate place to customize, for example:
#run_remote script.sh
#run_remote_python script.py


curl -X POST -d 'status: complete' -H "CONFLUENT_NODENAME: $nodename" -H "CONFLUENT_APIKEY: $apikey" https://$mgr/confluent-api/self/updatestatus
systemctl disable firstboot
rm /etc/systemd/system/firstboot.service
