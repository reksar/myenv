.DEFAULT_GOAL := deploy

.PHONY: deploy
deploy:
	ansible-playbook -vvv -i ansible/hosts ansible/my_env_deploy.yml
