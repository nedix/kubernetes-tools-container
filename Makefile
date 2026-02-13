setup:
	@docker build --progress=plain -f Containerfile -t kubernetes-tools .

shell: KUBE_CONFIG_PATH = "$(HOME)/.kube/config"
shell:
	@docker run \
		--mount "type=bind,source=$(KUBE_CONFIG_PATH),target=/mnt/kubeconfig.yaml,readonly" \
		--rm \
		-it \
		kubernetes-tools

test:
	@$(CURDIR)/tests/index.sh
