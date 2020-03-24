NAME=ngti/cloud-foundry-ecr-action
CONTAINER_NAME=ngti-cloud-foundry-ecr-action

.PHONY: clean build run stop

clean:
	-@docker rmi --force $(shell docker images ${NAME}:latest -q)

build:
	docker build -f Dockerfile \
				--force-rm \
				--no-cache \
				--tag ${NAME}:latest \
				.

run:
	docker run -it \
			-e CF_API_ENDPOINT='${CF_API_ENDPOINT}' \
			-e CF_DOCKER_IMAGE='${CF_DOCKER_IMAGE}' \
			-e ORG='${CF_ORG}' \
			-e SPACE='${CF_SPACE}' \
			-e APP_NAME='${APP_NAME}' \
			-e NUM_INSTANCES='${NUM_INSTANCES}' \
			-e DISK='${DISK}' \
			-e MEMORY='${MEMORY}' \
			-e HEALTH_CHECK_TYPE='${HEALTH_CHECK_TYPE}' \
			-e USERNAME='${CF_USER}' \
			-e PASSWORD='${CF_PASSWORD}' \
			-e CF_DOCKER_USERNAME='${CF_DOCKER_USERNAME}' \
			-e CF_DOCKER_PASSWORD='${CF_DOCKER_PASSWORD}' \
			--name ${CONTAINER_NAME} \
			--rm ${NAME}:latest

stop:
	-@docker container kill $(shell docker ps -a -q --filter="name=${CONTAINER_NAME}")
