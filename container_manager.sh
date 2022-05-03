#!/bin/bash

clear
echo "
##################################################
#             Welcome to SDCM                    #
#       Simple Docker Container Manager          #
#               version 1.5                      #
# ---------------------------------------------- #
#                 2022, by k8af                  #
#          Read more about it on github          #
# https://github.com/k8af/fvtt-buster-Dockerfile #
#                                                #
##################################################
"
menue_items () {
# creating a menu with the following options
 echo "MAIN MENUE ";
 echo " "
 echo "1 - Manage Foundry VTT Server"
 echo "2 - Manage Reverse Proxy Server"
 echo "3 - Delete all stopped Container."
 echo "0 - exit programm"
 echo ""
}
sub_menue_items () {
# creating a menu with the following options
 echo "... NEXT STEPS";
 echo " "
 echo "1 - Run and start the container in detach mode with network fvtt-net."
 echo "2 - Start the container"
 echo "3 - Stop the container"
 echo "4 - Login to container"
 echo "0 - exit programm"
 echo ""
}
echo " "
menue_items
# Running a forever loop using while statement
# This loop will run untill select the exit option.
# User will be asked to select option again and again
while :
do
# reading choice
read choice

case $choice in
        1)  echo -n "Foundry VTT Container Manager."
            sub_menue_items
            echo -n "Enter your menu choice [0 - 4]: "
            read choice2
            case $choice2 in
                1)  echo "You have selected the option 1"
                    echo "Running and starting FVTT Container WITHOUT TLS."
                    #docker run -itd -h fvtt --volume=/opt/fvtt/xfer:/srv/foundry/xfer --publish 12345:30000/tcp --name foundryvtt-server --network fvtt-net fvtt-deb10-slim
                    docker run -itd -h fvtt --ip=172.23.3.2 --volume=/opt/fvtt/xfer:/srv/foundry/xfer --name foundryvtt-server --network=fvtt-net --add-host=fvtt:172.23.3.2 --add-host=rproxy:172.23.3.1 fvtt-deb10-slim
                    ;;
                2)  echo "You have selected the option 2"
                    echo "Just starting the FVTT Container."
                      docker container start foundryvtt-server
                    ;;
              
                3)  echo "You have selected the option 3"
                    echo "Now stopping the FVTT Container... "
                      docker container stop foundryvtt-server
                    ;;
                4)  echo "You have selected the option 4"
                    echo "Connecting to FVTT Container via login shell..."
                      docker exec -it foundryvtt-server /bin/bash 
										;;
                0)  echo "Going back to main menue ..."
                    sleep 1
                        clear
                    ;;
                *)  echo "invalid option"
                    sleep 1
                        clear
                    ;;
            esac
            ;;
        2)  echo -n "Reverse Proxy Container Manager."
            sub_menue_items
            echo -n "Enter your menu choice [0 - 4]: "
            read choice2
            case $choice2 in
                1)  echo "You have selected the option 1"
                    echo "Running and starting Reverse Proxy Container WITHOUT TLS/SSL on Port 10250."
                    docker run -itd -h rproxy -p 10250:80 --ip=172.23.3.1 --add-host=rproxy:172.23.3.1 --add-host=fvtt:172.23.3.2 --name=foundryvtt-reverse-proxy --network fvtt-net fvtt-rproxy-deb10-slim
                    ;;
                2)  echo "You have selected the option 2"
                    echo "Just starting the Reverse Proxy Container."
                      docker container start foundryvtt-reverse-proxy
                    ;;
              
                3)  echo "You have selected the option 3"
                    echo "Stopping the Reverse Proxy Container. "
                      docker container stop foundryvtt-reverse-proxy
                    ;;
                4)  echo "You have selected the option 4"
                    echo "Connecting Reverse Proxy Container via login shell..."
                      docker exec -it foundryvtt-reverse-proxy /bin/bash 
										;;
                0)  echo "Going back to main menue ..."
                    sleep 1
                    	clear
                    ;;
                *)  echo "invalid option"
                    sleep 1
                      clear
                    ;;
            esac
            ;;

				3)  echo " "
            echo "Delete all stopped containers."
				    echo "Are you sure ?"
				    echo " "
				    echo "1 - Yes - Delete all my stopped docker containers."
				    echo "2 - No - Exit to main menue."
            echo " "
            echo "Enter your menu choice [1 - 2]: "
				    read stopdel
						case $stopdel in
							
				       	1)	echo "...deleting all stopped Container now!"
				            sleep 3
				             echo -n "WARNING - All stopped containers will be pruned."
				             docker container prune
				             sleep 2
				             		clear
				             ;;
				        2)	echo "OK, leaving ... "
				            sleep 2
				            clear
				            ;;
				        *)	echo "invalid option"
				            sleep 2
				            clear
				            ;;
				    esac
				    ;;

				0)  echo "Quitting ..."
						exit
      			;;

				# Default Pattern
  			*) 	echo "invalid option"
    				echo " "
    				;;
esac

menue_items

echo -n "Enter your menu choice [0 - 3]: "
done

