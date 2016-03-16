***
# <p align="center">Xamarin (Zamarin)
####<p align="center">**The Pro Telegram Group Manager**
<p align="center">Created By ♥ In Iran
***

**A Telegram Bot based on plugins using [tg](https://github.com/vysheng/tg) **

## Installation

```bash
# ابتدا با کد زیر بسته پیش نیاز زبان برنامه نویسی لوآ را نصب میکنیم
sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev make unzip git redis-server g++ libjansson-dev libpython-dev expat libexpat1-dev
```

```bash
# را نصب و اجرا میکنیم Bot سپس
cd $HOME
git clone https://github.com/amirhmz/XamarinTG.git
cd XamarinTG
git clone --recursive https://github.com/amirhmz/tg.git
chmod +x ./launch.sh
./launch.sh install
cd tg 
rm lua-tg.c # And Paste Lua-tg.c to tg Folder
make && cd # For Support Sticker Operation
./launch.sh # Enter a phone number & confirmation code.
```
##One Command Installation :) 
```bash
sudo apt-get update; sudo apt-get upgrade -y --force-yes; sudo apt-get dist-upgrade -y --force-yes; sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson* libpython-dev make unzip git redis-server g++ -y --force-yes && git clone https://github.com/amirhmz/XamarinTG.git && cd XamarinTG && ./launch.sh install && ./launch.sh
```
* Note : put lua-tg.c in /root/XamarinTG/tg/ then reboot the server

***
### Realm Configuration

After you run bot for first time,turn it off

create an empty group with it

run it again

obtain that groups id using /id and add its id to realms table in /data/config.lua

```bash
realm = {Your Realm ID},#Realms ID
```
then start the bot again :D

***
## feedback.lua Configuration
After Your Bot Run for first time,turn it off
go to /plugins/feedback.lua and in line 8
Set Your Realm ID in 
User msg Send To This Group :|
```lua
 local chat = "chat#id"..83535263 
   --like : local chat = "chat#id"..12345678
```
CTRL+S For Save it
and start again
***

# Contact Me
| Bot | Channel | Telegram | Email |
|---------|--------|-------| ----- |
| [Bot](https://telegram.me/XamarinTG) | [Join](https://telegram.me/DarkTeam) | [Developer](http://telegram.me/AmirDark) :trollface: | [Email](mailto:amdark77@gmail.com) 

> _If you are using /join service for first time_
>> _you have to send it 11 time ( Bot is spam reported )_

# Enjoy it  ♥ 
