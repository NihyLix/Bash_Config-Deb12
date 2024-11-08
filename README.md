#!/bin/sh

echo "Indiquer ce que vous souhaitez installer (separer par des virgules)"
read menu

#la fonction de selection est en cours de developpement

function standard()
{
	function update()
	{
		path="/etc/apt"
		sourcelist="
		deb http://deb.debian.org/debian bookworm main contrib non-free 
		deb-src http://deb.debian.org/debian bookworm main contrib non-free 

		deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free
		deb-src http://deb.debian.org/debian-security/ bookworm-security main contrib non-free

		deb http://deb.debian.org/debian bookworm-updates main contrib non-free
		deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free

		"
		#source : https://wiki.debian.org/SourcesList

		#---sourcelist---#
		mv /etc/apt/source.list /etc/apt/source.list.bck
		touch /etc/apt/source.list
		echo $sourcelist > $path/source.list

		#---mise a jour des paquets et nettoyage---#
		apt update && apt upgrade -y && apt autoremove -y && apt purge $(dpkg --list |grep '^rc' |awk '{print $2}') -y
		# dpkg –list : liste tous les paquets présent sur le système
    	# grep ‘^rc’ : cherche les paquets désinstallés mais pas purgés
    	# awk ‘{print $2}’ : filtre l’affichage de la sortie de la commande précédente
    	# source : https://memo-linux.com/debian-nettoyer-les-paquets-residuels/

    	#---configuration mise a jour auto---#
    	#apt install unattended-upgrades
    	#/etc/apt/apt.conf.d/50unattended-upgrades
		#Il y a plusieurs sections dans ce fichier :
		#Section Unattended-Upgrade::Origins-Pattern : Cela correspond aux sources de mise à jour. 
		#Par défaut seul Debian (dépôt de base) et Debian-Security sont actifs. 
		#Si on souhaite tout mettre à jour, on peut décommenter updates et proposed-updates

	}

	function default_package()
	{
		apt install sudo ssh -y
	}

	function account_user()
	{
		#limiter l'environnement utilisateur
	}

	function account_root()
	{
		#---bashrc---#
		echo PATH=/usr/sbin:$PATH >> /root/.bashrc

	}

	function secu_net()
	{
		#iptable ssh (random port+clef rsa)
		apt install ufw -y
		ufw allow $portssh
		ufw enable
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
		folder="$HOME/tempo_download"
		v=$v #php version
		#---installation package---#
		apt install apache2 -y

		#---configuration environnement---#
		mkdir $folder
		mkdir /var/log/apache2/vhost
		mkdir /etc/ssl/vhost
		mkdir /var/www/vhost 
		chown -R www-data:www-data /var/www/vhost 

		#---desactivation site par defaut---#
		cd /etc/apache2/sites-available/
		a2dissite 000-default.conf 

		#---creation et activation nouvelle conf
		touch /etc/apache2/sites-available/vhost.conf
		cd /etc/apache2/sites-available/
		apachectl configtest >> /var/log/apache2/log_script
		a2ensite vhost.conf

		#---activation des modules de securite---#
		a2enmod ssl 
		a2enmod headers

		#---redemarrage du service---#
		apachectl restart

		#---installation source php---#
		apt -y install lsb-release apt-transport-https ca-certificates  
		wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg  
		echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php8.list  
		apt update && apt upgrade -y

		#installation module classique php
		apt install libapache2-mod-php$v php$v php$v-xml php$v-curl php$v-gd php$v php$v-cgi php$v-cli php$v-zip php$v-bcmath php$v-gmp php$v-mysql php$v-mbstring php$v-intl php$v-imagick php$v-gd -y

		#configuration standard FR
		wget url_fichier_conf
		mv $folder/url_fichier_conf /etc/php/$v/apache2/php.ini

		#---HTTPS/HSTS---#
		wget url_fichier_conf
		openssl genrsa -out /etc/ssl/vhost/vhost.key 8192  
		openssl req -new -x509 -key /etc/ssl/vhost/vhist.key -subj "/CN=BHO_Script" -out /etc/ssl/vhost/vhost.pem
		mv $folder/url_fichier_conf /etc/apache2/sites-available/vhost.conf
		apachectl configtest >> /var/log/apache2/log_script
		apachectl restart

		#---CERTBOT PREP---#
		apt install snapd  
		snap install core; sudo snap refresh core  
		snap install --classic certbot  
		ln -s /snap/bin/certbot /usr/bin/certbot  

		#---SECU CONF SRV---#
		wget url_fichier_conf
		mv $folder/url_fichier_conf /etc/apache2/conf-available/security.conf
		ufw 80
		ufw 443

		#---fin---#
		systemctl stop apache2 && systemctl start apache2

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
