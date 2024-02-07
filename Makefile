.PHONY: deploy
deploy: ./deploy.sh
	bash $<

.PHONY: commit
commit: ./commit.sh
	bash $<

.PHONY: run
run: ./run.sh
	bash $<
