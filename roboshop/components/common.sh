#!bin/bash 

Status_Check() {
  if [ $1 -eq 0 ]; then 
    echo -e "\e[32mCOMPLETED\e[0m"
  else 
    echo -e "\e[31mNOTCOMPLETED\e[0m"
    exit 2
  fi 
}

Print() {
  echo -e "\n\t\t\e[36m----------------- $1 ----------------------\e[0m\n" &>>/tmp/log
  echo -n -e "$1 \t- "
}
if [ $SUI -ne 0 ]; then
    echo -e "\n\e[1;35mYou need root permission\e[0m\n"
    exit 1
    
    fi
    
    