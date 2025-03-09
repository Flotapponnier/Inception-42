NAME = inception

all: up

up:
	cd srcs && docker-compose up --build

down:
	cd srcs && docker-compose down

clean:
	docker system prune -af --volumes

fclean: clean
	docker stop $$(docker ps -a -q)
	docker rm $$(docker ps -a -q)
	docker rmi $$(docker images -q)
	docker volume rm $$(docker volume ls -q)
	(docker network rm $$(docker network ls -q) || true) 2>/dev/null
	sudo rm -rf /home/ftapponn/data/mariadb/*
	sudo rm -rf /home/ftapponn/data/wordpress/*

re: fclean all

