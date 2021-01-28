.DEFAULT_GOAL := deploy

.PHONY: deploy
deploy:
	ansible-playbook --ask-become-pass \
		-i ansible/hosts ansible/my_env_deploy.yml

.PHONY: clean
clean:
	find . -type f -name '*.retry' -delete

