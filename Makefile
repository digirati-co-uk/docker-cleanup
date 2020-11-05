IMAGE := digirati/docker-cleanup

lint:
	pre-commit run --all-files --verbose

image:
	docker build -t $(IMAGE) .

push-image:
	docker push $(IMAGE)

.PHONY: image push-image test
