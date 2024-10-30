#!/bin/bash

until mysqladmin ping -h mariadb --silent; do
    :
done

#This loop keeps running until MariaDB is reachable (i.e., until it responds to a ping command).
#WordPress needs to connect to MariaDB during setup. The script waits for MariaDB to be fully up and running before proceeding with further commands.

#mysqladmin ping -h mariadb --silent: This command attempts to ping the MariaDB server at the host mariadb. The --silent option suppresses unnecessary output, only returning success or failure. (silencing any output from the mysqladmin command.)

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar #download the wp-cli.phar file
#Uses curl to download the wp-cli.phar file (the WP-CLI tool) from GitHub.

chmod +x wp-cli.phar #To use WP-CLI from the command line by typing wp, make the file wp-cli.phar executable

mv wp-cli.phar /usr/local/bin/wp #To use WP-CLI from the command line by typing wp, make the file executable and move it to somewhere in your PATH. Move wp-cli.phar to /usr/local/bin/wp to make it accessible system-wide. This makes the script cleaner and follows standard practices for using CLI tools.
#Moves the wp-cli.phar file to /usr/local/bin and renames it to wp, so it can be used as a command (wp).

wp core download --allow-root #Download WordPress core files. This command runs just before the WP load process begins.
#Downloads the WordPress core files using WP-CLI into /var/www/html.
#--allow-root: Since the script is running as root, this flag avoids permission issues.

# Create the wp-config.php file
wp config create --dbname=$DB_NAME --dbuser=root --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --allow-root #Generates and reads the wp-config.php file.
#Creates the wp-config.php file with the provided database credentials ($DB_NAME, $DB_PASSWORD, $DB_HOST). This file connects WordPress to the MariaDB database.
#WordPress needs this configuration file to know how to connect to the database.

#--dbname=<dbname> Set the database name.
#--dbuser=<dbuser> Set the database user.
#--dbpass=<dbpass> Set the database user password.
#--dbhost=<dbhost> Set the database host.—default: localhost

wp db create --allow-root #Create the WordPress database.
#Uses WP-CLI to create the database where WordPress will store its data. It uses the credentials and information from the wp-config.php file.

#Install WordPress with administrator details
wp core install --url=$URL --title=$TITLE --admin_user=$ADMIN_NAME --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL --allow-root
#Install WordPress. Runs the standard WordPress installation process.
#Installs WordPress by:
#Setting the site’s URL ($URL).
#Providing the site’s title ($TITLE).
#Creating an admin user with the credentials ($ADMIN_USER, $ADMIN_PASSWORD, $ADMIN_EMAIL).

#This step completes the WordPress installation, making it ready for use.

#--url=<url> The address of the new site.
#--title=<site-title> The title of the new site.
#--admin_user=<username> The name of the admin user.
#--admin_password=<password> The password for the admin user. Defaults to randomly generated string.
#--admin_email=<email> The email address for the admin user.


## Add another user (non-admin) after installation
wp user create $USER2_NAME $USER2_EMAIL --user_pass=$USER2_PASSWORD --role=author --allow-root

exec php-fpm7.4 -F
#In Docker containers, each container typically starts with a shell process (like /bin/bash) or a shell script (script.bash) as the initial process. This shell or script process gets assigned PID 1, which is the first and most important process in a container or Linux system. The exec command is used to replace the shell (or the current script) with another process without creating a new subprocess.
#When you use the exec command, it replaces the current shell or script (which is PID 1) with the specified program (in this case, php-fpm7.4 -F), making that program PID 1 directly.
#This means the shell or script terminates and no longer exists as a separate process; only the new program (PHP-FPM) is running, and it now controls the container as PID 1.
#Without exec: If you just ran php-fpm7.4 -F inside the script without exec, the script would stay running as PID 1, and php-fpm7.4 would be a child process. If the shell or script finishes or encounters an error, it could cause issues, and Docker might stop the container even though PHP-FPM is still running.

#Runs the php-fpm7.4 service in the foreground using the -F flag.
#Replaces the current script with the PHP FastCGI Process Manager (exec), making it the main process.
#Running PHP-FPM in the foreground ensures the container keeps running and can handle PHP requests from the web server (NGINX) for the WordPress site.

#Start PHP-FPM. run PHP-FPM version 7.4 in the foreground mode (-F option) to keep the process running as the main process of the script.
#Debian Bullseye, by default, comes with PHP 7.4 in its official repositories.
#FastCGI Process Manager) will create and write its PID file in the directory /run/php/
#The PID file is necessary for tracking the running PHP-FPM process. 
#php-fpm7.4 -F is a process started by the script, so it will have a different PID (likely PID 2 or higher).
#Since the script itself is PID 1, PHP-FPM (which is started by the script) will not be PID 1; instead, it will be a child process of the script.
#when you want to stop a service, the system reads the PID file to know which process to kill.

#Docker containers are designed to stop running once their primary process (PID 1) exits.
# In Docker, containers expect the main process (in this case, the script running php-fpm) to keep running. If you ran PHP-FPM in the background (without -F), the script would finish, and Docker would interpret this as the container no longer having anything to run, so the container would exit. Running PHP-FPM in the foreground ensures the container remains active and doesn't exit prematurely.
#Keep php-fpm Alive: If you run php-fpm in the background, the parent script would complete, and Docker would think the container is done. By running it in the foreground (-F), the process keeps running and managing PHP requests for WordPress.

#In a Docker environment, where php-fpm7.4 -F runs in the foreground as the main process (PID 1), Docker itself handles all the process management. The need for a PID file is eliminated because:
#Docker automatically tracks and manages the main process (PID 1ƒ).
#Running PHP-FPM in the foreground (-F) ensures the container stays alive as long as PHP-FPM is running.
#There's no need for external process management using a PID file in a containerized setup.

#The shell process is not "killed", but it is no longer a shell. It becomes php-fpm7.4.
#No new process is created; the shell transforms into php-fpm7.4 by loading the new program into the same process space.
#If you didn’t use exec and just ran php-fpm7.4 -F as a regular command, the script would still be PID 1, and php-fpm7.4 would run as a child process of the script. Once the script finishes, the shell process (PID 1) would exit, and Docker would stop the container, even though php-fpm7.4 was still running.
#The script executes various commands, but as long as they are not using exec, they run as child processes of the main shell (PID 1). The shell process waits for each command to complete before moving on to the next one.




















