KUBE_CONFIG_DIR := "$(HOME)/.kube"
KUBE_CONFIG_PATH := "$(KUBE_CONFIG_DIR)/config"

setup:
	@mkdir -p "$(KUBE_CONFIG_DIR)"
	@touch "$(KUBE_CONFIG_PATH)"
	@docker build . \
		--progress=plain \
		-f Containerfile \
		-t kubernetes-tools

shell:
	@docker run \
		--mount "type=bind,source=$(KUBE_CONFIG_PATH),target=/mnt/kubeconfig.yaml,readonly" \
		--rm \
		-i \
		-t \
		kubernetes-tools

test:
	@$(CURDIR)/tests/index.sh
