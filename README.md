# Foundry VTT Docker container on Debian 10
Combining a secure and stable linux host system docker image with the latest Foundry VTT distribution.
----

### Project Aims
The project aim is to provide a basic workflow for a reliable docker container to start FoundryVTT on Debian 10 (buster) based docker container. 

### Iterating workflow objects
| ID | Object | Description |
| - | - | - |
| 0 | Git Repository | create repository on github |
| 1 | Readme | Fill readme file with operating details |
| 2 | Dockerfile - Linux | assemble basic Dockerfile for debian 10 (buster) |
| 3 | Dockerfile - NodeJs | evaluate methods to automate deployment of latest NodeJs version |
| 4 | Dockerfile - FoundryVTT | prepare server environment of Foundry Virtual Tabletop server |
| 5 | Testing Deployment | Get Foundry Virtual Tabletop license|
| 6 | Testing Application | Get FVTT server instance up and running as Debian 10 (buster) Container |
| 7 | Have fun with FVTT and friends | Invite friends and provide access keys to connect to your server.|

----

### Prerequisites
All you need to start is:
- debian linux 10 (buster) as basic docker image
- NodeJS 14.x or newer for the docker image
- Foundry VTT account with a purchased software license
- the official [Foundry VTT](https://foundryvtt.com) distribution
- Some TCP/IP networking and firewalling experience

----
## Roadmap for Preperations for hosting system
* Login to your target linux vps and become root
* Do some preperations
* Install docker and docker-compose.
* Create docker image
* Run docker container
* Login to your created container and start Foundry VTT

### Adding repos to hosting server
If you need more software on your hosting system, add some more sources to your /etc/apt/sources.list

> #echo 'deb http://httpredir.debian.org/debian buster main non-free contrib' >> /etc/apt/sources.list
> 
> #echo 'deb-src http://httpredir.debian.org/debian buster main non-free contrib' >> /etc/apt/sources.list
> 
> #echo 'deb http://security.debian.org/debian-security buster/updates main contrib non-free' >> /etc/apt/sources.list
> 
> #echo 'deb-src http://security.debian.org/debian-security buster/updates main contrib non-free' >> /etc/apt/sources.list
> 

### Install some tools
Install some packages if you need more, add some more tools.
> #apt install apt-transport-https ca-certificates curl software-properties-common
> 
> #apt update && apt upgrade
> 
> #apt install docker-ce docker-ce-cli apt-file
> 
> #apt install iproute2 inetutils-ping dns-utils iptables free man
> 

### Project directory
Create your project directory on the host machine (/opt/fvtt)
> #mkdir /opt/fvtt
> 

### Docker Volumes & file exchange
Create your docker mount point as volume transfer directory as you wish (/opt/fvtt/xfer)
> #mkdir /opt/fvtt/xfer
> 

### Syncronize foundry vtt files to host machine
I've downloaded fvtt files outside my linux host system and created an read only shared folder for my virtual machine.
So actually my source folder is "/WinShared/Linux\ Server/FoundryVTT-9-2/" and my target /opt/fvtt/xfer.
I've used rsync to syncronize as update while safing all origin permissions to my "/opt/fvtt/xfer" transfer directory on my host machine.

> #rsync -h --progress --stats -r -tgo -p -l -D -S --update /WinShared/Linux\ Server/FoundryVTT-9-2/ /opt/fvtt/xfer ; chown -R foundry. /opt/fvtt/xfer/ ; find '/opt/fvtt/xfer/' -perm -2  -type f  -exec chmod o-w {} \; ;chmod 760 /opt/fvtt/xfer/ ; ls -rtla /opt/fvtt/xfer/


----
### Firewall Rules
We use to open just that ports on our host machine if you need more you can change the commands below
```
sudo ufw allow 22
sudo ufw allow 12345
sudo ufw allow 443
sudo ufw enable
```
----



### Container Setup

#### Download Dockerfile
* Change to your project directory and download or clone from github [repository files](https://github.com/k8af/fvtt-buster-Dockerfile).
* Change some system config details in your *Dockerfile* (Host port i.e.)
* Docker container is listening on port 12345  (use any other Port here)
* with shared data volume directory inside the container "/srv/foundry/xfer"

#### Dockerfile for Installation
Every Container installation starts with a setup. You can start with commands on your terminal or like me I've created a Dockerfile for it, putting all stuff in it and fire it up to run the deployment automatically.

#### Monitoring Docker Container Status
After you run the container you can have a look at the stats with the following command:
> docker container stats
> 

#### Now let's create the docker image
Create your image within the directory where the Dockerfile exists and send any docker output to default output and pipe it to file "build.log"
It tooks several minutes to download all parts from internet.
> #docker build -t fvtt-deb10-slim . 1>> build.log
> 

#### Run the first container
If all is fine now, run an interactive container in detach mode, with hostname "fvtt" from the image we've created above
> #docker run -it -d -h fvtt --volume=/opt/fvtt/xfer:/srv/foundry/xfer --publish 12345:30000/tcp --name foundryvtt-server fvtt-deb10-slim /bin/bash -l
> 

#### Start container
> #docker container start foundryvtt-server
> 

#### Connect with container as terminal session in a bash shell
> #docker exec -it fvtt-slim /bin/bash
> 


### Login your container

Change to User foundry
> #su - foundry
> 

Change to home of user foundry
> #cd /srv/foundry
> 

Foundry VTT Server is listening on Port 30000 (default), my container will redirect it to port 12345.
Anyways 
> #node /srv/foundry/fvtt/resources/app/main.js --dataPath=/srv/foundry/data 1>access.log 2>error.lo &




#### Linux Debian 10 (buster)
First of all ask yourself if you have enough linux practice experience to create Docker Container deployment for linux debian 10 (buster)

### Maintaining the project
Feel free to download docker files and improve the container performance or implement new security features.
Please comment or send me a feedback via git email.

Use the files to test, run and improve your Foundry VTT instance for a better virtual tabletop experience.

----

## Sources
### foundry vtt wiki
- If you are new to foundry's virtual multiplayer tabletop check: [Foundry Virtual Tabletop](https://foundryvtt.com/)
- Here you can find more about the the latest [Foundry VTT Release](https://foundryvtt.com/releases/9.238)
- If you know Foundry VTT but you don't know hosting with docker visit: [Hosting with Docker](https://foundryvtt.wiki/en/setup/hosting/Docker)

### Foundry VTT Community
- A good start to read more about the Foundry VTT installation is the official [Installation Guide](https://foundryvtt.com/article/installation/)
- You can find more stuff about the Foundry VTT System if you visit the [official wiki](https://foundryvtt.wiki/en/home).
- Last but not least learn to play rpgs on Foundry's Virtual Table Top join the Foundry VTT community [on discord](https://discord.gg/foundryvtt)

