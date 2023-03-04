# Arch Linux
## Instalación del Sistema Operativo

> Nota: Ante posibles errores seguir la [guía oficial de instalación](https://wiki.archlinux.org/title/Installation_guide_(Espa%C3%B1ol))

### Preparación
[Descargar ISO](https://archlinux.org/download/) de ArchLinux y [flashear](https://www.balena.io/etcher) una unidad externa 
Conectar por cable Ethernet el dispositivo y arrancar el CLI live desde el bootable

Configuramos el layout de nuestro teclado
```sh
loadkeys es
```

Comprobamos si tenemos conexión
```sh
ping benalmatica.com
```

Establecemos zona horaria, activamos la sincronización y comprobamos la fecha
```sh
timedatectl set-timezone Europe/Madrid
timedatectl set-ntp true
timedatectl show
```

### Particiones y Formatos
Vamos a comprobar si es EFI o BIOS el modo de arranque del hardware sobre el que vamos a instalar el sistema operativo
```sh
ls /sys/firmware/efi/efivars
```
Si no hay error al ejecutar ese comando es un arranque EFI. En caso contrario se trata de un equipo probablemente más antiguo con arranque BIOS

Consultamos las unidades que hay y donde vamos a hacer la instalación
```sh
lsblk
```

Ejecutamos el programa para crear particiones
 >Si aparece la opción de seleccionar algún label: `gpt` para EFI y `dos` para BIOS
```sh
cfdisk sdX
```

Creamos las particiones para el sistema operativo o root `/`, para los usuarios `/home` y el intercambio de memoria `swap`

> Notas: root `/` y `/home` pueden estar en una misma partición. 
>  La partición swap no es obligatoria, aunque recomendable. 
>  Instalar Windows antes de Arch. 
>  En sistemas BIOS/MBR solo se pueden tener 4 volúmenes primarios. Como Windows ocupa 3, no podemos tener swap ni separar el home del root

**BIOS/MBR con Windows**
| Ruta | Bootable | Tipo | Tamaño sugerido |
| ---- | ---- | ---- | ------------- |
| `/` | Si | Linux | 100GB |

**BIOS/MBR en disco limpio**
| Ruta | Bootable| Tipo | Tamaño sugerido |
| ---- | ---- | ---- | ------------- |
| `/` | Si | Linux | 50GB |
| `/home` | No | Linux | 50GB |
| `[SWAP]` | No| swap/ Solaris | 8GB |

**EFI con Windows**
| Ruta | Tipo | Tamaño sugerido |
| ---- | ---- | ------------- |
| `/` | Linux filesystem | 50GB |
| `/home` | Linux filesystem | 50GB |
| `[SWAP]` | Linux swap | 8GB |

**EFI en disco limpio**
| Ruta | Tipo | Tamaño sugerido |
| ---- | ---- | ------------- |
| `EFI` | EFI System | 1GB |
| `/` | Linux filesystem | 50GB |
| `/home` | Linux filesystem | 50GB |
| `[SWAP]` | Linux swap | 8GB |

Vemos los nuevos `/dev/sdXY` que se nos han creado
```sh
lsblk
```
Vamos a darles formato
Para los formatos de los *Linux filesystem* o *Linux*
```sh
mkfs.ext4 /dev/sdXY
```
Si has creado swap, hay que darle formato y su "activarlo"
```sh
mkswap /dev/sdXY
swapon /dev/sdXY
```

> Nota: Si tienes otro linux o windows y ejecutas el siguiente comando no podrás volver a acceder a esos sistemas operativos

Solo si acabas de crear la partición "EFI System"
```sh
mkfs.fat -F 32 /dev/sdXY
```
### Montaje e Instalación
Vamos a montar las particiones en las rutas adecuadas para que el script `pacstrap` instale correctamente
```sh
mount /dev/sdXY(Particion del ROOT) /mnt
```

Si has separado el `/home` en otra partición añade
```sh
mkdir /mnt/home
mount /dev/sdXY(Particion del HOME) /mnt/home
```

Además, Para sistemas UEFI hay que montar la partición EFI
```sh
mkdir /mnt/boot
mount /dev/sdXY /mnt/boot
```

Instalamos el Sistema Operativo
```
pacstrap /mnt base linux linux-firmware
```

Cuando termine generamos tablas del sistema y comprobamos que todo está correcto
**BIOS/MBR**
```
genfstab /mnt >> /mnt/etc/fstab
```
**EFI**
```
genfstab -U /mnt >> /mnt/etc/fstab
```

### Configuración
Accedemos al sistema operativo recién instalado y empezamos a configurar
```sh
arch-chroot /mnt
pacman -S nano
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
```

Descomentamos `en_US.UTF-8 UTF-8` y `es_ES.UTF-8 UTF-8`
```sh
nano /etc/locale.gen
```

Generamos el archivo y creamos `locale.conf`
```sh
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf
```

Para la distribución de teclado
```sh
echo "KEYMAP=es" > /etc/vconsole.conf
```

Redes
```sh
echo "NOMBREDEPC" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 NOMBREDEPC.localhost" >> /etc/hosts
pacman -S networkmanager
systemctl enable NetworkManager
```

### GRUB
**BIOS Dual boot con Windows**
```sh
pacman -S grub grub-bios os-prober ntfs-3g
grub-install /dev/sdX 
```

Descomentamos la ultima línea (`GRUB_DISABLE_OS_PROBER=false`) del archivo `/etc/default/grub` para que nos detecte el windows al crear la configuración del grub
```sh
nano /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
```

**BIOS Single boot**
```sh
pacman -S grub
grub-install /dev/sdX 
grub-mkconfig -o /boot/grub/grub.cfg
```

**EFI Single boot**
```sh
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```

**EFI Dual boot con Windows**
> https://gtronick.github.io/ALIG-DUAL/

```sh
bootctl --path=/boot install
```

```
nano /boot/loader/loader.conf
-----------------------------
default arch
timeout 5
editor 0
```

```
echo $(blkid -s PARTUUID -o value /dev/sda6) > /boot/loader/entries/arch.conf
nano /boot/loader/entries/arch.conf
-----------------------------
title ArchLinux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxx rw
```

### Usuarios
Creamos usuarios, ponemos contraseñas y configuramos
```sh
passwd root
useradd -m NOMBREUSUARIO
passwd NOMBREUSUARIO
usermod -aG wheel,video,audio,storage NOMBREUSUARIO
```

Descarga y configuración de `sudo` (descomentar `%wheel ...`)
```sh
pacman -S sudo
nano /etc/sudoers
```

### Finalizar instalación
Salimos del sistema operativo y volvemos al live
```sh
exit
```

Desmontamos todas las unidades del booteable, apagamos y extraemos el booteable
```sh
umount -R /mnt
shutdown now
```
