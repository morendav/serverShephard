#######################################
###     CodeBlock: Variables
#######################################
# Define script variables that were passed as new handles
outputFile=$1
curServ=$2
now=$(date)
# Init command variables
comm_Net_CA="netstat -nlptu"
comm_App_lsb="ls -l /proc/"
comm_App_lse="/exe"
comm_App_whatisb="whatis "
# Init Enviornment Specific variables
headerInd=(1 4 7) #### <--- RedHat deployment, header indices for comm_Net_CA command

#######################################
###     CodeBlock: Read ports and app info
#######################################
printf "### Server details herded from $curServ\r\n### On $(date)\r\n" > "$outputFile"
printf "localAddress, portNumber, protocol, boundApp, appExeDirectory, appDescription\r\n"  >> "$outputFile"
$comm_Net_CA | grep 'LISTEN' | while read -r line; do #### <--- for CA
  substring[0]=$(echo $line | cut -d ' ' -f${headerInd[0]})       #header ind 0 = 1, meaning take the Protocol
  substring[1]=$(echo $line | cut -d ' ' -f${headerInd[1]})       #header ind 1, meaning take the Local IP
  substring[2]=$(echo $line | cut -d ' ' -f${headerInd[2]})       #header ind 2, meaning take the PID

  ### Set Port variable
  #count number of periods in the Local IP Address, find Port number
  ind=$(awk -F"." '{print NF-1}' <<< "${substring[1]}"); let "ind=ind+1"          #Indice = number of periods + 1, periods are delimiter

  #### Port is delimited by : on CA, is just last ind . on local
  port=$(echo ${substring[1]} | cut -d ":" -f2)                    ####<---- CA

  ### Set PID variable
  pid=$(echo ${substring[2]} | cut -d "/" -f1)       ####<----- CA Servers

  ### Feed pid number to command for app name
  comm[0]=$(printf "$comm_App_lsb$pid$comm_App_lse")             #Define the command variable set, comm 0 = ls -l /prod/<PID>/exe
  appExeDir=$(${comm[0]} | cut -d '/' -f2- | cut -d ">" -f2)
  ind1=$(awk -F"/" '{print NF}' <<< $appExeDir)
  appname=$(echo $appExeDir | cut -d "/" -f$ind1)
  comm[1]=$(printf "$comm_App_whatisb$appname")

  ### If whatis provides no new context, report ps -ef as application details
  if [[ $(( ${comm[1]} 3>&1 1>&2- 2>&3- ) | cut -d ":" -f2) == *nothing*appropriate* ]]  ####<--- CA
  then
    desc=$(ps -ef | grep $pid | grep -v 'grep' | head -n 1)
  else
    desc=$(${comm[1]} | head -n 1)
  fi

  ### Write output File
  # in Format: "localAddress, portNumber, protocol, boundApp, appExeDirectory, appDescription\r\n"
  printf "${substring[1]}, $port, ${substring[0]}, $appname, $appExeDir, $desc\r\n"  >> "$outputFile"
done
