# Foundry VTT Docker container on Debian 10
## Intro - What we have here ? 
We will build a secure linux debian based docker container for a Foundry VTT environment.
Foundry VTT is my favourite virtual tabletop system to play online with friends.
Debian is my favourite linux distribution, so I combined my favs to gain a service solution.

----

## Project Aims
The project aim is to provide a Dockerfile to build your own debian 10 docker image and to start a container for FoundryVTT. 

## Iterating workflow objects
| ID | Object | Description |
| - | - | - |
| 0 | Git Repository | create repository on github |
| 1 | Readme | Fill readme file with operating details |
| 2 | Dockerfile - Linux | assemble basic Dockerfile for debian 10 (buster) |
| 3 | Dockerfile - NodeJs | evaluate methods to automate deployment of latest NodeJs version |
| 4 | Dockerfile - FoundryVTT | prepare server environment of Foundry Virtual Tabletop server |
| 5 | Testing - Deployment | Get Foundry Virtual Tabletop license|
| 6 | Testing - Application | Get FVTT server instance up and running as Debian 10 (slim) Container |
| 7 | Have fun with FVTT and friends | Invite friends and provide access keys to connect to your server.|
| 8 | SSL/TLS Security | Take a note to connect with TLS certificates using certbot |

----

## Prerequisites
All you need to start is:
- Dockerfile experience
- debian linux experience
- debian 10 (slim) for the docker image
- NodeJS 14.x or newer for the docker image
- Foundry VTT account with a purchased software license
- the official [Foundry VTT](https://foundryvtt.com) distribution
- Some TCP/IP networking and firewalling experience

----
## Roadmap for Preperations for hosting system
* Login to your target linux vps host and become root (# symbol)
* Do some preperations on hosting machine
* Install docker and docker-ce.
* Download Dockerfile
* Create docker image
* Run docker container
* Start docker container
* Login to your created container and start Foundry VTT as user foundry
* Check some firewall rules

---

## Preperations for hosting system (vps)

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

### Install docker on hosting machine
You need to do some steps before you can install docker-ce.
> #apt update
> 
> #apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common
> 
> #curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
> 
> #add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
> 
> #apt update
> 
> #apt-cache policy docker-ce
> 
> #apt install docker-ce

### Check that docker daemon is running
> #systemctl status docker
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

#### Now let's create the docker image
Create your image within the directory where the Dockerfile exists and send any docker output to default output and pipe it to file "build.log"
It tooks several minutes to download all parts from internet.
> #docker build -t fvtt-deb10-slim . 1>> build.log
> 

#### Run the first container
Considering the docker volumes specification, we will share a directory on the hosting machine within our new container.
If all is fine now, run an interactive container in detach mode, with exchange volumes and with hostname "fvtt" from the image we've created above
> #docker run -it -d -h fvtt --volume=/opt/fvtt/xfer:/srv/foundry/xfer --publish 12345:30000/tcp --name foundryvtt-server fvtt-deb10-slim /bin/bash -l
> 

#### Start container
> #docker container start foundryvtt-server
> 

#### Monitoring Docker Container Status
After you run the container you can have a look at the stats with the following command:
> docker container stats
> 

#### Connect with container as terminal session in a bash shell
> #docker exec -it foundryvtt-server /bin/bash
> 

#### Change User
Change to User foundry
> #su - foundry
> 

#### Change to home of user foundry
> #cd /srv/foundry
> 

#### Start Foundry VTT 
> #node /srv/foundry/fvtt/resources/app/main.js --dataPath=/srv/foundry/data 1>>access.log 2>>error.log &
> 

#### Port Forwarding
Foundry VTT Server is listening on Port 30000 (default), my container will redirect it to my hosting port 12345.
At this point it depends on your firewall configurations to open your container port to public access.

Take a minute to think about your port forwardings.

´´´
Foundry-VTT (30000) --> local vps host container (12345)
local vps host container (12345) --> VPS Provider Firewall --> Public Access

´´´

#### SSL/TLS Security
If you want to use tls security on your vps machine, I recommend to use [certbot](https://certbot.eff.org/instructions?ws=other&os=debianbuster).
Follow the instructions to install and run certbot on your vps hosting machine without a webserver.

---

### Maintaining the project
Feel free to download my docker file and improve the container performance or implement new security features.
Use the files to test, run and improve your Foundry VTT instance for a better virtual tabletop experience.
* Please comment or send me a feedback via git email.
* next devop stage is to use ansible playbook


----

## Sources
### Foundry VTT Wiki
- If you are new to foundry's VTT - virtual Tabletop check: [Foundry Virtual Tabletop](https://foundryvtt.com/)
- Here you can find more about the the latest [Foundry VTT Release](https://foundryvtt.com/releases/9.238)
- If you know Foundry VTT but you don't know hosting with docker visit: [Hosting with Docker](https://foundryvtt.wiki/en/setup/hosting/Docker)

### Foundry VTT Community
- A good start to read more about the Foundry VTT installation is the official [Installation Guide](https://foundryvtt.com/article/installation/)
- You can find more stuff about the Foundry VTT System if you visit the [official wiki](https://foundryvtt.wiki/en/home).
- Last but not least learn to play rpgs on Foundry's Virtual Table Top join the Foundry VTT community [on discord](https://discord.gg/foundryvtt)

