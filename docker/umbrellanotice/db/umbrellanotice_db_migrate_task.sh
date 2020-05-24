#!/bin/sh

aws ecs start-task --cluster $AWS_ECS_ARN --container-instances $AWS_ECS_ContainerInstance_ID --task-definition umbrellanotice_db_migrate:3

#aws ecs start-task --cluster umbrellanotice-Cruster --container-instances d4926f34-f8ae-4f37-8974-1a72e34f5dbf --task-definition umbrellanotice_db_migrate:3 --profile Umbrellanotice_ECS_Access_User