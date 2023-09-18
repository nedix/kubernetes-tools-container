setup: target := target-alpine
setup:
	@docker build . --target=$(target) --tag=kubernetes-tools

run:
	@docker run --rm -it kubernetes-tools

test:
	@(MAKE) setup
	@$(CURDIR)/tests/feature/all.sh
