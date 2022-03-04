# Foundry VTT Docker container image on Debian 10
## Intro - What we have here ? 
We will build a secure linux debian based docker container image for a Foundry VTT environment.
Foundry VTT is my favourite virtual tabletop system to play online with friends.
Debian is my favourite linux distribution, so I combined my favs to create my online service solution.

----

## Project Aims
The project aim is to provide a Dockerfile to build your own debian 10 docker container image and to start a container for FoundryVTT. 

## Iterating workflow objects
| ID | Object | Description |
| - | - | - |
| 0 | Git Repository | create repository on github |
| 1 | Readme | Fill readme file with operating details |
| 2 | Dockerfile - Linux | assemble basic Dockerfile for debian 10 (buster) |
| 3 | Dockerfile - NodeJs | evaluate methods to automate deployment of latest NodeJs version |
| 4 | Dockerfile - FoundryVTT | prepare server environment of Foundry Virtual Tabletop server |
| 5 | Testing - Deployment | Get Foundry Virtual Tabletop license|
| 6 | Testing - Application | Get FVTT up and running as Docker Container |
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
* Run docker container in detached. volumes and ports
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

---

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

---

### Check that docker daemon is running
> #systemctl status docker
> 

### Install some usefull tools
Install some packages if you need more, add some more tools.
We don't need to install any manpages on the vps.
> #apt install apt-transport-https ca-certificates curl software-properties-common
> 
> #apt update && apt upgrade
> 
> #apt install apt-file iproute2 inetutils-ping dns-utils free atop tree net-tools ufw
> 

---
## Environmental Preperations
### Project directory 
Create your project directory on the host machine (/opt/fvtt)
> #mkdir /opt/fvtt
> 

### Docker Volume - file exchange for our container updates
Create your project folder on host machine to work with docker volume and provide files to sync between them (/srv/foundry/xfer)
> #mkdir /opt/fvtt/xfer
> 

### Create user foundry with unlimited elapse time (Dockerfile)
> #useradd -K PASS_MAX_DAYS=-1 foundry
> 

### Create group fvtt
> #groupadd fvtt
> 

### Add user foundry to group fvtt
> usermod -a -G fvtt foundry
> 

### Recursively change owner with permissions of our project folder
> #chown -R foundry:fvtt /opt/fvtt/
> 

## Foundry VTT App and Data Update Workflow 
### Syncronize foundry vtt files to our host machine
I've downloaded fvtt files outside my linux host and created a read only shared folder for my virtual box machine (also debian 10).
My source folder was "/WinShared/Linux\ Server/FoundryVTT-9-2/" and my target /opt/fvtt/xfer.
Logged into my virtual machine I've used rsync to syncronize my fvtt files to "/opt/fvtt/xfer" with update options, permissions safed on my host machine. (Change folders if you need)

* Find some examples of rsync options at [geeksforgeeks](https://www.geeksforgeeks.org/rsync-command-in-linux-with-examples/)

> #rsync -h --progress --stats -r -tgo -p -l -S --update /WinShared/Linux\ Server/FoundryVTT-9-2/ /opt/fvtt/xfer ; 
> 

### Recursively change Permissions
> find '/opt/fvtt/xfer/' -perm -2  -type f  -exec chmod o-w {} \; ;chmod 760 /opt/fvtt/xfer/ ;
> 

----

### Dockerfile Image & Container Setup

#### Download Dockerfile
* Change to project directory and download or clone my files from github [repository files](https://github.com/k8af/fvtt-buster-Dockerfile).
* Change some system config details in the *Dockerfile* as you wish (hostnames, ports i.e.)
* Docker container is listening on port 12345 (use any Port)
* We share container volume "/srv/foundry/xfer" with our host folder "/opt/fvtt/xfer"

> wget https://github.com/k8af/fvtt-buster-Dockerfile/edit/main/Dockerfile
> 

#### Now let's create the docker image
* We create the docker image within the directory where the *Dockerfile* exists 
* Send any docker output to standard output it into a file called "build.log"
* It tooks several minutes to download all parts from internet. (depends on your inet connection)

> #docker build -t fvtt-deb10-slim . 1> build.log
> 

#### Run or start a container in the background
Considering the docker volumes specification, we will share our "/opt/fvtt/xfer/" directory with our new container volume "/srv/foundry/xfer".
If all is fine now, run an interactive container in detach mode, with volumes and with hostname "fvtt" from the image we've created above
> #docker run -itd -h fvtt --volume=/opt/fvtt/xfer:/srv/foundry/xfer --publish 12345:30000/tcp --name foundryvtt-server fvtt-deb10-slim
> 

#### Start container manually
> #docker container start foundryvtt-server
> 

#### Stop container
> #docker container stop foundryvtt-server
> 

#### Monitoring Docker Container Status
After you run the container, have a look at the container stats of your host in a seperate terminal with the following command:
> docker container stats
> 

#### Connect with container as terminal session in a bash shell
> #docker exec -it foundryvtt-server /bin/bash
> 

#### Change User
Change to User foundry
> #su - foundry
> 

#### Start Foundry VTT 
Start Foundry VTT with logfile options in background
> #node /srv/foundry/fvtt/resources/app/main.js --dataPath=/srv/foundry/data 1>>log/access.log 2>>log/error.log &
> 

----

Hint: You also can try out my simple shell script "container_manager.sh" to run, start, stop and login to your container.

----

### Simple Firewall Rules
We use to open just that ports on our host machine if you need more you can change the commands below
```
sudo ufw allow 22
sudo ufw allow 12345
sudo ufw allow 443
sudo ufw enable
```
----

#### Port Forwarding
Foundry VTT Server is listening on Port 30000 by default, my container will redirect it to my hosting port 12345.
At this point it depends on your firewall configurations to open your container port to public access.

Take a minute to think about your port forwardings.

> Foundry-VTT (30000) <--> Container Port (12345) <--> VPS Provider Firewall Forwarding <--> Public Access
> 

#### SSL/TLS Security
If you want to use SSL/TLS security on your vps machine, I recommend to use [certbot](https://certbot.eff.org/instructions?ws=other&os=debianbuster).
Follow the instructions to install and run certbot on your vps hosting machine without a webserver.

----

### Maintaining the project
Feel free to download my docker file and improve the container performance or implement new security features.
Use the files to test, run and improve your Foundry VTT instance for a better virtual tabletop experience.
* Please comment or send me a feedback on my git account.
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

