FROM ubuntu:latest

# Install build requirements
RUN apt update && apt upgrade -y && \
    apt install -y \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    curl \
    wget \
    git

# Install Ruby Gems needed for asciidoctor
ENV RBENV_ROOT $HOME/.rbenv
ENV PATH $RBENV_ROOT/shims:$RBENV_ROOT/bin:$RBENV_ROOT/plugins/ruby-build/bin:$PATH
ENV GEM_HOME $RBENV_ROOT
RUN git clone --depth 1 https://github.com/rbenv/rbenv.git $RBENV_ROOT && \
    cd $RBENV_ROOT && src/configure && make -C src && \
    mkdir -p $RBENV_ROOT/plugins && \
    git clone --depth 1 https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build && \
    echo 'export RBENV_ROOT="$HOME/.rbenv"\nexport PATH="$RBENV_ROOT/bin:$PATH"\nif command -v rbenv 1>/dev/null 2>&1; then\n    eval "$(rbenv init -)" \nfi' >> ~/.bashrc && \
    bash -l -c "source ~/.bashrc" && \
    bash -l -c "rbenv install 2.7.0 -v && rbenv global 2.7.0" && \
    bash -l -c "gem install bundler:2.1.4"
RUN bash -l -c "unset BUNDLE_PATH" && \
    bash -l -c "unset BUNDLE_BIN"
COPY Gemfile* ./
RUN bundle i

# Install plantuml
RUN wget -O ~/plantuml.jar http://sourceforge.net/projects/plantuml/files/plantuml.jar/download

WORKDIR /src

