#!/bn/bash

#NAME=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
NAME=$@
INSTANCE_TYPE=t2.micro
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-00b35098594b5d64c
DOMAIN_NAME=robokart.online
HOSTED_ZONE=Z07719251CXO88RVYQRQR
  
  for i in "$@"
  do 
   echo "Creating $i instance"
IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
   echo "Created $i instance :$IP_ADDRESS"

aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMAIN_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '
    echo "Domain Name Server created for $i :$i.$DOMAIN_NAME"
  done

