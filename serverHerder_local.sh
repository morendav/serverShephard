### Define function variables from passed variables
outputFile=$1

echo $outputFile

# OS/Env Specific variables
comm_Net_OSX="netstat -anvp tcp"
comm_Net_CA="netstat -nlptu"
comm_App_lsb="ls -l /proc/"
comm_App_lse="/exe"
comm_App_whatisb="whatis "
comm_App_psb="ps -ef | grep ' "
comm_App_pse=" ' | grep -v 'grep'"
headerInd=(1 4 8) #### <--- local
#headerInd=(1 4 7) #### <--- CA
it=0
printf "localAddress, portNumber, protocol, boundApp, appDescription;\r\n"  > "$outputFile"

$comm_Net_OSX | grep 'ESTABLISHED' | while read -r line; do #### <--- for Local
#$comm_Net_CA | grep 'LISTEN' |while read -r line; do #### <--- for CA
  substring[0]=$(echo $line | cut -d ' ' -f${headerInd[0]})       #header ind 0 = 1, meaning take the Protocol
  substring[1]=$(echo $line | cut -d ' ' -f${headerInd[1]})       #header ind 1, meaning take the Local IP
  substring[2]=$(echo $line | cut -d ' ' -f${headerInd[2]})       #header ind 2, meaning take the PID

  ### Set Port variable
  #count number of periods in the Local IP Address, find Port number
  ind=$(awk -F"." '{print NF-1}' <<< "${substring[1]}"); let "ind=ind+1"          #Indice = number of periods + 1, periods are delimiter

  #### Port is delimited by : on CA, is just last ind . on local
  port=$(echo ${substring[1]} | cut -d "." -f$ind)                #set local port = last substring delimited by period
  #port=$(echo ${substring[1]} | cut -d ":" -f2)

  ### Set PID variable
  #### DEVSPEC Enviornment Specific
  pid=$(echo ${substring[2]} )                                  ####<---- local machine
  #pid=$(echo ${substring[2]} | cut -d "/" -f1)       ####<----- CA Servers

  ### Feed pid number to command for app name
  # comm[0]=$(printf "$comm_App_lsb$pid$comm_App_lse")             #Define the command variable set, comm 0 = ls -l /prod/<PID>/exe
  # ind2=$(awk -F" " '{print NF-1}' <<< $(${comm[0]})); let "ind2=ind2+1" #delimited output by space, find app name as being last field
  # app=$(${comm[0]} | cut -d " " -f$ind2)                          #Run the command, delmit by spaces, set app to the last field in the output of the ls command
  # ind2=$(awk -F"/" '{print NF-1}' <<< $(echo $app)); let "ind2=ind2+1" #output in app looks like /usr/sbin/rpcbind <-- set last / field to appname



  # #### DEVSPEC (debug point) Enviornment Specific
  # appname=$(echo $app | cut -d "/" -f$ind2)
  appname="cfprefsd"     ###<---- local machine, can be deleted for CA servers
  comm[1]=$(printf "$comm_App_whatisb$appname")
  #comm[2]=$(printf "$comm_App_psb$pid$comm_App_pse")
  comm[2]=$(printf "$comm_App_psb$pid")

  ### If whatis provides no new context, dig further
  if [[ $(${comm[1]} | cut -d ":" -f2)  == *nothing*appropriate* ]] ####<---Local
  #if [[ $(( ${comm[1]} 3>&1 1>&2- 2>&3- ) | cut -d ":" -f2) == *nothing*appropriate* ]]  ####<--- CA
  then
    desc=${comm[2]}
  else
    desc=$(${comm[1]} | head -n 1)
  fi

  ### Write output File
  printf "${substring[1]}, $port, ${substring[0]}, $appname, $desc;\r\n"  >> "$outputFile"

done
