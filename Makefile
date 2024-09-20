.DEFAULT_GOAL := help

colon := :
$(colon) := :

COMPOSEFILE=docker-compose.yml

help:
	@ echo "Open 'makefile' to see what targets there are"
	@ echo "'make up' to create everything. 'make down' do take everything down'"


setup:
	bundle

infra:
	docker-compose -f ${COMPOSEFILE} up -d

migrate: infra
	scripts/migrate.sh

up: setup infra
	bundle exec rails s -b 0.0.0.0 -p 3000
down:
	docker-compose -f ${COMPOSEFILE} stop
	docker-compose -f ${COMPOSEFILE} down

clean: down
	docker kill $(docker ps -q) || echo "return 0"
	docker rm $(docker ps -a -q) || echo "return 0"
	docker volume rm $(docker volume ls -q) || echo "return 0"
	docker system prune
