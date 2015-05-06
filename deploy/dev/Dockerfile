FROM shaneburkhart/plansource
MAINTAINER Shane Burkhart <shaneburkhart@gmail.com>

ENV RAILS_ENV development

RUN bundle install --without production test

CMD ["bundle", "exec", "rails", "s"]
