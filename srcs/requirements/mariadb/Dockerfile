
FROM debian:bullseye
#Although containers share the host system's kernel, they still require a user space environment to run applications.


RUN apt update -y
RUN apt upgrade -y
RUN apt install -y mariadb-server
#MariaDB is an open-source relational database management system (RDBMS). It is a software application that helps you create, manage, and interact with databases.
#MariaDB Server is the component of MariaDB that runs as a background process (a "service") and listens for incoming database requests from clients.
#MariaDB Server refers to the part of MariaDB that acts as a server, handling requests to create, read, update, and delete data in the databases it manages.
#installs the MariaDB server, a popular open-source database

COPY tools/setup_db.bash /setup_db.bash
#setup_db.bash file typically contains bash commands that are executed when initializing a database. This file is often used to set up the database schema, populate tables with initial data, or configure database settings.

RUN chmod +x /setup_db.bash

CMD ["/setup_db.bash"]
#It tells Docker to run the setup_db.bash script, which was copied into the /root directory



#Dockerfile: Handles the build phase, where software is installed and configured so the container is ready to run.