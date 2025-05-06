NAME = inception

$(NAME): up

all: up

up: 
	docker compose -f docker-compose.yml up --build -d

down:
	docker compose -f docker-compose.yml down

clean: down
	docker system prune -a

fclean: clean
	docker volume rm -f miaou $$(docker volume ls -q)

re: fclean all

.PHONY: all up down clean fclean re