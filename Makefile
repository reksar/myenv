.DEFAULT_GOAL := deploy

.PHONY: deploy
deploy:
	ansible-playbook -i ansible/hosts -vv ansible/my_env_deploy.yml
