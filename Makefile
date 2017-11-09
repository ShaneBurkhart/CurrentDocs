.PHONY: db

NAME=plansource
DEV_FILE=deploy/dev/docker-compose.yml

BASE_TAG=shaneburkhart/plansource

all: run

build:
	 docker build -t ${BASE_TAG} .
	 docker build -t ${BASE_TAG}:dev ./deploy/dev

db:
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle exec rake db:migrate
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle exec rake db:seed

run:
	docker-compose -f ${DEV_FILE} -p ${NAME} up -d

up:
	docker-machine start default
	docker-machine env
	eval $(docker-machine env)

stop:
	docker stop $$(docker ps -q) || echo "Nothing to stop..."

clean: stop
	docker rm $$(docker ps -aq) || echo "Nothing to remove..."

wipe: clean
	rm -rf data
	$(MAKE) db || echo "\n\nDatabase needs a minute to start...\nWaiting 7 seconds for Postgres to start...\n\n"
	sleep 7
	$(MAKE) db

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
	docker-compose -f ${DEV_FILE} -p ${NAME} logs -f

heroku_deploy:
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web true
	docker cp $$(docker ps -a | grep web | head -n 1 | awk '{print $$1}'):/app/Gemfile.lock .
	git add Gemfile.lock
	git commit -m "Added Gemfile.lock for Heroku deploy."
	git push -f heroku master
	heroku run --app plansource rake db:migrate
	heroku restart --app plansource
	rm Gemfile.lock
	git rm Gemfile.lock
	git commit -m "Removed Gemfile.lock from Heroku deploy."

heroku_staging_deploy:
	docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web true
	docker cp $$(docker ps -a | grep web | head -n 1 | awk '{print $$1}'):/app/Gemfile.lock .
	git add Gemfile.lock
	git commit -m "Added Gemfile.lock for Heroku deploy."
	git push -f heroku_staging master
	heroku run --app plansourcestaging rake db:migrate
	heroku restart --app plansourcestaging
	rm Gemfile.lock
	git rm Gemfile.lock
	git commit -m "Removed Gemfile.lock from Heroku deploy."

#assets:
	#RAILS_ENV=production bundle exec rake assets:precompile
