FROM ruby:2.2.1
MAINTAINER Shane Burkhart <shaneburkhart@gmail.com>

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
