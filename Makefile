
VERSION := $(shell date -u +"%Y%m%d%H%M%S")
export VERSION

build:
	docker buildx build --platform linux/amd64 -t swarm-01.office.m:5000/stratum:$(VERSION) .
	docker tag swarm-01.office.m:5000/stratum:$(VERSION) swarm-01.office.m:5000/stratum:latest

push: build deploy-registry
	docker push swarm-01.office.m:5000/stratum:$(VERSION)
	docker push swarm-01.office.m:5000/stratum:latest

deploy-registry:
	DOCKER_HOST=ssh://swarm-01.office.m docker stack deploy -c ./registry-docker-compose.yml registry

deploy: build push
	DOCKER_HOST=ssh://swarm-01.office.m docker stack deploy --resolve-image always -c ./docker-compose.yml stratum
