#!/bin/zsh

ssh-keygen -R 192.168.12.20

for i in {111..120}; do ssh-keygen -R 192.168.12.$i; done

ssh-keyscan -H 192.168.12.20 >> ~/.ssh/known_hosts

for ip in {111..120}; do ssh-keyscan -H 192.168.12.$ip >> ~/.ssh/known_hosts; done



