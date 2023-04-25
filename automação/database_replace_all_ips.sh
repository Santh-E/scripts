#!/bin/bash

# Script básico para mudar automaticamente configurações de banco de dados de todos os plugins
# O script procura todos os arquivos .yml no diretorio /var/lib/pterodactyl e troca as informações inseridas no código
# Caso uma informação seja igual a antiga basta repetir no comando
# Caso queira recuperar os arquivos originais só executar o reset_old.sh

if [[ $1 && $2 ]]; then
   OIFS="$IFS"
   IFS=$'\n'
   # encontrando todos os arquivos .yml dentro da pasta /var/lib/pterodactyl
   for tf in $(find /var/lib/pterodactyl -type f -name "*.yml" -size +0); do
      echo -ne "\033[1K\r" $tf
      cat $tf | while read line; do
         #verificando se o arquivo tem o antigo IP
         if [[ $line =~ $1 ]]; then 
            #renomeando arquivos original com .old
            mv $tf "${tf}.old"
            cat "${tf}.old" | while read line2; do
               lin=${line2/$1/$2};
               echo $lin >> $tf
            done
            echo -e " editado!"
            break
         fi
      done
   done
   IFS="$OIFS"
   echo ""
else
   echo "usage: ./database_replace_all.sh oldIP newIP"
fi
