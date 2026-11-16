.PHONY: provision verify register status rebuild

provision:
	ansible-playbook -i inventory.ini site.yml --ask-become-pass

verify:
	ansible-playbook -i inventory.ini site.yml --tags verify --ask-become-pass

register:
	@if [ -z "$(TOKEN)" ]; then echo "Usage: make register TOKEN=<github_org_runner_token>"; exit 1; fi
	ansible-playbook -i inventory.ini site.yml -e "runner_token=$(TOKEN)" --ask-become-pass

status:
	sudo /opt/actions-runner/svc.sh status

rebuild:
	@if [ -z "$(TOKEN)" ]; then echo "Usage: make rebuild TOKEN=<github_org_runner_token>"; exit 1; fi
	@echo "=== Tearing down existing runner service and installation ==="
	-cd /opt/actions-runner && sudo ./svc.sh stop && sudo ./svc.sh uninstall
	sudo rm -rf /opt/actions-runner /tmp/actions-runner-linux-x64-*
	@echo "=== Rebuilding standardized runner from scratch ==="
	ansible-playbook -i inventory.ini site.yml -e "runner_token=$(TOKEN)" --ask-become-pass
