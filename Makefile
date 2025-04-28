# Makefile for Ansible Docker automation

IMAGE_NAME = ansible-test-vm
CONTAINER_NAME_1 = ansible-vm-1
PORT_1 = 2222
CONTAINER_NAME_2 = ansible-vm-2
PORT_2 = 2223

# Default target
all: build run

# Build the Docker image
build:
	@echo "Building Docker image: $(IMAGE_NAME)"
	docker build -t $(IMAGE_NAME) .

# Run the Docker container(s)
run: build
	@echo "Running Docker container(s)"
	#Cleanup
	docker stop $(CONTAINER_NAME_1) || true #ignore if it does not exist
	docker rm $(CONTAINER_NAME_1) || true
	docker run -d --name $(CONTAINER_NAME_1) -p $(PORT_1):22 $(IMAGE_NAME)
	docker stop $(CONTAINER_NAME_2) || true #ignore if it does not exist
	docker rm $(CONTAINER_NAME_2) || true
	docker run -d --name $(CONTAINER_NAME_2) -p $(PORT_2):22 $(IMAGE_NAME)

#show containers
show:
	docker ps

# Stop the Docker container(s)
stop:
	@echo "Stopping Docker container(s)"
	docker stop $(CONTAINER_NAME_1)
	docker stop $(CONTAINER_NAME_2)

# Remove the Docker container(s)
remove: stop
	@echo "Removing Docker container(s)"
	docker rm $(CONTAINER_NAME_1)
	docker rm $(CONTAINER_NAME_2)

# Remove the Docker image
rmi:
	@echo "Removing Docker image: $(IMAGE_NAME)"
	docker rmi $(IMAGE_NAME)

# Clean all (stop, remove containers, remove image)
clean: remove rmi

.PHONY: all build run stop remove rmi clean show

