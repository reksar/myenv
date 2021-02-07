.DEFAULT_GOAL := configure

.PHONY: configure
configure:
	ansible-playbook \
		--ask-become-pass \
		-i ansible/hosts \
		ansible/configure.yml

.PHONY: clean
clean:
	# Ansible creates *.retry files when something goes wrong.
	find . -type f -name '*.retry' -delete

