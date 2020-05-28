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

	if [ "$$(curl -X GET http://localhost:80/health)" = "ok" ]; then echo "test OK"; exit 0; else echo "test KO"; exit 1; fi
	echo "fin test"

clean:
	docker-compose down 

push-image:
	docker push $(IMAGE)

.PHONY: image run test clean push-image
