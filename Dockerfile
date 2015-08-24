FROM ruby:2.2.1
MAINTAINER Shane Burkhart <shaneburkhart@gmail.com>

RUN apt-get update && \
    apt-get install -y npm && \
    apt-get install -y nodejs
RUN ln -s /usr/bin/nodejs /usr/bin/node

ENV RAILS_ENV production

RUN mkdir -p /app
WORKDIR /app

RUN mkdir tmp
ADD Gemfile Gemfile
RUN bundle install --without development test
RUN rm -r tmp

ADD . /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s"]
