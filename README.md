# 🛠️ Script de Configuration Initiale Debian

Ce script shell a pour objectif d'automatiser la configuration initiale d’un serveur Debian, incluant la configuration système, l’installation de services web, la sécurité réseau, et l’installation de Docker.

>[!CAUTION]
>En cours de developpement, non fonctionnel à 100%


## 📦 Fonctionnalités principales

Le script est organisé autour de **plusieurs fonctions modulaires**, regroupées en deux grandes catégories :

### 🔧 1. Configuration Standard

- **Update** :
  - Met à jour les sources APT (basé sur Debian Bookworm).
  - Lance une mise à jour complète du système.
  - Nettoie les paquets résiduels (`rc`).
  - Prépare la configuration pour les mises à jour automatiques (non activée par défaut).

- **Default Packages** :
  - Installe des paquets de base : `sudo`, `ssh`.

- **Account User / Root** :
  - Prépare la configuration des comptes utilisateurs.
  - Ajoute `/usr/sbin` au `PATH` root.
>[!CAUTION]
>Fonctionnalité non implémentée en totalité.

- **Sécurité Réseau** :
  - Installe et configure `ufw` (pare-feu).
  - N’autorise que le port SSH (variable `$portssh`).

- **Sécurité Système** :
  - Prévu pour des ajouts futurs (non implémenté).

### 🔧 2. Configuration Sécurisé

>[!NOTE]
>Fonctionnalité non implémentée


### 🌐 1.2. Installation d'Applications

#### Serveur Web
- **Apache** :
  - Installe Apache2 et configure un vhost sécurisé.
  - Active SSL, HSTS et certains modules Apache.
  - Installe PHP (version variable `$v`) et ses extensions les plus courantes.
  - Configure PHP en français avec un `php.ini` téléchargé (URL à définir).
  - Génère un certificat auto-signé.
>[!WARNING]
>Petite blague au niveau du vhost qui sera vierge après passage du script.

- **Nginx** :
  - Placeholder – à implémenter.
>[!CAUTION]
>Fonctionnalité non implémentée.

- **Certbot** :
  - Installe `snapd` et `certbot` via Snap pour la gestion des certificats SSL Let’s Encrypt.

#### Docker
- Désinstalle les paquets Docker précédents s’ils existent.
- Ajoute les dépôts officiels de Docker.
- Installe Docker, Docker Compose, et vérifie l'installation via `hello-world`.
>[!TIP]
>Ce bout de code fonctionne bien !



## 🧭 Interface Menu (via `dialog`)

Le script utilise la commande `dialog` pour afficher un **menu interactif en mode texte** permettant de choisir les options à exécuter :

- Menu principal :
  - `Standard` : Configuration système.
  - `Apps` : Choix des applications à installer.

Chaque catégorie propose un sous-menu avec des options activables individuellement.

>[!WARNING]
>Fonctionnalité comportant des bugs d'éxecution dû à des erreurs de syntaxes.



## 📌 Pré-requis

- Système Debian (Bookworm).
- Droits root.
- Connexion internet active (pour installer des paquets et télécharger des fichiers de configuration).
- Le paquet `dialog` (installé automatiquement).



## 🚧 Points à améliorer / TODO

- Ajouter la configuration complète de l'utilisateur standard.
- Implémenter la configuration Nginx.
- Remplacer les `url_fichier_conf` par de véritables liens vers les fichiers de configuration.
- Ajouter une vérification des erreurs d’exécution.
- Ajouter un système de logs plus robuste.
- Ajout de couche de sécurité plus complète (génération de clefs RSA...etc).


## 📄 Licence
>[!IMPORTANT]
>Ce script est à usage personnel / interne. Pensez à vérifier chaque commande avant usage en production.
>Non conforme à la commercialisation de cette solution ou de solution comprennant ou s'appuyant de près ou de loin sur cette solution.


## 🧠 Auteurs / Contributions

Rédigé et pensé pour automatiser les déploiements de Debian en utilisation "serveur".
