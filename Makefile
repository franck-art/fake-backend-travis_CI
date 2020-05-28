# le fichier makefile permet de construire notre projet
# en regles et appliquer les actions sur les cibles
# declaration de variables

IMAGE =  franckjunior/fake-backend:travis

# Regles


image:
	docker build -t $(IMAGE) ./fake-backend


run:
	docker-compose up -d
        # To let the container start before run test
	sleep 5s
	docker ps
	ip add 
test:

	if [ "$$(curl -X GET http://127.0.0.1:8282/health)" = "ok" ]; then echo "test OK"; exit 0; else echo "test KO"; exit 1; fi
	echo "fin test"


push-image:
        docker push $(IMAGE)


clean:
	docker-compose down 


.PHONY: image run test clean push-image
