#!/bin/bash

echo ` curl -fsSL https://get.docker.com -o get-docker.sh`
echo ` sh get-docker.sh`
echo `systemctl status docker`
echo `systemctl restart docker`
