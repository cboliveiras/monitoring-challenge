FROM ruby:3.1.2
  RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
  WORKDIR /monitoring-challenge
  COPY Gemfile /monitoring-challenge/Gemfile
  COPY Gemfile.lock /monitoring-challenge/Gemfile.lock
  RUN bundle install
  COPY . /monitoring-challenge

  EXPOSE 3000
