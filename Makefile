.DEFAULT_GOAL := deploy

.PHONY: deploy
deploy:
	ansible-playbook --ask-become-pass \
		-i ansible/hosts ansible/my_env_deploy.yml

.PHONY: clean
clean:
	# Ansible creates *.retry files when something goes wrong.
	find . -type f -name '*.retry' -delete

