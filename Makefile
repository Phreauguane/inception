NAME = inception
DOMAIN_NAME = jde-meo.42.fr

$(NAME): up

all: up

up:
	docker compose -f srcs/docker-compose.yml up --build -d

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	echo "y\
	" | docker system prune -a

fclean: clean
	docker volume rm -f miaou $$(docker volume ls -q)

re: fclean all

.PHONY: all up down clean fclean re