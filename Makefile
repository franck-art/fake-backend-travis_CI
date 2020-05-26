# le fichier makefile permet de construire notre projet
# en regles et appliquer les actions sur les cibles
# declaration de variables

IMAGE =  franckjunior/fake-backend:travis

# Regles

reseau: 
	docker network create  network_game

volume:
	docker volume create mysql_data


image:
	docker build -t $(IMAGE) ./fake-backend


run:
	docker-compose up -d
        # To let the container start before run test
	sleep 5s
	docker ps 
test:

	if [ "$$(curl -X GET http://localhost:80/health)" = "ok" ]; then echo "test OK"; exit 0; else echo "test KO"; exit 1; fi
	echo "fin test"

clean:
	docker rm -vf  battlegame dbgame
	docker-compose down -d

push-image:
	docker push $(IMAGE)

.PHONY: volume reseau image run test clean push-image
