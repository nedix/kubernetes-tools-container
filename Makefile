setup: target := alpine
setup:
	@docker build . --build-arg=TARGET=$(target) --tag=kubernetes-tools

run:
	@docker run --rm -it --entrypoint /bin/sh kubernetes-tools
