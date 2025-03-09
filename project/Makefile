NAME = inception

all: up

up:
	cd srcs && docker-compose up --build

down:
	cd srcs && docker-compose down

clean:
	docker system prune -af --volumes

fclean: clean
	if [ -n "$$(docker images -q)" ]; then docker rmi $$(docker images -q); fi
	sudo rm -rf /home/florent/inception/project/data/mariadb/*
	sudo rm -rf /home/florent/inception/project/data/wordpress/*

re: fclean all
