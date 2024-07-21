setup:
	@docker build . -t kubernetes-tools

run: KUBE_CONFIG_PATH := $(HOME)/.kube/config
run:
	@docker run --rm -it \
		--mount type=bind,source="$(KUBE_CONFIG_PATH)",target=/mnt/kubeconfig.yaml,readonly \
		kubernetes-tools

test:
	@$(MAKE) setup
	@$(CURDIR)/tests/e2e/index.sh
