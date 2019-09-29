#!/bin/bash
#Cores
vm="\033[0;31m"
vd="\033[0;32m"
am="\033[1;33m"
ne="\033[0m"

function status(){
    if [ $? -eq 0 ]; then
        echo -e "[${vd}Ok${ne}]\n"
        sleep 3
    else
        echo -e "[${vm}Failed${ne}]\n"
        sleep 3
    fi
}
function menu_principal(){
    clear
    echo -e "\t$(date)"
    read -p "    ┌───┬─────────────────────────────────┐
    │ 1 │    CONFIGURAÇÕES DE USUÁRIOS.   │
    ├───┼─────────────────────────────────┤ 
    │ 2 │    CONFIGURAÇÕES DE GRUPOS.     │
    ├───┼─────────────────────────────────┤ 
    │ 3 │    SERVIDOR SECUNDARIO.         │
    ├───┼─────────────────────────────────┤
    │ 0 │    SAIR DO SCRIPT               │
    ├───┴─────────────────────────────────┘ 
    │
    └───OPÇÃO: " OP
    case $OP in
        0) exit ;;
        1) menu_users ;;
        2) menu_groups ;;
        *) read -p "    Opção Invalida!" x
    esac
}
function menu_users(){
    clear
    echo -e "\t$(date)"
    read -p "    ┌───┬─────────────────────────────────┐
    │ 1 │    CRIAR NOVO USUÁRIO.          │
    ├───┼─────────────────────────────────┤ 
    │ 2 │    DELETAR USUÁRIO.             │
    ├───┼─────────────────────────────────┤ 
    │ 3 │    LISTAR USUÁRIOS.             │
    ├───┼─────────────────────────────────┤
    │ 4 │    TROCAR SENHA DO USUÁRIO.     │
    ├───┼─────────────────────────────────┤
    │ 5 │    DESABILITAR UM  USUÁRIO.     │
    ├───┼─────────────────────────────────┤
    │ 6 │    HABILITAR UM  USUÁRIO.       │
    ├───┼─────────────────────────────────┤
    │ 0 │    VOLTAR AO MENU PRINCIPAL.    │
    ├───┴─────────────────────────────────┘ 
    │
    └───OPÇÃO: " OP
    case $OP in
        0) menu_principal ;;
        1) novo_usuario ;;
        2) delete_user ;;
        3) listar_users ;;
        4) novo_password ;;
        5) desabilitar_user ;;
        6) habilitar_user ;;
        *) read -p "    Opção Invalida!" x
    esac
}

function menu_groups(){
    clear
    echo -e "\t$(date)"
    read -p "    ┌───┬──────────────────────────────────────┐
    │ 1 │    CRIAR NOVO GRUPO.                 │
    ├───┼──────────────────────────────────────┤ 
    │ 2 │    DELETAR GRUPO.                    │
    ├───┼──────────────────────────────────────┤ 
    │ 3 │    LISTAR GRUPOS.                    │
    ├───┼──────────────────────────────────────┤
    │ 4 │    ADICIONAR MEMBRO A UM GRUPO.      │
    ├───┼──────────────────────────────────────┤
    │ 5 │    ADICIONAR UM GRUPO A OUTRO GRUPO. │
    ├───┼──────────────────────────────────────┤
    │ 6 │    REMOVER MEMBRO DE UM GRUPO.       │
    ├───┼──────────────────────────────────────┤
    │ 7 │    LISTAR MEMBROS DE UM GRUPO.       │
    ├───┼──────────────────────────────────────┤
    │ 0 │    VOLTAR AO MENU PRINCIPAL.         │
    ├───┴──────────────────────────────────────┘ 
    │
    └───OPÇÃO: " OP
    case $OP in
        0) menu_principal ;;
        1) novo_grupo ;;
        2) deletar_grupo ;;
        3) listar_grupos ;;
        4) add_membro ;;
        5) grupo_add_grupo ;;
        6) remo_membro ;;
        7) listar_grupos ;;
        *) read -p "    Opção Invalida!" x
    esac
}
# PARTE DAS CONFIGURAÇÕES DE USUÁRIOS.
function novo_usuario(){
    clear
    echo
    read -p "Informe o nome do novo usuário: " nuser
    samba-tool user create ${nuser} 2> ./logs4/logs4.txt
    status
    menu_users
}
function delete_user(){
    clear
    read -p "Informe o nome do usuário a ser deletado: " duser
    samba-tool user delete ${duser} 2> ./logs4/logs4.txt && rm -r /home/samba/${duser} 2> ./logs4/logs4.txt
    status
    menu_users
}
function listar_users(){
    clear
    samba-tool user list | less
    status
    menu_users
}
function novo_password(){
    clear
    echo -e "${am}Trocar senha do usuário e forca a troca no Próximo Login.${ne}\n"
    read -p "Informe o nome do usuário: " tuser
    read -p "Informe a nova senha: " npass
    samba-tool user setpassword ${tuser} --newpassword=${npass}.Mudar.Senha --must-change-at-next-login 2> ./logs4/logs4.txt
    status
    menu_users
}
funtion add_membro(){
    clear
    read -p "Digite o nome do grupo que receberá o usuário: " ngroup
    read -p "Digite o nome no usuário que será adicionado ao grupo ${am}${ngroup}${ne}: " nuser 
    samba-tool group addmembers $ngroup $nuser 2> ./logs4/logs4.txt
    status
    menu_users
}
function desabilitar_user(){
    clear
    read -p "Informe o nome do usuário a ser desativado: " duser
    samba-tool user disable ${duser} 2> ./logs4/logs4.txt
    status
    menu_users
}
function habilitar_user(){
    clear
    read -p "Informe o nome do usuário a ser habilitado: " huser
    samba-tool user enable ${huser} 2> ./logs4/logs4.txt
    status
    menu_users
}

#PARTE DE CONFIGURAÇÃO DOS GRUPOS.
function novo_grupo(){
    clear
    read -p "Informe o nome do novo grupo: " ngrupo
    read -p "Descrição do grupo: " desc
    samba-tool group add ${ngrupo} --description=${desc} 2> ./logs4/logs4.txt
    status
    menu_groups
}
function deletar_grupo(){
    clear
    read -p "Informe o nome do grupo a ser deletado: " dgrupo
    samba-tool group delete ${dgrupo} 2> ./logs4/logs4.txt
    status
    menu_groups
}
function listar_grupos(){
    clear
    samba-tool group list | less
    status
    menu_groups
}
function grupo_add_grupo(){
    clear
    read -p "Nome do grupo que receberá o outro grupo: " ngrupo1
    read -p "Nome do grupo a ser adicionado: " ngrupo2
    samba-tool group addmembers ${ngrupo1} ${ngrupo2} 2> ./logs4/logs4.txt
    status
    menu_groups
}
function remo_membro(){
    clear
    read -p "Nome do usuário que será removido: " nuser
    read -p "Nome do grupo em que o usuário esta localizado:  " ngrupo
    samba-tool group removemembers ${ngrupo} ${nuser} 2> ./logs4/logs4.txt
    status
    menu_groups
}
function listar_membros(){
    clear
    read -p "Listar membros do grupo: " ngrupo
    samba-tool group listmembers ${ngrupo} | less
    status
    menu_groups
}
if [ -d logs4 ]; then
    clear
    echo -e "Log....\n"
    status
else
    clear
    echo -e "Criando log....\n"
    mkdir logs4
    status
fi
clear
menu_principal
