FROM debian:bullseye
#This line tells Docker to use the debian:bullseye image as the base image for your new image.
#The base image is like the starting point. In this case, it`s a minimal version of the Debian operating system, specifically the "bullseye" release.

RUN apt update && apt install -y nginx openssl
#RUN: This keyword tells Docker to execute the following commands inside the container during the build process(the creation of a Docker image based on instructions in a Dockerfile). But during the build process, the final container hasn't been created yet, so docker uses temporary containers to run RUN commands, applying the changes to the image. These containers are discarded after each command, and the final image is built step by step.

#Installs the NGINX web server and OpenSSL (a toolkit for handling secure communications)on top of the Debian base image.

#openssl is a tool for generating SSL certificates. 
#openssl is a software library and command-line tool used to apply the SSL/TLS protocols in applications. 
#It includes utilities for managing certificates, encrypting/decrypting data, and setting up secure communications (encrypt data between clients (e.g., browsers) and servers.). 
#SSL/TLS are cryptographic protocols used to secure communication over a network. 

#When a client (like a web browser) initiates a secure connection with a server, it sends a "Client Hello" message, which includes the list of encryption methods it supports, including TLS versions and cipher suites. The reason the client lists the TLS versions it supports is to ensure that both the client and server can communicate using a mutually compatible version of the TLS protocol.
#Not all servers or clients support the latest TLS versions. The client needs to tell the server which versions it can work with, to ensure a secure connection.
#The client lists the TLS versions it supports so that the server can select a mutually compatible version, ensuring that they both can communicate securely using the highest, safest available version of the protocol.
#Example Scenario:
#Client supports: TLS 1.3, TLS 1.2, and TLS 1.1.
#Server supports: TLS 1.3 and TLS 1.2.
#In this case, the server will choose TLS 1.3 (the highest version both support), and the connection will proceed using TLS 1.3.
#If the server only supported TLS 1.2, it would choose that, and the communication would continue securely using TLS 1.2. If there's no overlap between supported versions, the connection fails, and no secure session is established.

#nginx is a proxy server, it handles requests from clients (like browsers or apps) and forwards them to one or more backend servers, such as application servers (e.g., Node.js, PHP, etc.) or database servers.
#NGINX, acting as a proxy, forwards client requests to the WordPress container, which may interact with MariaDB when necessary.
#NGINX is used as a proxy server, the backend servers are:

#WordPress container: This is your application server. It handles the actual web application (WordPress site), processing requests for pages,#posts, and other content.
#MariaDB container: This is your database server. It stores all the data for your WordPress site, such as posts, comments, user accounts,etc. The WordPress container communicates with MariaDB to retrieve or store data.

COPY conf/nginx.conf /etc/nginx/sites-available/default
#The COPY command in a Dockerfile copies files into the Docker image during the build process, not the container.
#COPY adds the file to the image during the build process, and when you run a container from that image, the file is available inside the container.
#This is necessary when you want to include configuration files, code, or other assets inside the container so they can be used by the application running in the container.

#copies your custom NGINX configuration nginx.conf from your local machine into the image's /etc/nginx/ directory.

#Informs Docker that the container listens on port 443 at runtime.
#This line tells Docker that the container will listen on port 443 for network traffic.
#port 443 is the default port for HTTPS traffic, which is secure web traffic. This step is essential for making sure the container can handle secure connections.

# EXPOSE 443 #no need
#inform Docker that the container will listen on a specific network port at runtime. It doesn't actually make the port accessible from the host machine or the outside world; it simply marks the port as a potential point of communication.
#EXPOSE 443 in an NGINX Dockerfile indicates that the container is expected to listen on port 443. This is the standard port for HTTPS traffic.


RUN mkdir -p /etc/nginx/ssl
#CMD runs when the container is launched. (starts)

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=MA/ST=BeniMellal/L=Khouribga/O=42/OU=42/CN=khanhayf.42.fr"
#-req: used when you want to output a self-signed certificate instead of a CSR. req command in OpenSSL is used to create and process certificate signing requests (CSRs). It is often used for generating self-signed certificates for testing, development, or internal purposes where a trusted CA is not required.
#Certificate Signing Request (CSR):
#It is typically sent to a Certificate Authority (CA) as a request for an SSL/TLS certificate.
#Results in a certificate that can be signed by a CA, which is trusted by browsers and systems.
#Used when you need a certificate for a public-facing service that should be trusted by all users.
#It allows you to encrypt traffic between your browser and NGINX (e.g., HTTPS) without relying on external certificate authorities, which is sufficient for your Docker-based project setup.

#Self-Signed Certificate:
#A self-signed certificate is a certificate that is signed by the entity that created it, rather than by a CA. It contains the same information as a regular certificate but is not verified by a third party.
#You generate a private key and create a certificate that is immediately signed with that key.
#Used for private, internal, or development environments where public trust is not needed.
#Because the certificate is self-signed, Not trusted by default; no CA is involved.  No validation process; it’s trusted only if manually configured to be trusted..
#Self-Signed Certificate: A developer sets up a test server on test.example.com and creates a self-signed certificate to enable HTTPS for testing purposes. Users accessing the test site must manually trust the certificate to avoid warnings.

#When -x509 used with the req command, the -x509 option causes OpenSSL to produce a self-signed certificate directly, bypassing the creation of a CSR.
#Trusted certificates are essential when you need to ensure public trust (e.g., on a production website), but for internal or local use, a self-signed certificate works fine.
#A trusted CA certificate is required for websites and servers that are accessible by the general public to ensure browsers and clients trust the server’s identity.

#-nodes: Skips the option to encrypt the private key. If you omit this, you'll be prompted for a passphrase when using the key.
#-nodes option is used during the process of generating a private key and a certificate (or CSR) to specify that the private key should not be encrypted.
#If you don’t use the -nodes option, OpenSSL will ask you to provide a passphrase when generating the private key. This passphrase encrypts the private key file, adding an extra layer of security. This means that every time your server uses this private key (for example, when starting the server or establishing a secure connection), you will need to provide the passphrase.
#Not encrypting the private key (-nodes) can make development and testing easier because you don’t need to enter a passphrase every time the server starts. This can be useful in automated environments or scripts.

#When you generate a self-signed certificate, you create both a private key and a corresponding public key.
#The private key is used to sign the self-signed certificate, and the public key is included in the certificate itself.
#This private key is yours and is used to prove that the certificate was created by you. It should be kept secure.

# In the case of certificates issued by a CA, the CA has its own private key. The CA uses its private key to sign certificates issued to others.
# The CA’s private key is a critical component of the CA’s security and is used to create trust in the certificates it issues.
# When you obtain a certificate from a CA, it is signed by the CA's private key, and the CA's public key (often distributed in a CA certificate) is used to verify the signature.

#-out: Specifies where to save the main output file, which could be a CSR, a certificate, or another type of output depending on the command.
#-keyout inception.key: Specifies the output file for the private key. -keyout option is used to specify the file where the private key should be saved.
#-subj: specify the subject of a certificate in a one-line string format. -subj option allows you to set the distinguished name (DN) of the certificate in a concise manner. The distinguished name includes information such as the common name (CN), organization (O), organizational unit (OU), country (C), state (ST), and locality (L).
#-keyout /etc/nginx/ssl/inception.key specifies where to save your private key.
#-out /etc/nginx/ssl/inception.crt specifies where to save your self-signed certificate.


#in the case of a self-signed certificate, the administrator does not send it to a Certificate Authority (CA). The whole point of a self-signed certificate is that it is created, signed, and used by the same entity, without involving a trusted third-party CA.
CMD ["nginx", "-g", "daemon off;"] 
#=docker run nginx nginx -g "daemon off;"
#In a container, the first process (PID 1) is whatever command you specify in the ENTRYPOINT or CMD in the Dockerfile. In your case, if you're running Nginx in the foreground, Nginx will be PID 1 inside that container.

# Specifies the command to run NGINX in the foreground when the container starts.
#the directive daemon off; tells Nginx to run in the foreground (not as a daemon) (A daemon is a background process that runs on a computer system, typically without direct interaction from users.)
#This line sets the command that will run when the container starts. It tells the container to start the NGINX web server with the option -g "daemon off;"
#nginx: The command to start the NGINX web server.

#-g "daemon off;": This option tells NGINX to run in the foreground (not as a background process). Running in the foreground is typical in Docker containers to keep the container running.
#This is the command that keeps the container running and serving web traffic. If this command finishes or fails, the container stops.
# Run the NGINX server in the foreground to keep the container running and serving web traffic.

#If your project needs a process running in the background to handle tasks continuously (like a web server responding to HTTP requests), using a daemon is necessary.
#Example: If you are building a web service, the web server (like NGINX) will run as a daemon.
#In your case, if you're building a system like a WordPress setup with NGINX and MariaDB, you are already using daemons like nginx and mariadbd since these services must continuously handle web and database requests.

#Docker containers are tied to the lifecycle of the process they run. If the main process inside the container exits, the container stops. By keeping the main process (like NGINX or MariaDB) in the foreground, the container stays alive.
# Running daemons in the background (traditional mode) would cause the container to stop unexpectedly.
# Docker containers are meant to run a single main process in the foreground. When that process exits, the container stops.
# If you let a service run in the background (daemon mode), the main process (that is, the service itself) will exit immediately, and Docker will think that the container is no longer running anything, so it will stop the container.
# By running daemons in the foreground, you ensure that the process stays active and the container keeps running.




#------
    #The client says "Hello" and requests a secure connection.
    #The server sends its public key in its certificate.
    #The client generates a random Pre-Master Secret, encrypts it with the server’s public key, and sends it to the server.
    #The server decrypts the Pre-Master Secret using its private key.
    #Both the client and server create the same session key from the Pre-Master Secret, which they use to securely communicate for that session.
    #The session key ensures that all the communication that follows between the client and server is encrypted and secure, but it's only valid for the current session.

