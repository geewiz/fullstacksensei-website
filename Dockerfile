FROM ruby:2.4.3

RUN apt-get update -qq && apt-get install -y \
  build-essential

EXPOSE 5000

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app

RUN bundle exec jekyll build

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "5000"]
