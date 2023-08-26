#!/bn/bash

NAME="DevOPS"
PRIVATE_IPADDRESS=""
PRIVATE_IPADDRESS=$(aws ec2 run-instances --image-id ami-081609eef2e3cc958 --instance-type t2.micro --security-group-ids sg-00b35098594b5d64c --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIPAddress')

echo "PRIVATE_IPADDRESS:= $PRIVATE_IPADDRESS"