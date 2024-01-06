#!/bin/bash

##################################################################################################################

#First Section
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'
NORMAL='\033[0m'
BIG='\033[5;1m'

##################################################################################################################

#Second Section
echo -e "${GREEN}${BOLD} ---> Update and Upgrade packages <--- ${NORMAL}${NC}"
sudo apt-get update -y
sudo apt-get upgrade -y
echo -e "${BLUE}${BOLD} ---> Done <--- ${NORMAL}${NC}"

echo -e "${RED}############################################################################################################${NC}"

echo -e "${GREEN}${BOLD} ---> Install Apache2 Service <--- ${NORMAL}${NC}"
sudo apt-get install apache2 figlet -y
echo -e "${BLUE}${BOLD} ---> Done <--- ${NORMAL}${NC}"

echo -e "${RED}#############################################################################################################${NC}"

echo -e "${GREEN}${BOLD} ---> Install PHP <--- ${NORMAL}${NC}"
echo -e "${BLUE}Choose what PHP version you need${NC}"
echo "  1) Version8.1"
echo "  2) Version7.4"
echo "  3) Version5.6"
if [ -n "$1" ]; then num=$1
else read -p "Enter your choise: " num
fi
case $num in
  1)
  sudo apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
                sudo add-apt-repository ppa:ondrej/php -y
                sudo apt update -y
                sudo apt-get install libapache2-mod-php8.1 php8.1 php8.1-common php8.1-curl php8.1-dev php8.1-gd php8.1-imagick php8.1-mysql php8.1-mbstring php8.1-zip php8.1-xml php8.1-intl -y
  ;;
  2)
  sudo apt install software-properties-common -y
                sudo add-apt-repository ppa:ondrej/php -y
                sudo apt update -y
                sudo apt-get install libapache2-mod-php7.4 php7.4 php7.4-common php7.4-curl php7.4-dev php7.4-gd php7.4-imagick php7.4-mysql php7.4-mbstring php7.4-zip php7.4-xml php7.4-intl -y
  ;;
  3)
  sudo apt-get install python-software-properties -y
                sudo add-apt-repository ppa:ondrej/php -y
                sudo apt update -y
                sudo apt-get install libapache2-mod-php5.6 php5.6 php5.6-common php5.6-curl php5.6-dev php5.6-gd php5.6-imagick php5.6-mysql php5.6-mbstring php5.6-zip php5.6-xml php5.6-intl -y
  ;;
  *) echo -e "${YELLOW}invalid option${NC}";;
esac

echo -e "${RED}#############################################################################################################${NC}"

#Third Section
echo -e "${GREEN}${BOLD} ---> Create DataBase and User for manage it <--- ${NORMAL}${NC}"
if [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ]; then
    dbname=$2
    userdb=$3
    passworduser=$4
else
    read -p "Enter the name of the database that will be created: " dbname
    read -p "Enter the name of the user that will be created: " userdb
    read -p "Enter a strong password for this user: " passworduser
fi

echo -e "${BLUE}Are you have a remotly MySQL server or you need install it.${NC}"
echo "  1) Install MySQL server"
echo "  2) I have a Remotly server"
if [ -n "$5" ]; then num1=$5
else read -p "Enter your choise: " num1
fi
case $num1 in
  1)
  echo -e "${GREEN}${BOLD} ---> Install Mysql-Server Service <--- ${NORMAL}${NC}"
  sudo apt-get install mysql-server-8.0 -y
  echo -e "${BLUE}${BOLD} ---> Done <--- ${NORMAL}${NC}"

  sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS $dbname;"
  sudo mysql -u root -e "CREATE USER '$userdb'@'%' IDENTIFIED BY '$passworduser';"
  sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$userdb'@'%';"
  sudo mysql -u root -e "FLUSH PRIVILEGES;"

  echo -e "${BLUE}Database '$dbname' and user '$userdb' created successfully.${NC}"
  sudo systemctl restart mysql.service
  echo -e "${BLUE}Restarting MySQL-server${NC}"
  ;;
  2)
  if [ -n "$6" ] && [ -n "$7" ] && [ -n "$8" ]; then
      ipDBMS=$6
      userDBMS=$7
      passwduserDBMS=$8
  else
      read -p "Enter the IP Address of the database remotly Server : " ipDBMS
      read -p "Enter the User admin for login in the database Server : " userDBMS
      read -p "Enter the password of this User: " passwduserDBMS
  fi

  sudo apt-get install mysql-client -y
  sudo mysql -u $userDBMS -h $ipDBMS -p$passwduserDBMS -e "CREATE DATABASE IF NOT EXISTS $dbname;"
  sudo mysql -u $userDBMS -h $ipDBMS -p$passwduserDBMS -e "CREATE USER '$userdb'@'%' IDENTIFIED BY '$passworduser';"
  sudo mysql -u $userDBMS -h $ipDBMS -p$passwduserDBMS -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$userdb'@'%';"
  sudo mysql -u $userDBMS -h $ipDBMS -p$passwduserDBMS -e "FLUSH PRIVILEGES;"
  ;;
  *)
  echo -e "${YELLOW}invalid option${NC}";;
esac


echo -e "${RED}##############################################################################################################${NC}"

#Forth Section
echo -e "${GREEN}${BOLD} ---> Download and extract latest WordPress Package <--- ${NORMAL}${NC}"
if test -f /tmp/latest.tar.gz
then
echo -e "${BLUE}WordPress is already downloaded.${NC}"
else
echo -e "${BLUE}Downloading WordPress${NC}"
cd /tmp/ && wget "http://wordpress.org/latest.tar.gz";
fi

if [ -n "$9" ]; then install_dir=$9
else read -p  "Enter the path for Install WordPress in it: " install_dir
fi
sudo mkdir -p  $install_dir
sudo /bin/tar -C $install_dir -zxf /tmp/latest.tar.gz --strip-components=1
sudo chown -R www-data:www-data $install_dir
sudo chmod -R 755 $install_dir


echo -e "${BLUE}Create WP-config and set DB credentials${NC}"
sudo /bin/mv $install_dir/wp-config-sample.php $install_dir/wp-config.php

if dpkg -s mysql-server-8.0 >/dev/null 2>&1; then
   sudo /bin/sed -i "s/database_name_here/$dbname/g" $install_dir/wp-config.php
   sudo /bin/sed -i "s/username_here/$userdb/g" $install_dir/wp-config.php
   sudo /bin/sed -i "s/password_here/$passworduser/g" $install_dir/wp-config.php
else
   sudo /bin/sed -i "s/database_name_here/$dbname/g" $install_dir/wp-config.php
   sudo /bin/sed -i "s/username_here/$userdb/g" $install_dir/wp-config.php
   sudo /bin/sed -i "s/password_here/$passworduser/g" $install_dir/wp-config.php
   sudo /bin/sed -i "s/localhost/$ipDBMS/g" $install_dir/wp-config.php
fi

sudo bash -c 'cat << EOF >> $install_dir/wp-config.php
define('FS_METHOD', 'direct');
EOF'
echo -e "${BLUE}Wordpress has been successfully installed${NC}"

echo -e "${RED}###############################################################################################################${NC}"

#Fifth Section
echo -e "${GREEN}${BOLD} ---> Configuration of Apache2 <--- ${NORMAL}${NC}"
if [ -n "${10}" ]; then protocol=${10}
else read -p "How Do you need your site works --> HTTP or HTTPS: " protocol
fi
echo -e "${YELLOW}${BIG}hints${NC}"
echo -e "${YELLOW}${BIG}VirtualHost is a configuration file of your WebSite ${NC}"
echo -e "${YELLOW}${BIG}ServerName is a Web address of your WebSite${NC}"
if [ $protocol = 'HTTP' ] || [ $protocol = 'http' ]; then

  if [ -n "${11}" ] && [ -n "${12}" ]; then
      virtualhost=${11}
      servername=${12}
  else
      read -p "Enter VirtualHost file name: " virtualhost
      read -p "Enter ServerName : " servername
  fi

sudo touch /etc/apache2/sites-available/$virtualhost.conf

echo "<VirtualHost *:80>

    ServerName  $servername
    DocumentRoot $install_dir

    <Directory $install_dir>
       Options FollowSymLinks
       AllowOverride All
       Require all granted
    </Directory>

   ErrorLog /var/log/apache2/error.log
   CustomLog /var/log/apache2/access.log combined

</VirtualHost>" | sudo tee /etc/apache2/sites-available/$virtualhost.conf
echo "VirtualHost '$virtualhost' created successfully"
        sudo a2ensite $virtualhost.conf
        echo "Enabled VirtualHost '$virtualhost'"
        sudo a2dissite 000-default.conf
        echo "Disabled default VirtualHost"

elif [ $protocol = 'HTTPS' ] || [ $protocol = 'https' ]; then

        echo -e "${BLUE}Enabled mod-SSl & rewrite${NC}"
        sudo a2enmod ssl
        sudo a2enmod rewrite
        echo -e "${RED}###################################${NC}"
          if [ -n "${13}" ] && [ -n "${14}" ]; then
              virtualhost_ssl=${13}
              servername_ssl=${14}
          else
              read -p "Enter VirtualHost file name for HTTPS: " virtualhost_ssl
              read -p "Enter the ServerName for Website with HTTPS : " servername_ssl
          fi
        sudo touch /etc/apache2/sites-available/$virtualhost_ssl.conf
        
        echo -e "${BLUE}Now, choise method of using HTTPS${NC}"

        echo "  1) I have a Certificate"
        echo "  2) Need a Lets Encrypt Certificate"
        if [ -n "${15}" ]; then num2=${15}
        else read -p "Enter your choise: " num2
        fi
        case $num2 in
                1)
                if [ -n "${16}" ]; then certificate=${16}
                else read -p "Are you have a Certficate locally or have a URL. Write 'local' or 'url': " certificate
                fi
                if [ $certificate = 'local' ] || [ $certificate = 'LOCAL' ]; then
                          if [ -n "${17}" ] && [ -n "${18}" ]; then
                              certlocal=${17}
                              privatekeylocal=${18}
                          else
                              read -p "Enter Path for your Certificate: " certlocal
                              read -p "Enter Path for PrivateKey: " privatekeylocal
                          fi
                        echo "<IfModule mod_ssl.c>
<VirtualHost *:443>
        ServerName  $servername_ssl
        DocumentRoot $install_dir
        <Directory $install_dir>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
        </Directory>

        ErrorLog /var/log/apache2/error.log
        CustomLog /var/log/apache2/access.log combined

        SSLEngine on
        SSLCertificateFile $certlocal
        SSLCertificateKeyFile $privatekeylocal

</VirtualHost>
<IfModule mod_ssl.c>" | sudo tee /etc/apache2/sites-available/$virtualhost_ssl.conf


                elif [ $certificate = 'url' ] || [ $certificate = 'URL' ]; then
                        if [ -n "${19}" ] && [ -n "${20}" ] && [ -n "${21}" ]; then
                            ssl_location=${19}
                            certurl=${20}
                            privatekey=${21}
                        else
                            read -p "please enter ssl path for download certificate in it: " ssl_location
                            echo -e "${YELLOW}please, make sure name of certificate is 'crt.pem' and privateKey is 'key.pem'${NC}"
                            read -p "Enter URL for your Certificate: " certurl
                            read -p "Enter URL for PrivateKey: " privatekey
                        fi
                        sudo mkdir -p $ssl_location
                        cd $ssl_location && sudo wget $certurl && sudo wget $privatekey

                        echo "<IfModule mod_ssl.c>
<VirtualHost *:443>
        ServerName  $servername_ssl
        DocumentRoot $install_dir
        <Directory $install_dir>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
        </Directory>

        ErrorLog /var/log/apache2/error.log
        CustomLog /var/log/apache2/access.log combined

        SSLEngine on
        SSLCertificateFile $ssl_location/crt.pem
        SSLCertificateKeyFile $ssl_location/key.pem

</VirtualHost>
<IfModule mod_ssl.c>" | sudo tee /etc/apache2/sites-available/$virtualhost_ssl.conf
                fi

                echo "VirtualHost '$virtualhost_ssl' created successfully"
                sudo a2ensite $virtualhost_ssl.conf
                echo "Enabled VirtualHost '$virtualhost_ssl'"
                sudo a2dissite 000-default.conf
                echo "Disabled default VirtualHost"
                ;;
                2)
                echo -e "${GREEN}${BOLD} ---> Install Certbot For Create Certificate <--- ${NORMAL}${NC}"
                sudo apt-get install certbot python3-certbot-apache  -y

                echo "<VirtualHost *:80>
        ServerName  $servername_ssl
        DocumentRoot $install_dir
        <Directory $install_dir>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
        </Directory>

        ErrorLog /var/log/apache2/error.log
        CustomLog /var/log/apache2/access.log combined

</VirtualHost>" | sudo tee /etc/apache2/sites-available/$virtualhost_ssl.conf
                        echo -e "${BLUE}VirtualHost '$virtualhost_ssl' created successfully${NC}"
                        sudo a2ensite $virtualhost_ssl.conf
                        echo -e "${BLUE}Enabled VirtualHost '$virtualhost_ssl'${NC}"
                        sudo a2dissite 000-default.conf
                        echo -e "${YELLOW}Disabled default VirtualHost${NC}"
                                        
                        if [ -n "${22}" ]; then mail=${22}
                        else read -p "Enter Email address: " mail
                        fi
                        sudo certbot --apache --agree-tos --no-eff-email --redirect --staple-ocsp --email $mail -d $servername_ssl
                ;;
                *) echo -e "${YELLOW}invalid option${NC}";;
        esac

else
        echo -e "${YELLOW}Invalid Input${NC}"
fi

sudo systemctl restart apache2.service
sudo apt-get update -y
if ! command -v figlet &> /dev/null; then
    (sudo apt-get install figlet -y > /dev/null) &
fi

echo -e "${RED}###############################################################################################################${NC}"

echo -e "${GREEN}${BOLD}The script created by Eng 'Mahmoud Gamal'${NORMAL}${NC}"
printf "Klayytech\nFor\nDigital\nTransformation\n" | figlet
