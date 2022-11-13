build:
	docker-compose build

start: build
	#docker-compose up -d
	docker-compose run checker /usr/bin/bash -c '/wait && source ~/dlang/dmd-2.100.2/activate && dub run'

mongosh:
	docker-compose exec mongo mongosh mongodb://root:example@mongo:27017/

attach-to-logs:
	docker-compose logs -f mongo

.PHONY: clean
clean:
	docker rm -f `docker ps -a | grep "docker_mongo" | cut -f "1" -d ' '`
	docker image rm -f `docker image ls | grep "docker_mongo" | tr -s ' ' | cut -f "3" -d ' '`
