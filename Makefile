#The Dockerfiles must be called in your docker-compose.yml by your Makefile.

build:
	docker-compose -f srcs/docker-compose.yml build
# When you want to build the images first and start the containers separately later or when you want to ensure that the images are built correctly without running the services right away.

upb:
	docker-compose -f srcs/docker-compose.yml up --build -d
# Use case: When you want to ensure that the containers use up-to-date images, especially if you have made changes to the Dockerfile or the dependencies of your services.
up:
	docker-compose -f srcs/docker-compose.yml up -d
#Use case: When you want to start your containers without forcing a rebuild of the images, and you are confident that the images are already built or pulled.
down:
	docker-compose -f srcs/docker-compose.yml down 

clean:
	docker-compose -f srcs/docker-compose.yml down -v --rmi all
	rm -rf /home/khanhayf/data/*data
