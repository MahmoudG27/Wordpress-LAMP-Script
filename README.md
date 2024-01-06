## LAMP Script:
* This script automates the installation process for Apache2, PHP, MySQL, and WordPress on Ubuntu or Debian distribution.
* It simplifies the setup of a web server environment for hosting WordPress websites.
* The script installs Apache2 as the web server, PHP as the server-side scripting language, and MySQL as the database management system.
* It provides options to choose between HTTP or HTTPS configuration for the web server.
* The script supports multiple versions of PHP, allowing you to select the desired PHP version during installation.
* The script installs WordPress, the popular content management system, and sets up the necessary configuration files.
* It generates a secure MySQL database and user for WordPress.
* The script guides you through the installation process, prompting for necessary information such as website name, admin username, and password.
* Once installed, the script provides instructions on how to access and manage your WordPress website.

***
# Predefined Variables:
* If you Need Pass Values of Variables you can pass them when you running Script by using Predefined Variables.
* Predefined Variables are variables known to the shell and their values are assigned by the shell.
* $#  --->  Number of arguments
* $*  --->  List of all arguments
* $0  --->  Script Name
* $1, $2, ...  --->  First argument, second argument, ...

***

# Function of all Predefined Variables:

$1 = (variable num) for choose PHP Version
#######################################################

$2 = (variable dbname) for MySQL DB will be created
$3 = (variable userdb) for MySQL DB user will be created
$4 = (variable passworduser) for Password of user MySQL DB will be created
$5 = (variable num1) --> (1) for choose install MySQL

$5 = (variable num1) --> (2) for choose use remotly MySQL server
$6 = (variable ipDBMS) for IP remotly MySQL server
$7 = (variable userDBMS) for admin user remotly MySQL server
$8 = (variable passwduserDBMS) for Password admin user remotly MySQL server
#######################################################

$9 = (variable install_dir) for choose location install wordpress in it
#######################################################

$10 = (variable protocol) for choose HTTP or HTTPS
#On HTTP
$11 = (variable virtualhost) for configuration file of your WebSite
$12 = (variable servername) for Web address of your WebSite
###############
#On HTTPS
$13 = (variable virtualhost_ssl) for configuration file of your WebSite
$14 = (variable servername_ssl) for Web address of your WebSite
$15 = (variable num2) --> (1) if you have a certificate HTTPS
$15 = (variable num2) --> (2) if you need create a Lets encrypt certificate
$16 = (variable certificate) for choose you have certificate locally or remotly
$17 = (variable certlocal) for Path for your Certificate
$18 = (variable privatekeylocal) for Enter Path for your privatekey
$19 = (variable ssl_location) path for download certificate in it
$20 = (variable certurl) URL for Certificate
$21 = (variable privatekey) URL for PrivateKey
$22 = (variable mail) Email address for create ssl certificate

***

# In first section:
* Setting the color and Bold Font variables.

# In second section:
* Make update and upgrade packages.
* Install Apache2 and PHP.
* In PHP There's more than version.

# In third section:
* Creating WordPress database and User for manage this database.
* After create DB & user can choose if you need download MySQL-server Version 8.0 or you have a Remotely Server.
* A WordPress database stores all the data that makes up a WordPress website, including login credentials, pages, posts, themes, and plugins.

# In forth section:
* Download and extract latest WordPress Package.
* Create WP-config file and set database credentials.

# In fifth section:
* Make configuration of Apache2 and choise any protocol you need your Website it will run on.
* When choise HTTP protocol You'll only enter VirtualHost (configuration file of your WebSite) and ServerName (Web address of your WebSite). and The Script will complete the rest.
* When choise HTTPS protocol You'll enter VirtualHost & ServerName, too. but here you choise the way of enter Certificate.
in first option you have a certifcate here you must enter the location of certificate whether it locally or on the Internet.
in second option the script will be generate let's Encrypt certificate.
