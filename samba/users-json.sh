#!/bin/bash
   
#Coloca o diretorio doa arquivo no lugar de --> grup --> cat --path--
  
array1=($(cat grup | grep "#" | sed -e 's/:/ /g' | awk '{print $2}' ))
array2=($(cat usuarios | grep "#" | sed -e 's/:/ /g' | awk '{print $3}' | sed -e 's/--given=//g' -e 's/,/ /g' -e 's/OU=//g'))

echo -e "[\n"
  
for i in $(seq 0 $((${#array1[@]}-1))); do
	array4=($(samba-tool group listmembers ${array1[$i]}))


	for j in $(seq 0 $((${#array4[@]}-1))); do
		caminho=($(cat usuarios | grep "#" | sed -e 's/:/ /g' | awk '{print $4}' | sed -e 's/--given=//g' -e 's/,/ /g' -e 's/userou=OU=//g'))
		echo -e "\t{\"id\" : \"${array4[$j]}\", \"parent\" : \"${caminho}\", \"text\" : \"${array4[$j]}\"}," | sed 's/ou=//g'
	done
done
echo -e "]\n"
