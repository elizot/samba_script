 #!/bin/bash
 very=$(ldbsearch -H /var/lib/private/sam.ldb | grep "dc=COM" | grep "dn:" | sed -e 's/dn: //g' -e 's/,/ /g'  | awk '{print $2}' | grep 'dc=' | awk 'NR==1 {print $1}')
 array1=($(ldbsearch -H /var/lib/private/sam.ldb | grep "dc=COM" | grep "dn:" | sed -e 's/dn://g' -e 's/,/ /g'  | awk '{print $1}'))
 array2=($(ldbsearch -H /var/lib/private/sam.ldb | grep "dc=COM" | grep "dn:" | sed -e 's/dn://g' -e 's/,/ /g'  | awk '{print $2}'))
  
 echo -e "[\n"
 
 for i in $(seq 0 ${#array1[@]}); do
     if [ "${array1[$i]}" = "" ]; then
         break
    elif [ $i -eq $((${#array1[@]}-1)) ]; then
         if [ "${array2[$i]}" = "${very}" ]; then
             echo -e "\t{\"id\" : \"${array1[$i]}\", \"parent\" : \"#\", \"text\" : \"${array1[$i]}\"}" | sed 's/ou=//g'
         else
             echo -e "\t{\"id\" : \"${array1[$i]}\", \"parent\" : \"${array2[$i]}\", \"text\" : \"${array1[$i]}\"}," | sed 's/ou=//g'
         fi
     elif [ "${array2[$i]}" = "${very}" ]; then
         echo -e "\t{\"id\" : \"${array1[$i]}\", \"parent\" : \"#\", \"text\" : \"${array1[$i]}\"}," | sed 's/ou=//g'
     else
         echo -e "\t{\"id\" : \"${array1[$i]}\", \"parent\" : \"${array2[$i]}\", \"text\" : \"${array1[$i]}\"}, " | sed 's/ou=//g'
     fi
done
echo -e "]\n"
