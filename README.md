# xmonad-for-asusn76vz
My configuration xmonad based archlinux for asus n76vz notebook
The contents of this file in Russian, for translation use the service Google translator
https://translate.google.com/

Подключение к сети

cp /etc/netctl/exaples/wireless-wpa-static /etc/netctl/
nano /etc/netctl/wireless-wpa-static

Впишем в профиль такие параметры:
Interface=wlp3s0
Connection=wireless
Security=wpa
ESSID='Имя сети'
Key='пароль'
IP=static
Address='10.3.3.163/24'
Gateway='10.3.3.1'
DNS=('10.3.3.1')

Затем запустим сеть:
netctl restart wireless-wpa-static

Проверяем:
ping -c 3 yandex.ru

Диски. Создание разделов и субразделов
Определяем диски:

fdisk -l
или
lsblk

Для нашего случая имеем диск 
/dev/sda 111.8 G ssd
/dev/sdb 232.9 G hdd

Удаляем MBR или GPT таблицы командой: 
Внимание! это отформатирует весь ваш диск, с потерей данных!
sgdisk --zap-all /dev/sda
sgdisk --zap-all /dev/sdb

Вместо разметки GPT или UEFI будем создавать btrfs (изменив всю схему разбиения диска). 

mkfs.btrfs -f -L Corsair /dev/sda
mkfs.btrfs -f -L  /dev/sdb

Монтируем:
mount /dev/sda /mnt
создадим подтом root
btrfs subvolume create /mnt/root
И отмонтируем корень ФС:
umount /mnt

Монтируем:
mount /dev/sdb /mnt
создадим два подтома под var и домашний каталог пользователя:
btrfs subvolume create /mnt/var
btrfs subvolume create /mnt/home
И отмонтируем корень ФС:
umount /mnt

Чтобы монтировать подтом подобно обычному разделу диска, команде mount нужно указывать опцию subvol=PATH, где PATH - путь относительно корня ФС. Монтируем корень:
mount -o subvol=root,compress=lzo,ssd /dev/sda /mnt

В параметрах указано сжатие lzo, что даёт прирост экономии места + повышает производительность, и autodefrag дефрагметацию в фоне.
Создаём папку и монтируем в неё наш будущий каталог пользователей:
mkdir /mnt/var
mkdir /mnt/home
mount -o subvol=var,compress=lzo,autodefrag /dev/sdb /mnt/var
mount -o subvol=home,compress=lzo,autodefrag /dev/sdb /mnt/home

Устанавливаем базовые пакеты

Обновим базы
pacman -Sy

pacstrap /mnt base base-devel xorg-xinit xorg-server mesa grub zsh mc btrfs-progs

Важно: если ведется установка по Wi-Fi, то необходимо также установить пакет wpa_supplicant:

Создаём fstab
genfstab -U /mnt >> /mnt/etc/fstab
проверяем:
cat /mnt/etc/fstab

Входим в систему:
arch-chroot /mnt

Называем компьютер:
echo имя_компьютера > /etc/hostname

Локализация:
nano /etc/locale.gen
Оставить раскомментированными только
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
Сохраняем Ctrl+o 
enter
Выходим Ctrl+x

Создаём рам-диск mkinitcpio
nano /etc/mkinitcpio.conf
В /etc/mkinitcpio.conf, в разделе HOOKS, должен быть прописан хук keymap, и убрать fsck
В разделе MODULES нужно прописать свой драйвер видеокарты: i915 для Intel, radeon для AMD, nouveau для Nvidia.
mkinitcpio -p linux

Зададим пароль рута
passwd
Создать пользователя
useradd -m -g users -G wheel,audio,video,storage -s /bin/zsh s-adm *
И задать ему пароль
passwd s-adm

Установка boot loader'а.
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

Перезагрузка

Можно бы было и здесь продолжить установку ПО и настроек, но как показывает опыт, сейчас лучше перегрузиться в свежеустановленную систему, и зайдя под рутом продолжить настройку.
Выходим из установленной системы
exit
и перегружаемся
reboot

Логинимся под root

Подключаемся к сети

Выбор часового пояса:
(команда tzselect поможет просмотреть часовые пояса)
timedatectl set-timezone Asia/Yekaterinburg

Сгенерировать локали:
locale-gen

Выполняем локализацию системы:

localectl set-keymap us

setfont cyr-sun16

localectl set-locale LANG="ru_RU.UTF-8"

export LANG=ru_RU.UTF-8

Чтобы шрифт в консоли и после перезагрузки был русским, запишем его в конфиг

nano /etc/vconsole.conf

KEYMAP=us 
FONT=cyr-sun16

Сохраняем Ctrl+o 
enter
Выходим Ctrl+x

Создаем пользователя
useradd -m -g users -G wheel,audio,video,storage -s /bin/zsh s-adm
И задаем ему пароль
passwd s-adm

Установка Yaourt

nano /etc/pacman.conf
В конце добавить:
#Репозиторий Yaourt
[archlinuxfr]
Server = http://repo.archlinux.fr/$arch

Заодно закомментировать
#SigLevel    = Required DatabaseOptional
и расскомментировать:
[multilib]
Include = /etc/pacman.d/mirrorlist

Затем выполнить:
pacman -Syy && pacman -S yaourt

Настройка sudo
EDITOR=nano visudo

#дать пользователю привилегии суперпользователя, когда он вводит sudo
s-adm ALL=(ALL) ALL
#Чтобы не спрашивать пароль у пользователя
Defaults:s-adm      !authenticate
раскомментировать
%Wheel  ALL=(ALL) ALL

Перелогиниваемся под s-adm

cp /etc/zsh/zprofile ~/.zprofile

Установка первоначального ПО

sudo pacman -S numlockx trayer compton rxvt-unicode urxvt-perls xf86-input-synaptics parcellite networkmanager network-manager-applet feh pcmanfm chromium xmonad xmonad-contrib xmobar git wget acpi geany leafpad smbclient gvfs-smb ntfs-3g cantarell-fonts ttf-liberation ttf-dejavu p7zip unrar unace lrzip xarchiver-gtk2 scrot transmission-gtk flashplugin xf86-video-ati xf86-video-intel xf86-video-nouveau xf86-video-amdgpu gcolor2 rofi lxappearance oblogout vnstat htop pinta gpicview thunderbird-i18n-ru aspell-ru galculator wmctr xorg-xinput dosfstools exfat-utils gnome-menus gmrun screenfetch dunst libnotify xorg-xclock xorg-xev deadbeef libmad mpv

Опционально 
sudo pacman -S orage lxterminal atom opera procinfo grsync cherrytree dropbox
xfconf  - утилиты для управления настройками в Xfce
procinfo - информация об устройствах (lsdev) 
wmctrl  - это инструмент командной строки для взаимодействия с EWMH
xorg-xinput - маленькая программа для управления мышью тачпадом и др.
gnome-menus - нужен для pcmanfm


yaourt -S --noconfirm pacli perwindowlayoutd zsh-syntax-highlighting alsa-utils polkit-gnome-gtk2 ttf-ms-fonts paper-icon-theme xcursor-chameleon-pearl wps-office ttf-wps-fonts wps-office-extention-russian-dictionary acpitool localepurge ttf-font-awesome gtk-theme-absolute

Опционально 
yaourt -S --noconfirm  xscreenshot telegram-desktop oomox-git pepper-flash llpp google-earth
pepper-flash - плагин для просмотра видео в браузере Opera
llpp - Очень быстрая программа чтения PDF, основанная на MuPDF и поддерживающая непрерывную прокрутку страниц, закладки и поиск по тексту во всем документе
apvlv — Легковесная программа просмотра PDF/DjVu/UMD/TXT с горячими клавишами Vim

oh-my-zsh 
Клонируем репозиторий:
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

Копируем исходный конфиг .zshrc:
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

Шрифты
sudo pacman -S ttf-croscore ttf-dejavu ttf-ubuntu-font-family ttf-inconsolata ttf-liberation 
yaourt -S ttf-carlito ttf-caladea ttf-droid-sans-mono-slashed-powerline-git --noconfirm
Если устанавливаем свои шрифты:
скопируйте их в папку /usr/share/fonts/Мои_Шрифты
и выполните
sudo fc-cache  -fv

Выбрать метод рендеринга:
Выполните
sudo nano /etc/profile.d/freetype2.sh
И приведите к такому виду:
"# Uncomment and configure below
export FREETYPE_PROPERTIES="truetype:interpreter-version=38"

Изменение файла настроек
создайте файл /etc/fonts/local.conf c таким содержимым (тут мы настроим отоброжение шрифтов, а также подменим MS шрифты на Chrome OS):

В файл ~/.Xresources внесём следующие строки:
Xft.dpi: 96
Xft.antialias: true
Xft.hinting: true
Xft.rgba: rgb
Xft.autohint: false
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault
и выполним:
xrdb -merge ~/.Xresources
Также в настройках вашего DE поставьте сглаживание RGBa, вместо grayscale (такое доступно в Gnome и Cinnamon, в остальных не проверял).
Если используете приложения Java, то в файле /etc/environment добавьте следующую строку:
_JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
- это нужно для того, чтобы приложения Java ощущались и выглядели как GTK

Перезапустите X-ы.

Удалить ненужные локали (после установки всех программ (должна быть установлена localepurge))
Как вариант: Чтобы не устанавливать из AUR localepurge, воспользуйтесь bleachbit.
nano /etc/locale.nopurge
и закомментируем строчку NEEDSCONFIGFIRST, которая служит “защитой” от удаления локалей без настройки программы.
сделаем последний абзац похожим на:
en
en_US
en_US.UTF-8
ru
ru_RU
ru_RU.UTF-8 UTF-8

Запуск:
sudo localepurge
- я высвободил 178+ мегабайт :-)

Запуск служб
sudo systemctl enable NetworkManager

sudo systemctl start vnstat.service

Для ведения лога необходимо сначала создать базу данных нужного интерфейса. Например, для проводного соединения:
sudo vnstat -u -i enp4s0
Или для беспроводного:
sudo vnstat -u -i wlp3s0

NoteCase Pro
Зависимиость gstreamer0.10-base установлена из AUR

Oblogout
Обратите внимание, что настроить oblogout вы можете в конфигурационном файле /etc/oblogout.conf. Например, я поменял тему оформления кнопок на foom, изменив параметр:

buttontheme = foom
Если понадобится, то можно сократить количество кнопок, поменять их быстрые клавиши и выполняемые команды. Мне кажется, что вполне достаточно оставить cancel, suspend, restart и shutdown. 

Автологин с помощью .xinitrc и автозапуск Х после логина
Если используем Zsh, то
cp /etc/zsh/zprofile /home/s-adm/.zprofile && nano  home/s-adm/.zprofile
добавить:
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
выполнить:
sudo systemctl edit getty@tty1
и вставить:
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin s-adm --noclear %I $TERM

GitHub

Все конфиги для ноутбука asus-n76vz можно получить командой
git clone https://github.com/sugry/xmonad-for-asusn76vz

* имя пользователя прописано в конфигурационных файлах, не забудьте проверить и заменить, если будет использовано другое имя пользователя
ВАЖНО! для файла .xinitrc и всех файлов в каталоге .sripts нужно установить права на запуск chmod +x путь_к_файлу
Создано по материалам http://archlinux.org.ru/forum/topic/16692/
