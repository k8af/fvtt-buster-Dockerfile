#!/bin/bash

##################################################
#             Container Manager v1.0             #
# ---------------------------------------------- #
#                 2022, by k8af                  #
#          Read more about it on github          #
# https://github.com/k8af/fvtt-buster-Dockerfile #
#                                                #
##################################################

# 1st of all clear the screen
clear

echo "Starting Docker Container Manager."
echo "2022 - Version 1.0"
echo "by k8af"
echo " "

# creating a menu with the following options
echo "SELECT YOUR NEXT STEPS";
echo " "
echo "1 - Run Docker Container in Detach Mode"
echo "2 - Start the Container"
echo "3 - Stop the Container"
echo "4 - Login to Container"
echo "5 - exit programm"

# Running a forever loop using while statement
# This loop will run untill select the exit option.
# User will be asked to select option again and again
while :
do
# reading choice
read choice

# case statement is used to compare one value with the multiple cases.
case $choice in
  1)  echo "You have selected the option 1"
      echo "...Running Container in detach mode, waiting to start."
        docker run -it -d -h fvtt --volume=/opt/fvtt/xfer:/srv/foundry/xfer --publish 12345:30000/tcp --name foundryvtt-server fvtt-deb10-slim /bin/bash -l
        ;;
  2)  echo "You have selected the option 2"
      echo "...Container is starting now."
        docker container start foundryvtt-server
      ;;

  3)  echo "You have selected the option 3"
      echo "Stopping Container... "
        docker container stop foundryvtt-server
      ;;
  4)  echo "You have selected the option 4"
      echo "Connect via login shell..."
        docker exec -it foundryvtt-server /bin/bash 
      ;;
  5)  echo "Quitting ..."
      exit
      ;;

# Default Pattern
  *) echo "invalid option"
    echo " "
    ;;
esac
echo -n "Enter your menu choice [1-5]: "
done
