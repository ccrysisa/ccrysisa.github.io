deploy: ./deploy.sh
	bash $<

commit: ./commit.sh
	bash $<

run: ./run.sh
	bash $<

.PHONY: deploy commit run 
