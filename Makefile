setup:
	@docker build . -t kubernetes-tools

run:
	@docker run --rm -it --entrypoint /bin/sh kubernetes-tools
