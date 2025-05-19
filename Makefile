setup:
	@docker build --progress=plain -f Containerfile -t kubernetes-tools .

shell: KUBE_CONFIG_PATH := $(HOME)/.kube/config
shell:
	@docker run --rm -it \
		--mount type=bind,source="$(KUBE_CONFIG_PATH)",target=/mnt/kubeconfig.yaml,readonly \
		kubernetes-tools

test:
	@$(CURDIR)/tests/index.sh
