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
	docker run --name dbgame -v mysql_data:/var/lib/mysql -p 3306:3306 -e  MYSQL_ROOT_PASSWORD=rootpwdgame -e  MYSQL_DATABASE=battleboat -e MYSQL_USER=battleuser -e  MYSQL_PASSWORD=battlepass --network network_game -d mysql:5.7
	docker run --name battlegame -v ${PWD}/battleboat:/etc/backend/static -p 8282:3000 -e  DATABASE_HOST=dbgame -e  DATABASE_PORT=3306 -e  DATABASE_USER=battleuser -e DATABASE_PASSWORD=battlepass -e DATABASE_NAME=battleboat  --network network_game -d  $(IMAGE)

        # To let the container start before run test
	sleep 5
	docker ps 
test:

	if [ "$$(curl -X GET http://127.0.0.1:8282/health)" = "200" ]; then echo "test OK"; exit 0; else echo "test KO"; exit 1; fi
	echo "fin test"

clean:
	docker rm -vf  battlegame dbgame


push-image:
	docker push $(IMAGE)

.PHONY: volume reseau image run test clean push-image
