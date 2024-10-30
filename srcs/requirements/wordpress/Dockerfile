FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y php-fpm php-mysqli curl mariadb-client
#php-fpm: FastCGI Process Manager for handling PHP requests.
#php-mysqli: PHP extension for connecting to MySQL/MariaDB databases.
#curl: Command-line tool for making web requests (used to download WP-CLI).
#mariadb-client: Client for interacting with the MariaDB server.
#These packages are required to run WordPress, communicate with the database, and interact with external services.

#PHP-FPM (FastCGI Process Manager): A common PHP application server that works with web servers like NGINX or Apache to run PHP code

#Install Necessary Packages: 
    #Install PHP along with necessary extensions like MySQLi, which WordPress requires to interact with the database.
    #Install a database client (e.g., mariadb-client or mysql-client) to allow the container to connect to a database.
    #The database client (e.g., mariadb-client or mysql-client) installed in your WordPress Docker container will act as the client. The client allows the WordPress container to connect to and interact with a database server (such as MariaDB or MySQL) hosted either within another Docker container or on a separate server.
    #Install curl to download necessary files like WP-CLI.

    #You have two containers: one for WordPress and another for MariaDB.
    #The WordPress container has mariadb-client installed.
    #The WordPress container uses this client to connect to the MariaDB server container via the network.

RUN echo "listen=0.0.0.0:9000" >> /etc/php/7.4/fpm/php-fpm.conf
#Modifies the PHP-FPM configuration file to make it listen on 0.0.0.0:9000 (all interfaces, port 9000).
#PHP-FPM needs to listen on a specific IP and port to handle incoming requests from the web server (e.g., NGINX).
#In this case, it is configured to listen on all interfaces (0.0.0.0) and port 9000.

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#Uses curl to download the wp-cli.phar file from GitHub, which contains WP-CLI, the command-line tool used to manage WordPress installations.

RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp 
#wp-cli.phar is in fact the CLI. move it into your global bin so all users in your machine can trigger it.
#Moves the wp-cli.phar file to /usr/local/bin and renames it to wp, making it accessible as a command (wp) from anywhere in the container.


COPY tools/script.bash /script.bash
#Copies a script called script.bash from the local tools directory on the host machine into the container’s root directory (/script.bash).

RUN chmod +x /script.bash
#Changes the permissions of script.bash to make it executable.

RUN mkdir -p /run/php 
# Creates a directory /run/php inside the container, where PHP-FPM will store its PID (Process ID) file.
#PHP-FPM needs this directory to store its runtime information, such as the PID file. Without this, PHP-FPM might fail to start.
#PHP-FPM fastCGI will create the PID file in /run/php/. so This ensures that the directory is created when the container is built so we are sure it exist at runtime 
#wordpress  | [14-Sep-2024 20:05:55] ERROR: Unable to create the PID file (/run/php/php7.4-fpm.pid).: No such file or directory (2)

WORKDIR /var/www/wordpress
#Changes the current working directory to /var/www/wordpress. All subsequent commands will be executed relative to this directory.
#Setting a working directory in your WordPress Docker container is a best practice that simplifies file operations, ensures commands are run in the correct context, organizes your container's filesystem, and aligns with web server configurations. Web servers like NGINX or Apache typically serve files from a specific directory, such as /var/www/html or /var/www/wordpress. Setting the working directory to this path aligns your environment with the web server's configuration, ensuring that WordPress is served correctly.
#This is the directory where WordPress files are typically stored.

#run the php-fpm service in the foreground using the command line -F (Force to run in background and ignore daemonize option from configuration file.)

CMD ["/script.bash"]
#Specifies the command to be run when the container starts. In this case, it runs the /script.bash script.
#Why it’s important: This script likely handles additional configuration or setup for WordPress, such as installing WordPress, setting up the database, and starting PHP-FPM in the foreground.
#The process that is started with CMD or ENTRYPOINT in the Dockerfile is usually the PID 1 inside the container, and it is responsible for handling signals like SIGTERM or SIGKILL.
#the PID 1 inside the container will be the process that runs the script.bash.


