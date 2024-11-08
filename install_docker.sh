#!/bin/sh

echo "Indiquer ce que vous souhaitez installer (separer par des virgules)"
read $menu

function initialisation()
{
	function update()
	{
		#sourcelist update&upgrade
	}

	function default_package()
	{
		# apt install sudo ssh 
	}

	function account_user()
	{
		#limiter l'environnement utilisateur
	}

	function account_root()
	{
		#bashrc 
	}

	function secu_net()
	{
		#iptable ssh (random port+clef rsa)
	}

	function secu_sys()
	{
		#jsaispaquoimettre
	}

	echo "pas encore developpé"
}

function web()
{
	function apache()
	{

	}

	function nginx()
	{

	}

	echo "Apache (1), nginx (2) ?"
	read $web_server

	if [ $web_server -e 1 ]
	then
		apache

	elif [ $web_server -e 2 ]
	then
		nginx

	elif [ $web_server -e 1 ] && [ $web_server -e 2 ]
	then
		apache 
		nginx

	else
		echo "error selection"
	fi
}

function docker()
{
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; 	
		do sudo apt remove $pkg -y;
	done

	# Add Docker's official GPG key:
	sudo apt update
	sudo apt install ca-certificates curl -y
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update 

	#installation des dependances
	sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin -y

	#test bon fonctionnement
	sudo docker run hello-world
}