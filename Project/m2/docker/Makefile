build:
	docker-compose build

start: build
	docker-compose up checker

mongosh:
	docker-compose exec mongo mongosh mongodb://root:example@mongo:27017/

attach-to-logs:
	docker-compose logs -f mongo

stop:
	docker-compose down

.PHONY: clean
clean: stop
	docker rm -f `docker ps -a | grep "mongo" | cut -f "1" -d ' '`
	docker rm -f `docker ps -a | grep "checker" | cut -f "1" -d ' '`
	docker rm -f `docker ps -a | grep "rest_api" | cut -f "1" -d ' '`
	docker image rm -f `docker image ls | grep "mongo" | tr -s ' ' | cut -f "3" -d ' '`
	docker image rm -f `docker image ls | grep "checker" | tr -s ' ' | cut -f "3" -d ' '`
	docker image rm -f `docker image ls | grep "rest_api" | tr -s ' ' | cut -f "3" -d ' '`
