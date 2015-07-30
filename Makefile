NAME=plansource
DEV_FILE=deploy/dev/docker-compose.yml

BASE_TAG=shaneburkhart/plansource

all: run

build:
	sudo docker build -t ${BASE_TAG} .
	sudo docker build -t ${BASE_TAG}:dev ./deploy/dev

run: 
	sudo docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle exec rake db:migrate
	sudo docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle exec rake db:seed
	sudo docker-compose -f ${DEV_FILE} -p ${NAME} up -d

bundle:
	sudo docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle

stop:
	sudo docker-compose -f ${DEV_FILE} -p ${NAME} stop

logs:
	sudo docker-compose -f ${DEV_FILE} -p ${NAME} logs


assets:
	RAILS_ENV=production bundle exec rake assets:precompile
