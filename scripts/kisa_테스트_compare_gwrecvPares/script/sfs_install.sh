#!/bin/bash

SFS_SERVICE_USER=sfs
ID=`whoami`

out_line="\e\033[32m========================================================================================\033[0m"

echo -e $out_line
echo -e "\e\033[32m    PKG Install Script\033[0m"
echo -e $out_line


if [[ "$ID" == $SFS_SERVICE_USER ]]
CURRENT_VERSION=`ls -al ~/app | awk '{print $11}'`
then
	CURRENT_VERSION=${CURRENT_VERSION##/*/}			  
	echo "Current SFS Release Version : ${CURRENT_VERSION##/*/}" 
	echo "Please Enter SFS Install Version : "
	read INSTALL_VERSION

	INSTALL_PKG="/home/$SFS_SERVICE_USER/$INSTALL_VERSION"
	CURRENT_PKG="/home/$SFS_SERVICE_USER/$CURRENT_VERSION"
	INSTALL_FILE="/home/$SFS_SERVICE_USER/pkg/$INSTALL_VERSION"


	if [ $CURRENT_VERSION == $INSTALL_VERSION ]
	then

		echo -e "\033[1;31m    Invalid PKG Version\033[0m"
		echo -e "\033[1;31m    Install FAIL\033[0m"

		exit
	fi


	if [ -e $INSTALL_PKG ]; then
	
		echo -e $out_line
		echo "Already PKG exist : $INSTALL_VERSION"

    	echo -e $out_line
    	echo -e "Do You wish to \033[1;31mINSTALL\033[0m SFS[$CURRENT_VERSION->\033[1;32m$INSTALL_VERSION\033[0m] ?"
    	select yn in "Yes" "No"; do
    	case $yn in

        	Yes ) break;;

        	No ) echo -e "\033[1;31m    Install FAIL\033[0m"
            exit;;

    	esac
    	done

		echo -e $out_line
		echo -e "Do You wish to \033[1;31mSTOP\033[0m SFS Servcie ?"
		select yn in "Yes" "No"; do
    	case $yn in
		Yes ) /home/sfs/app/bin/sfsd stop
		  	break;;

		No ) echo -e "\033[1;31m    Install FAIL\033[0m"
			exit;;
		esac
		done


		\rm /home/$SFS_SERVICE_USER/app
		ln -s /home/$SFS_SERVICE_USER/$INSTALL_VERSION /home/$SFS_SERVICE_USER/app

		echo -e $out_line
		echo -e "\033[1;32m    PKG Install Success\033[0m"
		echo -e $out_line

		echo -e "Do You wish to \033[1;31mSTART\033[0m SFS Servcie ?"
	
		select yn in "Yes" "No"; do
    	case $yn in
		Yes ) /home/sfs/app/bin/sfsd start
		  	break;;

		No ) echo -e "\033[1;31m    Install FAIL\033[0m"
			exit;;
		esac
		done
	
		/home/sfs/app/bin/sfsd status
		
		exit
	fi 

	if [ -e $INSTALL_FILE ]; then

		echo -e "Install PKG Directory : \033[1;32m$INSTALL_FILE\033[0m"

	else

 		echo -e "\033[1;31m    PKG does not exist\033[0m"
 		echo -e "\033[1;31m    Install FAIL\033[0m"
		exit

	fi


    echo -e "Do You wish to \033[1;31mINSTALL\033[0m SFS[$CURRENT_VERSION->\033[1;32m$INSTALL_VERSION\033[0m] ?"
	echo -e $out_line
	select yn in "Yes" "No"; do
    case $yn in

        Yes ) break;;

        No ) echo -e "\033[1;31m    Install FAIL\033[0m"
			exit;;

    esac
	done

	echo -e $out_line
	echo -e "Do You wish to \033[1;31mSTOP\033[0m SFS Servcie ?"

	echo -e $out_line
	select yn in "Yes" "No"; do
    case $yn in
		Yes ) /home/sfs/app/bin/sfsd stop
		  	break;;

		No ) echo -e "\033[1;31m    Install FAIL\033[0m"
			exit;;
		esac
	done

	if [ -e $INSTALL_FILE ]; then
		cp -rP $CURRENT_PKG $INSTALL_PKG
		cp $INSTALL_FILE/bin/* $INSTALL_PKG/bin
		\rm /home/$SFS_SERVICE_USER/app
		ln -s /home/$SFS_SERVICE_USER/$INSTALL_VERSION /home/$SFS_SERVICE_USER/app


		echo -e $out_line
		echo -e "\033[1;32m    PKG Install Success\033[0m"
		echo -e $out_line

	
		echo -e "Do You wish to \033[1;31mSTART\033[0m SFS Servcie ?"
		select yn in "Yes" "No"; do

		echo -e $out_line
    	case $yn in
			Yes ) /home/sfs/app/bin/sfsd start
		 	 break;;

			No )  echo -e "\033[1;31m    Install FAIL\033[0m"
			exit;;
		esac
		done
	fi

			
 else
	echo -e "\033[1;31m    Please $SFS_SERVICE_USER login\033[0m"
 	echo -e "\033[1;31m    Install FAIL\033[0m"
fi
