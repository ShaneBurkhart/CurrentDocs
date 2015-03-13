FROM ruby:2.2.1
MAINTAINER Shane Burkhart <shaneburkhart@gmail.com>

ENV RAILS_ENV production

RUN mkdir /app
WORKDIR /app

RUN mkdir tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --without development test
RUN rm -r tmp

ADD . .

EXPOSE 3000

ENTRYPOINT ["rails"]
CMD ["server"]
