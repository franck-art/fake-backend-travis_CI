# le fichier makefile permet de construit notre projet
# en regles et appliquer les actions sur les cibles
# declaration de variables

IMAGE =  franckjunior/fake-backend
network = network_game
vol_data = mysql_data

# Regles

reseau: 
        docker create network $(network)

volume:
        docker create volume $(vol_data)


image:
        docker build -t $(IMAGE) ./fake-backend


run_backend:
        docker run --name dbgame -v $(vol_data):/var/lib/mysql  -e  MYSQL_ROOT_PASSWORD: rootpwdgame -e  MYSQL_DATABASE: battleboat -e MYSQL_USER: battleuser -e  MYSQL_PASSWORD: battlepass --network $(network)  $(IMAGE)



run_frontend: 
        docker run --name battlegame -v $(pwd)/battleboat:/etc/backend/static -e  DATABASE_HOST: dbgame -e  DATABASE_PORT: 3306 -e  DATABASE_USER: battleuser -e DATABASE_PASSWORD: battlepass -e DATABASE_NAME: battleboat --network $(network) $(IMAGE) 

       # To let the container start before run test
	sleep 5

test: 
        if [ "$$(curl -I  localhost | head -1 | cut -d '1' -f 3 | cut -d 'O' -f 1)" = "200" ] ; then echo "test OK" ;  exit 0; else echo "test KO"; exit 1; fi


clean:
	docker rm -vf  battlegame dbgame


push-image:
	docker push $(IMAGE)

.PHONY: volume reseau image run_backend run_frontend test clean push-image
