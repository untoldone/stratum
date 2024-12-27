DOCKER_HOST := ssh://swarm-01.office.m
export DOCKER_HOST
VERSION := $(shell date -u +"%Y%m%d%H%M%S")
export VERSION

build-stratum:
	docker build -t swarm-01.office.m:5000/stratum:$(VERSION) .
	docker tag swarm-01.office.m:5000/stratum:$(VERSION) swarm-01.office.m:5000/stratum:latest

build-collector:
	docker build -t swarm-01.office.m:5000/stratum-collector:$(VERSION) ./collector
	docker tag swarm-01.office.m:5000/stratum-collector:$(VERSION) swarm-01.office.m:5000/stratum-collector:latest

build: build-stratum build-collector

push-stratum: build-stratum
	docker push swarm-01.office.m:5000/stratum:$(VERSION)
	docker push swarm-01.office.m:5000/stratum:latest

push-collector: build-collector
	docker push swarm-01.office.m:5000/stratum-collector:$(VERSION)
	docker push swarm-01.office.m:5000/stratum-collector:latest

push: deploy-registry push-stratum push-collector

deploy-registry:
	docker stack deploy -c ./registry-docker-compose.yml registry

deploy-collector: push-collector
	docker stack deploy -c ./collector-docker-compose.yml collector

deploy-stratum: push-stratum
	docker stack deploy --resolve-image always -c ./docker-compose.yml stratum

deploy: push
	docker stack deploy --resolve-image always -c ./docker-compose.yml stratum
