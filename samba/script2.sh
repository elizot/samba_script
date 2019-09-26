#!/bin/bash
#Cores
vm="\033[0;31m"
vd="\033[0;32m"
am="\033[1;33m"
ne="\033[0m"
#Instala pacotes e envia logs.
function systopdesable(){
    for i in $@; do
        echo -e "Parando ${am}${i}${ne}\n"
        systemctl stop ${i} &>> ./logs4/logs4.txt
        status
        echo -e "Desabilitando ${am}${i}${ne}\n"
        systemctl disable ${i} &>> ./logs4/logs4.txt
        status
    done
}
function installer(){
    for i in $@; do
	clear    
        echo -e "Instalando ${am}${i}${ne}\n"
        apt-get -y install ${i} 2>> ./logs4/logs4.txt
        status
    done
}

#Verifica se o comando foi executado corretamente.
function status(){
    if [ $? -eq 0 ]; then
        echo -e "[${vd}Ok${ne}]\n"
        sleep 2
    else
        echo -e "[${vm}Failed${ne}]\n"
        sleep 2
    fi
}
if [ -d logs4 ]; then
    clear
    echo -e "Log....\n"
    status
else
    echo -e "Criando log....\n"
    mkdir logs4
    status
fi
clear
echo -e "Atualizando repositorios...\n"
apt-get update &>> ./logs4/logs4.txt && apt-get -y upgrade &>> ./logs4/logs4.txt
status

read -p "Trocar hostname? s/n: " sn
echo

if [ $sn = "s" ]; then
    read -p "Informe o novo hostname: " hname
    hostnamectl set-hostname ${hname} &>> ./logs4/logs4.txt
elif [ $sn = "S" ]; then
    read -p "Informe o novo hostname: " hname
    hostnamectl set-hostname ${hname} &>> ./logs4/logs4.txt
elif [ $sn = "n" ]; then
    echo -e "Nome do seu host: ${am}$(hostname)${ne}"
    status
elif [ $sn = "N" ]; then
    echo -e "Nome do seu host: ${am}$(hostname)${ne}"
    status
fi

echo -e "\nInstalando pacotes necessarios para o Samba4 AD DC...\n"
installer samba krb5-user krb5-config winbind libpam-winbind libnss-winbind net-tools

echo -e "Provisione o Samba AD DC para o seu dominio...\n"
systopdesable samba-ad-dc.service smbd.service nmbd.service winbind.service

echo -e "Fazendo backup do ${am}smb.conf${ne}...\n"
mv /etc/samba/smb.conf /etc/samba/smb.conf.bkp &>> ./logs4/logs4.txt
status

echo -e "Iniciando o provisionamento de dominio interativamente...\n"
samba-tool domain provision --use-rfc2307 --interactive
status

echo -e "\nFazendo backup do ${am}krb5.conf${ne}...\n"
mv /etc/krb5.conf /etc/krb5.conf.bkp &>> ./logs4/logs4.txt
status

echo -e "\nCriando link simbolico do ${am}krb5.conf${ne}...\n"
ln -s /var/lib/samba/private/krb5.conf /etc/ &>> ./logs4/logs4.txt
status

echo -e "Iniciando e ativando daemons do ${am}Samba Active Directory Domain Controller${ne}...\n"

systemctl unmask samba-ad-dc &>> ./logs4/logs4.txt
status

systemctl start samba-ad-dc.service &>> ./logs4/logs4.txt
status

systemctl status samba-ad-dc.service | sed -n '2 p'

systemctl enable samba-ad-dc.service &>> ./logs4/logs4.txt
status

echo -e "Lista de todos os serviços do ${am}Active Directory${ne}."
netstat -tulpn | egrep 'smbd|samba'

echo -e "Verificando O nivel de dominio mais alto...\n"
samba-tool domain level show
