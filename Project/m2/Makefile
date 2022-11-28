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
clean:
	docker rm -f `docker ps -a | grep "docker_mongo" | cut -f "1" -d ' '`
	docker rm -f `docker ps -a | grep "docker_checker" | cut -f "1" -d ' '`
	docker image rm -f `docker image ls | grep "docker_mongo" | tr -s ' ' | cut -f "3" -d ' '`
	docker image rm -f `docker image ls | grep "docker_checker" | tr -s ' ' | cut -f "3" -d ' '`
