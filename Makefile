# =============================================================================
# Makefile — artemyx_web
#
# Static brochure site — no Supabase, no backend, no build step.
# Infrastructure (IAM roles, Cloudflare Pages projects) lives in ArcaHq repo.
# Deployments are triggered by GitHub Actions on push/tag.
#
# All script logic lives in the Artemyx platform repo and is installed to
# $(PLATFORM_DIR) on first run. To update scripts: make update-platform
# =============================================================================

APP_NAME      := artemyx_web
PLATFORM_DIR  := $(HOME)/.artemyx/platform
PLATFORM_REPO := https://github.com/artemyxlabs/platform.git

.PHONY: github-setup credentials install update-platform help

_require-platform:
	@if [ ! -d "$(PLATFORM_DIR)" ]; then \
		echo "Installing Artemyx platform scripts to $(PLATFORM_DIR)..."; \
		git clone $(PLATFORM_REPO) $(PLATFORM_DIR); \
	fi

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

update-platform: ## Update Artemyx platform scripts to latest version
	git -C "$(PLATFORM_DIR)" pull

github-setup: _require-platform ## Create GitHub environments and set required secrets/vars
	REPO_ROOT=$(CURDIR) "$(PLATFORM_DIR)/scripts/github-setup.sh"

credentials: _require-platform ## View and rotate stored credentials in ~/.artemyx/credentials
	AWS_APPCONFIG_APP=$(APP_NAME) "$(PLATFORM_DIR)/scripts/credentials.sh"

install: _require-platform ## Install required tools (Terraform)
	@if command -v brew >/dev/null 2>&1; then \
		brew install hashicorp/tap/terraform 2>/dev/null || brew upgrade hashicorp/tap/terraform; \
	else \
		echo "Homebrew not found — install Terraform manually:"; \
		echo "  https://developer.hashicorp.com/terraform/install"; \
	fi
	npm install -g wrangler
