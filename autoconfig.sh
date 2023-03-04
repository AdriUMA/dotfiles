#!/usr/bin/bash

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
HOME=~`whoami` | eval

#Si no se puede ejecutar dotfiles.sh, abortamos
if [ ! -x $SCRIPT_DIR/dotfiles.sh ]; then
    echo -e "\e[31mERROR: \e[0m$SCRIPT_DIR/\e[1m\e[31mdotfiles.sh\e[0m sin permisos de ejecucion\e[0m"
    echo -e "Intenta 'chmod u+x $SCRIPT_DIR/dotfiles.sh'"
    exit
fi

#Archivos innecesarios separados por un espacio
INNECESARY_FILES=$SCRIPT_DIR/README.md

#Borramos archivos innecesarios para la instalacion de la configuracion
rm -R $INNECESARY_FILES &> /dev/null

#Comenzamos la instalacion
$SCRIPT_DIR/dotfiles.sh $SCRIPT_DIR $HOME $SCRIPT_DIR

#Borramos la carpeta git (residuos)
rm -R $SCRIPT_DIR

echo -e "\e[32mCompletado con exito!\e[0m"
echo -e "\e[34m╔═╗┬─┐┌─┐┬ ┬╔╦╗╔╦╗
╠═╣├┬┘│  ├─┤ ║ ║║║
╩ ╩┴└─└─┘┴ ┴ ╩ ╩ ╩\e[0m"
