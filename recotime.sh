#!/bin/bash


#Colours

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

export DEBIAN_FRONTEND=noninteractive

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n\n${blueColour}[+]${endColour} ${yellowColour}Saliendo...${endColour}\n"
	tput cnorm; exit 0
}


#Panel de Ayuda

function help_panel(){

	echo -e "\n\t${greenColour}Do you need a help \(.-.)/ ?${endColour}\n"
	echo -e "${turquoiseColour}./recotime.sh -d [TARGET]${endColour}"


	exit 0
	
}

#Requeriments
function dependencies(){
	tput civis
	clear; dependencies=(subfinder whatweb wpscan)
	
	for programs in "${dependencies[@]}"; do
		echo -e "\n${blueColour}Checking${endColour} ${yellowColour}${programs}${endColour} ${blueColour}Tool${endColour}"
		test -f /usr/bin/$programs
		if [ "$(echo $?)" == "0" ]; then
			echo -e "${greenColour}Already :D${endColour}"

		else
			echo -e "${redColour}[X] Start to installing ${programs}...${endColour}"
			apt-get install $programs -y > /dev/null 2>&1
			
		fi; sleep 1

	done

}

#cleanup

function cleanup() {

	echo -e "\nsScript Stopped, Saving results.."
	echo "$(RecoTime)" > "${url_target}.txt"
	exit 0
}





#Recognizement step

function Recotime(){
	clear	
	echo -e "\n\t${purpleColour}It's RECO-TIMEE (*-*)${endColour}\n"
	echo -e "\t\t${greenColour}by${endcOLOUR} ${redColour}lazy29t${endColour}\n"
	echo -e "\n${purpleColour}[+]${endColour} ${greenColour}Starting with Reconnaissance${endColour}\n" 

	if [ ${url_target} ]; then
		 
		whatweb -v ${url_target} | grep -A 20 -e 'HTTP Headers' -e 'Summary' -e '200'| cut -c 1- 
		
		if whatweb -v "${url_target}" | grep "WordPress"; then
			echo -e "\n${purpleColour}[+]${endColour} ${turquoiseColour}The page has WordPress tecnology${endColour}" 
			read -p $'\e[1;36m Do you want start with wpscan?(y/n): \e[0m' answer 

			#In case we have a Wordpress WebPage:

			if [ "${answer}" = "y" ]; then
				echo -e "\t\n${yellowColour}[+]${endColour} ${turquoiseColour}Starting with Wpscan..."
				wpscan --url "${url_target}"  
				sleep 5
			fi
		fi

		sleep 2
		echo -e "\n${blueColour}[+]${endColour} ${yellowColour}Using waybackurls..${endColour}"
		python3 waybackurls.py ${url_target}
		sleep 5
		echo -e "\n${endColour}${purpleColour}[+]${endColour} ${yellowColour}Finding Subdomains...${endColour}\n"
		subfinder -d ${url_target} -silent
		sleep 2

	else
	
	echo "Ups.. try again \('-')/"
	fi

}



#Main menu

if [ "$(id -u)" == "0" ]; then
	declare -i parameter_counter=0; while getopts ":d:h:" arg; do
		case $arg in
			d)url_target=$OPTARG;let parameter_counter+=1;;
			h)help_panel;;
		esac
	done
else
	echo -e "${redColour}Non root (-_-)${endColour}"
fi




if [ $parameter_counter -ne 1 ]; then 
		help_panel
	else
		dependencies
		Recotime
		echo "$(Recotime)" > "$url_target.txt"
		tput cnorm
	fi



