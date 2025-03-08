# Arch Linux

## Instalación del Sistema Operativo

> [IMPORTANT]
> Recomiendo usar la [guía oficial de instalación](<https://wiki.archlinux.org/title/Installation_guide_(Espa%C3%B1ol)>). Este es un resumen simplificado y adaptado a mis necesidades. Puede ser que no tenga en cuenta hardware ajeno al que tengo en mis dispositivos.

> [WARNING]
> Si por cualquier razon se necesita tener SecureBoot activado despues de la instalacion de Arch, recomiendo que antes de comenzar se borren todas las claves de las BIOS

### Preparación

[Descargar ISO](https://archlinux.org/download/) de ArchLinux y [flashear](https://www.balena.io/etcher) una unidad externa
Conectar por cable Ethernet el dispositivo y arrancar el live desde el bootable.

(Opcinal) Configuramos el layout de nuestro teclado

```sh
loadkeys es
```

Comprobamos si tenemos conexión

```sh
ping archlinux.org
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

> Si aparece la opción de seleccionar algún label: `gpt` para EFI y `dos` para BIOS

```sh
cfdisk sdX
```

Creamos las particiones para el sistema operativo o root `/`, para los usuarios `/home` y el intercambio de memoria `swap`

> [CAUTION]
> Instalar Windows antes de Arch.

> [INFO]
> root `/` y `/home` pueden estar en una misma partición, pero es interesante separar para reinstalaciones futuras tener separado el sistema de los datos.
> La partición swap no es obligatoria, aunque recomendable.

**BIOS/MBR con Windows**

> [WARNING] En sistemas BIOS/MBR solo se pueden tener 4 volúmenes primarios. Como Windows ocupa 3, no podemos tener swap ni separar el home del root

| Ruta | Bootable | Tipo  | Tamaño sugerido |
| ---- | -------- | ----- | --------------- |
| `/`  | Si       | Linux | 100GB           |

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
Para los formatos de los _Linux filesystem_ o _Linux_

Para HDD

```sh
mkfs.ext4 /dev/sdXY
```

Para SSD (btrfs recomendado para ssd por diversos motivos)

```sh
mkfs.btrfs /dev/sdXY
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

Intel

```
pacstrap /mnt base linux linux-firmware git sudo intel-ucode
```

AMD

```
pacstrap /mnt base linux linux-firmware git sudo amd-ucode
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
```

Instalamos `nano` y `git` (util para mas adelante)

```sh
pacman -S nano git
```

Configuramos la hora

```sh
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
```

Idioma del sistema: descomentamos `en_US.UTF-8 UTF-8` y `es_ES.UTF-8 UTF-8`

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
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     NOMBREDEPC.localhost        NOMBREDEPC" >> /etc/hosts
pacman -S networkmanager
systemctl enable NetworkManager
```

### GRUB

**EFI**

> [IMPORTANT]
> Al final del README explico como hacer dualboot si tienes Windows instalado en otra particion

```sh
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

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

### Usuarios

Creamos usuarios, ponemos contraseñas y configuramos

```sh
passwd root
useradd -m NOMBREUSUARIO
passwd NOMBREUSUARIO
usermod -aG wheel,video,audio,storage NOMBREUSUARIO
```

Descargamos `sudo`

```sh
pacman -S sudo
nano /etc/sudoers
```

Configuramos `sudo` descomentando la linea `# %wheel ALL=(ALL:ALL) ALL` dejandola `%wheel ALL=(ALL:ALL) ALL`

```sh
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

## Extra: EFI Windows dual boot

Una vez apagues el sistema, quita el USB booteable, configura el boot order y entra a Arch.

Primero es sincronizar paquetes e instalar `os-prober` para detectar Windows

```sh
sudo pacman -Syy
sudo pacman -S os-prober
```

> [INFO]
> La linea "GRUB_DISABLE_OS_PROBER=false" esta al final del documento

Ahora configuramos `grub` descomentando la linea `#GRUB_DISABLE_OS_PROBER=false` dejandola `GRUB_DISABLE_OS_PROBER=false`

```sh
sudo nano /etc/default/grub
```

Generamos la config del `grub`

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Si no sale en el output algo como `Found Windows Boot Manager on /dev/...` este paso ha fallado.

### Alternativa instalado fuse3 (facil)

Si con `os-prober` no consigues el output mencionado anteriormente, prueba con fuse3

```sh
sudo pacman -Syy
sudo pacman -S fuse3
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Si no sale en el output algo como `Found Windows Boot Manager on /dev/...` este paso ha fallado.

### Alternativa montando EFI de Windows11

Esta alternativa puedes probarla con `os-prober` o con fuse3

```sh
sudo pacman -Syy
sudo mkdir /mnt/win11
sudo mount /dev/sdXY /mnt/win11
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo umount /mnt/win11
```

Si no sale en el output algo como `Found Windows Boot Manager on /dev/...` este paso ha fallado.
