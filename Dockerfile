FROM ruby:2.7.4

# System prerequisites
RUN apt-get update \
 && apt-get -y install build-essential libpq-dev \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# If you require additional OS dependencies, install them here:
RUN apt-get update \
 && apt-get -y install nodejs yarn \
 && rm -rf /var/lib/apt/lists/*

ADD Gemfile /app/
ADD Gemfile.lock /app/
WORKDIR /app
RUN bundle install

ADD . /app

# Collect assets. This approach is not fully production-ready, but
# will help you experiment with Aptible Deploy before bothering with assets.
# Review http://go.aptible.com/assets for production-ready advice.
RUN set -a \
 && . ./.aptible.env \
 && bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]