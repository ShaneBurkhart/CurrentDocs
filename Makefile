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

bundle:
	 docker-compose -f ${DEV_FILE} -p ${NAME} run --rm web bundle

logs:
	 docker-compose -f ${DEV_FILE} -p ${NAME} logs


#assets:
	#RAILS_ENV=production bundle exec rake assets:precompile
