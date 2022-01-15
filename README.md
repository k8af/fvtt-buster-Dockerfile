# Foundry VTT Docker container on Debian 10
Combining a secure and stable linux host system docker image with the latest Foundry VTT distribution.
----

## Howto use this files
1. Login to your target host and install docker and docker-compose.
2. Create your project directory
3. Change dir to project directory and download or clone github repo files.
4. Maybe change some system config details in your *Dockerfile* (Host ports 12345 i.e.)
5. Use docker command to build your first image with optionally tag on your host locally.
> #docker build -t localhost/fvtt-deb-vps
> #docker image ls (to list all images)
6. Run docker to create and login to your new image based container on port 12345 with name "foundryvtt-server"
> #docker run -d -p 12345:30000 --name foundryvtt-server localhost/fvtt-server

----

### Project Aims
The project aim is to provide a basic workflow for a reliable docker container to start FoundryVTT on Debian 10 (buster) based docker container. 

### Iterating workflow objects
| ID | Object | Description |
| - | - | - |
| 0 | Git Repository | create repository on github |
| 1 | Readme | Fill readme file with project details |
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


### Container Setup

#### Dockerfile for Installation
Every Container installation starts with a setup. You can start with commands on your terminal or create a Dockerfile for it. I choose the comfortable way to create a Dockerfile, putting all stuff in it and fire it up to run the deployment automatically.

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

