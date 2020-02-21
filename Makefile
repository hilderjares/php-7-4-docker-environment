build-app:
	docker build -t app .

run-app:
	docker run --rm --name app -p 8080:80 -v $(PWD):/var/www app

build-cli:
	docker build --target cli -t cli .

run-cli: 
	docker run --rm --name cli -v $(PWD):/var/www cli ${composer}