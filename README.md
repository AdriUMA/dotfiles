# Dotfiles
## Instalación del Entorno
### Instalación de Qtile y Lightdm para inicio de sesión
```sh
sudo pacman -S qtile xterm lightdm
sudo systemctl enable lightdm
sudo pacman -S lightdm-gtk-greeter
reboot
```
**Errores**
Si hay errores en el reinicio hay que instalar `xorg-server`
>Si no puedes escribir comandos usa `Alt+F2`, `Control+Alt+F2` o `Alt+⮕`

Primero intenta
```sh
sudo pacman -S xorg-server
reboot
```
Como ultima opción instalamos todos los paquetes de `xorg`
```sh
sudo pacman -S xorg
reboot
```

## Instalación de Paquetes y Configuración
Instalamos primero Firefox para copiarlo desde github y no tener que escribir todo a mano
```
sudo pacman -S firefox
firefox https://github.com/AdriUMA/arch &disown
```

Instalación de todos los paquetes
```sh
sudo pacman -S git kitty code rofi picom feh flameshot brightnessctl pulseaudio pavucontrol bat neofetch man gimp udisks2 ntfs-3g arandr vlc imv thunar xcb-util-cursor lxappearance
```
```sh
paru -ubuntu-mono-nerd
paru cascadiafont
paru psutil ttf
paru pulseaudio-ctl
```

Instalacion de Paru
```sh
sudo pacman -S base-devel
cd
cd Descargas
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

Configuraciones autom
>Advertencia: `autoconfig.sh` borra las configuraciones que encuentre y aplica las mías. Si sólo se quiere la configuración de algunos paquetes tendrá que hacerse manualmente 
```sh
cd
mkdir Descargas
cd Descargas
git clone https://github.com/AdriUMA/arch.git
chmod u+x arch/autoconfig.sh
chmod u+x arch/dotfiles.sh
sh arch/autoconfig.sh
```

### Paquetes instalados
>Nota: Si tienes problemas con las fuentes, instala estos paquetes tras la instalación `sudo pacman -S ttf-dejavu ttf-liberation noto-fonts`

| Nombre | Paquete | Descripción | Atajo |
| ------ | ------- | ----------- | ----- |
| Qtile | qtile | Gestor de ventanas |  |
| LightDM | lightdm | Inicio de sesión gráfico | `mod`+`Shift`+`q` |
| Tema LightDM | lightdm-gtk-greeter | Tema para LightDM | `mod`+`Shift`+`q` |
| Tema LightDM | lightdm-webkit2-greeter | Tema para LightDM | `mod`+`Shift`+`q` |
| Git | git | Peticiones de github |  |
| Kitty | kitty | Terminal acelerada por GPU | `mod`+`\n`  |
| Xterm | xterm | Terminal por defecto de Qtile|  |
| Firefox | firefox | Navegador | `mod`+`w`  |
| Visual Studio Code | code | Editor de código fuente | `mod`+`v`  |
| Rofi | rofi | Ejecutador de programas | `mod`+`r`  |
| Picom | picom | Trasparencia en aplicaciones |  |
| Feh| feh| Fondo de pantalla |  |
| Flameshot | flameshot | Capturas de pantalla | `mod`+`Shift`+`s` |
| Brightness Control | brightnessctl | Brillo de pantalla | Teclas especiales |
| Pulse Audio | pulseaudio | Audio | `mod`+`f10/f11/f12` |
| Pavu Control | pulseaudio-ctl (paru) | Configurador de pulseaudio |  |
| Pulse Controller | pavucontrol | Configurador gráfico de pulseaudio |  |
| Bat | bat | Leer archivos desde terminal |  |
| Neo Fetch | neofetch | Información del sistema en terminal |  |
| Manual | man | Manual en terminal |  |
| Paru | [paru](https://github.com/Morganamilo/paru) | Repositorio de paquetes |  |
| Compilador de pkg | base-devel | Necesario para el correcto funcionamiento de Paru |  |
| Nerd Font | ttf-ubuntu-mono-nerd | Fuente (descargado con paru) |  |
| Cascadia Mono Font | ? | Fuente (descargado con paru) |  |
| GIMP | gimp | Editor de Imagenes |  |
| UDisk | udisks2 | Montaje de unidades automatizado |  |
| NTFS | ntfs-3g | Montaje de unidades creadas por Windows |  |
| ARandR | arandr | Configuracion gráfico de pantallas |  |
| VLC | vlc | Abrir archivos de video |  |
| Image Viewer | imv | Abrir imagenes |  |
| Thunar | thunar | Explorador de archivos gráfico ([Tema](https://www.xfce-look.org/p/1267246)) | `mod`+`e` |
| Cursor | xcb-util-cursor | Cursor personalizado ([Tema](https://www.xfce-look.org/p/1717914)) | |
| Appearance | lxappearance | Instalador de temas | |
| Discord | discord | Llamadas | |
| PSUtil | psutil | Dependecias de Qtile, desde paru | |

### Otros paquetes
cbatticon, [libnotify](https://wiki.archlinux.org/title/Desktop_notifications), network-manager-applet

### Shortcuts
| Descripción | Atajo |
| ----------- | ----- |
| Abrir Firefox | `mod`+`w` |
| Abrir terminal | `mod`+`Enter` |
| Cerrar sesión | `mod`+`Ctrl`+`q` |
| Refrescar Qtile | `mod`+`Ctrl`+`r` |
| Alternar ventanas | `mod`+`Space` |
| Buscar ventana | `mod`+`m` |
| Moverse entre las ventanas | `mod`+`h/j/k/l` |
| Ajustar tamaño de las ventanas | `mod`+`Ctrl`+`h/j/k/l` |
| Mover ventanas de posicion | `mod`+`Shift`+`h/j/k/l` |
| Cambiar layout de las ventanas | `mod`+`Tab` |
| Cerrar ventana en focus | `mod`+`q` |
| Mover ventana con el ratón | `mod`+`LMB` |
| Ajustar tamaño de la ventana con el ratón | `mod`+`RMB` |
| Alternar modo ventana flotante | `mod`+`f` |
| Cambiar de espacio de trabajo | `mod`+`1/2/3/4/5` |
| Cambiar de espacio de trabajo junto a una ventana | `mod`+`Shift`+`1/2/3/4/5` |
