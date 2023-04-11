#!/bin/bash

mkdir -p /root/shell
cp -r ./src/shell/* /root/shell
chmod +x /root/shell/*
echo $1 > /root/shell/config
