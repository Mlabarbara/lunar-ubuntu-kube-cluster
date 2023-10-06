#!/bin/zsh

# I have an alias for 'terraform apply -auto-approve'
# yes I understand the irony 
#terraform init
#terraform apply -auto-approve

# check if completed without errors

if [ $? -eq 0 ]
# if we are good then start playbook loop through array of plays
then 
  playbooks=("ansible-install-kubernetes-dependencies.yml" "ansible-init-cluster.yml" "ansible-get-join-command.yml" "ansible-join-workers.yaml")
  # init loop
  for playbook in "${playbooks[@]}"
  do
    ansible-playbook -i ansible-hosts.txt $playbook
  done
else
  echo "Terraform failed to create VMs"
  echo "lol jk i have no clue what failed, figure your shit out"
  echo "really, no error checking or handling..."
  exit 1
fi 

