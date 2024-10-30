#! /bin/bash

echo Mariadb is now starting!

service mariadb start
#service: This command is used to manage services (like starting, stopping, or restarting them) on systems that use the init system. (The init system is a critical part of an operating system that manages the starting, stopping, and managing of services (or daemons) after the system boots.)
#The init system is one of the most important components of an operating system (OS). It is the first process started by the kernel once the system boots up and is responsible for initializing the system, starting essential services, and managing system processes.
#It is responsible for starting and stopping services, as well as managing the lifecycle of processes in the system.
#It is often referred to as PID 1, because it's the first process that runs and it controls all other processes on the system.
#It ensures services are properly stopped when the system shuts down or reboots.

#When the operating system boots up, the init system takes over:
#Kernel Boots: The kernel loads into memory and initializes hardware.
#Init System Starts: The kernel starts the init system as the first process (PID 1).
#Starts Services: The init system runs scripts or unit files to start essential services like:
#Network services (to get internet connectivity).
#Filesystem services (to access storage).
#Logging services (to track what’s happening on the system).
#User sessions (to allow users to log in).
#Manages Processes: The init system continuously monitors services. For example, if a service crashes, the init system can restart it.

#Some specialized environments, like containers or microkernels, may not require a full init system because their design minimizes the need for complex process management.
#Containers (like Docker containers): Many containers don’t need a full init system because they typically run a single application or service. The container's main process may not be init but rather the application itself. However, some containers use lightweight init systems like tini or runit to handle process management and signals.

#mariadb: The name of the service you want to manage
#start: This tells the service command to start the MariaDB server. This means the MariaDB server will begin running and will start listening for database connections.


mysqladmin -u root password $DB_PASSWORD
#mysqladmin: This is a command-line utility for performing administrative tasks on a MySQL or MariaDB server, like setting a password.
#-u root: (u username) This option specifies the user as root, which is the default administrative user for MariaDB.
#password $DB_PASSWORD: This command sets the password for the root user to the value of the environment variable DB_PASSWORD.


mysql -e "rename user 'root'@'localhost' to 'root'@'%'" || true
#mysql -e: This runs a command directly on the MariaDB server using the mysql command-line client. The -e option allows you to execute a specific SQL query.
#"rename user '$DB_USERNAME'@'localhost' to '$DB_USERNAME'@'%'": This SQL command renames a user in the MariaDB server.
#The user $DB_USERNAME (the value of the DB_USERNAME environment variable) is being changed from being associated only with localhost to being associated with any host (%).
#This means the user can connect from any IP address, not just the local machine.
#|| true: This is a bash construct that ensures that if the mysql command fails (for example, if the user doesn't exist yet), the script will not stop executing. The || true makes the script continue running even if there's an error.

service mariadb stop
#This command stops the MariaDB service.
#After making the necessary changes (setting the root password and renaming the user), the script stops the MariaDB server. This might be done to prepare for restarting it in a different mode or configuration.
#By stopping the server, the script can ensure that the MariaDB service is in a clean state before restarting it in the final, production-ready configuration. This is particularly important if any previous operations (like setting passwords or renaming users) might have left the server in an inconsistent state.

#Why Stop the First Process?
#Clean Transition: Stopping the initial process ensures a clean transition from the setup mode to the final running mode. This avoids any potential conflicts or issues that might arise from trying to reconfigure a running server.
#Configuration Changes: Some changes, like binding to a specific network interface (--bind-address=0.0.0.0), require a server restart to take effect. Stopping the server and starting it with these new options ensures they are applied correctly.
#Different Operational Mode: The initial process might have been started with minimal options just to get the database up and running for setup. The final process, started with mysqld_safe, is configured for normal operation, with better stability and error handling.
#After making changes like setting the root password and renaming the user, the MariaDB service is stopped to ensure that any configuration changes can be properly applied when the server is restarted.

exec mysqld_safe --port=3306 --bind-address=0.0.0.0
#(mysqld_safe):the MariaDB server process 
#exec: Replaces the current script process with the MariaDB server process. This means that the script will no longer be running once mysqld_safe is started. Instead, the MariaDB server process (mysqld_safe) will take over and become the main process.
#Why Use exec?: Using exec here ensures that the mysqld_safe process is the only process running in the container or environment, which can be useful for containers or scripts that expect a single, long-running process. It also ensures that when mysqld_safe exits, the entire script or container will stop.
#mysqld_safe: Starts the MariaDB server with additional safety features.
#Why Use mysqld_safe?: This command is typically used in production environments to ensure that the database server runs reliably. If the mysqld process crashes, mysqld_safe will restart it, which is crucial for keeping the database service available.
#--port=3306: Specifies that the server should listen on port 3306 for incoming connections. Port 3306 is the default port for MariaDB/MySQL.
#--bind-address=0.0.0.0: Configures the server to listen on all available network interfaces. the server is configured to accept connections from any network interface on the machine, making it accessible from any IP address that can reach the server. 

#exec mysqld_safe:

#The exec command replaces the current shell process (/bin/bash script) with the mysqld_safe process. This means that mysqld_safe effectively becomes the main process of the container, taking over as PID 1.
#mysqld_safe is a script that starts the MariaDB server (the mysqld process) and keeps it running. It monitors the server and restarts it if it crashes, which is why it's commonly used to ensure MariaDB stays active.
#Container Keeps Running:
#
#Since mysqld_safe runs continuously, managing the MariaDB server, the container keeps running as long as mysqld_safe is running.
#If the mysqld_safe process were to stop (e.g., MariaDB crashes), the container would also stop because mysqld_safe is the main foreground process keeping the container alive.

#Script Workflow:
#The script prints a message (Mariadb is now starting!).
#It starts the MariaDB service in the background with service mariadb start.
#It sets the root password and renames the user.
#It stops the MariaDB service to prepare for launching MariaDB in the foreground.
#Finally, the exec mysqld_safe command runs MariaDB in the foreground, keeping the container running.

#Script: Handles the runtime phase, where the installed software is executed, configurations are applied, and services are started.