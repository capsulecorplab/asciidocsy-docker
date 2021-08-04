FROM ruby:2.6.6-buster

# install nodejs from source
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt update && apt upgrade -y && \
    apt install -y nodejs

# install bundler
RUN gem install bundler:2.2.15

# install rubygems with bundler
COPY Gemfile* ./
RUN bundle i

# create WORKDIR
WORKDIR /src

ENTRYPOINT ["/bin/bash", "-c"]
