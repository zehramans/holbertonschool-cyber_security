#!/bin/bash
sudo iptables --append INPUT -p tcp --destination-port 80 -j ACCEPT 
