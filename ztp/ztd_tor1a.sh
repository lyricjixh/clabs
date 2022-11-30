#!/bin/bash
####################################################################
#
#
#  OS10 ZTD Provisioning Script
#
#
####################################################################
########## UPDATE THE BELOW CONFIG VARIABLES ACCORDINGLY ###########
########## ATLEAST ONE OF THEM SHOULD BE FILLED ####################
#IMG_FILE=”http://50.0.0.1/OS10.bin”
CLI_CONFIG_FILE="http:///172.100.100.134/cli_config_tor1a"
#POST_SCRIPT_FILE="http://50.0.0.1/no_post_script.py"
################### DO NOT MODIFY THE LINES BELOW #######################
sudo os10_ztd_start.sh "$IMG_FILE" "$CLI_CONFIG_FILE" "$POST_SCRIPT_FILE"
