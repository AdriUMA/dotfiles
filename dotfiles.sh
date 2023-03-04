#!/usr/bin/bash

SOURCE=$1
TARGET=$2
MAIN_DIR=$3

for element in `ls -a "$SOURCE" | tail -n +3`; do
    #Filtramos para que no se tenga en cuenta a si mismo
    if [ $element = "autoconfig.sh" -o $element = "dotfiles.sh" ]; then continue
    fi

    #En caso de que exista el elemento en el destino
    if [ -e $TARGET/$element ]; then
        #Y que sean archivos en origen y destino
        if [ -f $TARGET/$element -a -f $SOURCE/$element ]; then
            #Se borra el original
            rm -f $TARGET/$element
            #Se mueve el de git a la ruta del sistema correspondiente
            mv $SOURCE/$element $TARGET/
        #Y que sean carpetas en origen y destino
        elif [ -d $TARGET/$element -a -d $SOURCE/$element ]; then
            #Pasamos recursivamente la tarea
            $MAIN_DIR/dotfiles.sh $SOURCE/$element $TARGET/$element $MAIN_DIR/
        fi
    #En caso de que no exista el elemento en el destino
    else
        #Se mueve el elemento
        mv $SOURCE/$element $TARGET/
    fi
done