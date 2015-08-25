NAME=plansource
DEV_FILE=deploy/dev/docker-compose.yml

BASE_TAG=shaneburkhart/plansource

all: run

build:
	 docker build -t ${BASE_TAG} .
	 docker build -t ${BASE_TAG}:dev ./deploy/dev

run:
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle exec rake db:migrate
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle exec rake db:seed
	docker-compose -f ${DEV_FILE} -p ${NAME} up -d

stop:
	docker stop $$(docker ps -q)

clean: stop
	docker rm $$(docker ps -aq)

ps:
	docker ps -a

c:
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web /bin/bash

pg:
	echo "Enter 'postgres'..."
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm pg psql -h pg -d mydb -U postgres --password


bundle:
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle

logs:
	docker-compose -f ${DEV_FILE} -p ${NAME} logs

heroku_deploy:
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web true
	docker cp $$(docker ps -a | grep web | head -n 1 | awk '{print $$1}'):/app/Gemfile.lock .
	git add Gemfile.lock
	git commit -m "Added Gemfile.lock for Heroku deploy."
	git push -f heroku master
	rm Gemfile.lock
	git rm Gemfile.lock
	git commit -m "Removed Gemfile.lock from Heroku deploy."

heroku_staging_deploy:
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web true
	docker cp $$(docker ps -a | grep web | head -n 1 | awk '{print $$1}'):/app/Gemfile.lock .
	git add Gemfile.lock
	git commit -m "Added Gemfile.lock for Heroku deploy."
	git push -f heroku_staging master
	rm Gemfile.lock
	git rm Gemfile.lock
	git commit -m "Removed Gemfile.lock from Heroku deploy."

#assets:
	#RAILS_ENV=production bundle exec rake assets:precompile
