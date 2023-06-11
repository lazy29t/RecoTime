#!/bin/bash

# Colours
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

function ctrl_c() {
    echo -e "\n\n${blueColour}[+]${endColour} ${yellowColour}Exiting...${endColour}\n"
    tput cnorm
    exit 0
}

# Help Panel
function help_panel() {
    echo -e "\n\t${greenColour}Do you need a help? (.-.)/ ?${endColour}\n"
    echo -e "${turquoiseColour}./recotime.sh -d [DOMAIN]${endColour}"
    exit 0
}

# Requeriments
function dependencies() {
    tput civis
    clear
    dependencies=("subfinder" "whatweb" "wpscan")

    for program in "${dependencies[@]}"; do
        echo -e "\n${blueColour}Checking${endColour} ${yellowColour}${program}${endColour} ${blueColour}Tool${endColour}"
        if ! command -v "$program" &>/dev/null; then
            echo -e "${redColour}[X] Start to installing ${program}...${endColour}"
            apt-get install "$program" -y > /dev/null 2>&1
        else
            echo -e "${greenColour}Already :D${endColour}"
        fi
        sleep 1
    done
}

# Recognizement step
function Recotime() {
    clear
    echo -e "\n\t${purpleColour}¡It's RECO-TIMEE ~(*-*)~!${endColour}\n"
    echo -e "\t\t${greenColour}por${endColour} ${redColour}lazy29t${endColour}\n"
    echo -e "\n${purpleColour}[+]${endColour} ${greenColour}Starting with Reconnaissance${endColour}\n"

    if [ -n "$url_target" ]; then
        whatweb -v "$url_target" | grep -A 20 -e 'HTTP Headers' -e 'Summary' -e '200' | cut -c 1-
        
        if whatweb -v "$url_target" | grep -q "WordPress"; then
            echo -e "\n${purpleColour}[+]${endColour} ${turquoiseColour}The page has WordPress tecnology${endColour}"
            read -rp $'\e[1;36m Do you want start with wpscan? (y/n): \e[0m' answer

            # In case the web page has WordPress:
            if [ "$answer" = "y" ]; then
                echo -e "\t\n${yellowColour}[+]${endColour} ${turquoiseColour}Starting with Wpscan..."
                wpscan --url "$url_target" -e vp,u
                sleep 2
            elif [ "$answer" = "n" ]; then
                echo -e "\t\n${yellowColour}[-] Skip...${endColour}\n"
            else
                echo -e "\t\n${yellowColour}[X]${endColour} ${redColour}Invalid Option...${endColour}"
            fi
        fi

        sleep 2
        echo -e "\n${blueColour}[+]${endColour} ${yellowColour}Using waybackurls...${endColour}"
        python3 waybackurls.py "$url_target"
        sleep 5
        echo -e "\n${endColour}${purpleColour}[+]${endColour} ${yellowColour}Finding Subdomains...${endColour}\n"
        subfinder -d "$url_target" -silent
        sleep 2

    else
        echo "¡Ups! try again \('-')/"
    fi
    exit 0
}

# Main
if [ "$(id -u)" = "0" ]; then
    declare -i parameter_counter=0
    while getopts ":d:h:" arg; do
        case $arg in
            d)
                url_target=$OPTARG
                let parameter_counter+=1
                ;;
            h)
                help_panel
                ;;
        esac
    done
else
    echo -e "${redColour}Non root (-_-)${endColour}"
fi

if [ "$parameter_counter" -ne 1 ]; then
    help_panel
else
    dependencies
    Recotime  		
    tput cnorm

fi | tee -a "${url_target}.txt"

tput cnorm
