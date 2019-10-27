#!/bin/bash
   
#Coloca o diretorio doa arquivo no lugar de --> grup --> cat --path--
  
array1=($(cat grup | grep "#" | sed -e 's/:/ /g' | awk '{print $2}' ))
array2=($(cat grup | grep "#" | sed -e 's/:/ /g' | awk '{print $3}' | sed -e 's/--given=//g' -e 's/OU=//g'))
array3=($(cat grup | grep "#" | sed -e 's/:/ /g' | awk '{print $4}' | sed -e 's/--description=//g'))
  
echo -e "[\n"
  
for i in $(seq 0 ${#array1[@]}); do
    if [ "${array1[$i]}" = "" ]; then
        break
    elif [ $i -eq $((${#array1[@]}-1)) ]; then
        echo -e "\t{\"id\" : \"${array1[$i]}\",\"parent\" : \"${array2[$i]}\", \"description\": \"${array3[$i]}\"}"
    #elif [ ]; then
    else
        echo -e "\t{\"id\" : \"${array1[$i]}\",\"parent\" : \"${array2[$i]}\", \"description\": \"${array3[$i]}\"},"
    fi
done
echo -e "]\n"
