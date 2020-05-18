# le fichier makefile permet de construire notre projet
# en regles et appliquer les actions sur les cibles
# declaration de variables

IMAGE =  franckjunior/fake-backend:travis
network = network_game
vol_data = mysql_data

# Regles

reseau: 
	docker network create  $(network)

volume:
	docker volume create $(vol_data)


image:
	docker build -t $(IMAGE) ./fake-backend


run:
	docker run --name dbgame -v $(vol_data):/var/lib/mysql  -e  MYSQL_ROOT_PASSWORD=rootpwdgame -e  MYSQL_DATABASE=battleboat -e MYSQL_USER=battleuser -e  MYSQL_PASSWORD=battlepass --network $(network) -d mysql:5.7
	docker run --name battlegame -v ${PWD}/battleboat:/etc/backend/static -p 80:3000 -e  DATABASE_HOST=dbgame -e  DATABASE_PORT=3306 -e  DATABASE_USER=battleuser -e DATABASE_PASSWORD=battlepass -e DATABASE_NAME=battleboat --network $(network) -d  $(IMAGE)

        # To let the container start before run test
	sleep 5
	docker ps -a
test:

	curl http://localhost:80
#	curl http://localhost:80/health
	echo "fin test"

clean:
	docker rm -vf  battlegame dbgame


push-image:
	docker push $(IMAGE)

.PHONY: volume reseau image run  test clean push-image
