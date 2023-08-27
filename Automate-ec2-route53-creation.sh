#!/bn/bash

NAME=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=t2.micro
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-00b35098594b5d64c
DOMAIN_NAME=robokart.online
HOSTED_ZONE=Z07719251CXO88RVYQRQR
  
  for i in "${NAME[@]}"
  do 
   echo "Name:$NAME[i]"
  done

