setup:
	@docker build . -t kubernetes-tools-docker

run:
	@docker run --rm -it --entrypoint /bin/bash kubernetes-tools-docker
