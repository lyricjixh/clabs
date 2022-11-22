import pexpect
import yaml
from sh import Command
import json
import argparse
import pdb
import sys

def showCommands(host):
	prompt_dict = { 'dellos10': '\S+\d+[\S]-x#', 'ceos': '\$' }
	host_ssh_ip = var_dict['_meta']['hostvars'][host]['ansible_host'] 
	host_ssh_pass = var_dict['_meta']['hostvars'][host]['ansible_ssh_pass']
	host_nos = var_dict['_meta']['hostvars'][host]['ansible_network_os']
	prompt = prompt_dict[host_nos]
	print("*********************************")
	print("Generating log for %s" %(host))
	print("*********************************")
	with open('validation_cmd_list.yaml', 'r') as cmd_file:
		cmd_dict = yaml.safe_load(cmd_file)
	cmd_list = cmd_dict[host_nos]	
	logfile = '../LOGS/Northlake/' + host + '.txt'	
	session = pexpect.spawn('ssh admin@' + host_ssh_ip)
	session.logfile = open(logfile, 'w')	
	return_string = session.expect(["password:", "\(yes\/no\)\?"])
	if return_string == 1:
		session.sendline("yes")
		session.expect("password:")
	session.sendline(host_ssh_pass)
	session.expect(prompt)
	for cmd in cmd_list:
		session.sendline(cmd)
		session.expect(prompt)
	if host_nos == 'ceos':
		session.sendline('vtysh')
		session.expect(prompt_dict['dellos10'])
		session.sendline('show ip bgp summary')
		session.expect(prompt_dict['dellos10'])
		session.sendline('show ip bgp ipv6 unicast summary')
		session.expect(prompt_dict['dellos10'])
		session.sendline('show running-config')
		session.expect(prompt_dict['dellos10'])

def generateVar():
	inventory_command = Command("ansible-inventory")
	inventory_output = inventory_command('-i', '../inventory_nor.yaml', '--list')
	inventory_dict = json.loads(inventory_output.stdout)
	return(inventory_dict)

def getHostlist(group):
	global global_hosts_list
	if 'hosts' in var_dict[group]:
		global_hosts_list += var_dict[group]['hosts'][:]
	elif 'children' in var_dict[group]:
		for child in var_dict[group]['children']:
			getHostlist(child)
	return(global_hosts_list)
				

def main():
	if args.host:
		showCommands(args.host)
	elif args.group:
		hosts_list = getHostlist(args.group)
		for host in hosts_list:
			showCommands(host)

if __name__ == '__main__':
	parser = argparse.ArgumentParser()
	parser.add_argument("-n", "--host", help="Enter the host name")
	parser.add_argument("-g", "--group", help="Enter the group name")
	args = parser.parse_args()
	var_dict = generateVar()
	global_hosts_list = []
	main()

