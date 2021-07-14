FROM ruby:2.6.6-buster

RUN gem install bundler:2.2.4

COPY Gemfile* ./
RUN bundle i

# create WORKDIR
WORKDIR /src

ENTRYPOINT ["/bin/bash", "-c"]
