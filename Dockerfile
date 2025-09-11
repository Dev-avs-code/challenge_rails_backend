FROM ruby:3.3.1-bullseye
ARG RAILS_DIR=rails

# Install OS dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client wait-for-it && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

WORKDIR /$RAILS_DIR

# Install project ruby dependencies
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle config set --local path 'vendor'
RUN bundle install

# Copy files and prepare project
COPY . .

RUN bundle exec rails assets:precompile

WORKDIR /$RAILS_DIR
ENV PATH="/$RAILS_DIR/bin:${PATH}"
EXPOSE 3000
ENTRYPOINT ["./docker-entrypoint.sh"]
HEALTHCHECK --start-period=30s --interval=30s CMD curl --fail http://127.0.0.1:3000/up || exit 1
CMD ["puma"]