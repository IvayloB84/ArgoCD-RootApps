FROM ruby:3.2-alpine

# 1. Install required system compilation libraries for SQLite and Puma
RUN apk add --no-cache build-base sqlite-dev tzdata nodejs gcompat

# 2. Configure project directory workspace
WORKDIR /app

# 3. Cache and install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' \
    && bundle config set --local without 'development test' \
    && bundle install

# 4. Copy your actual Ruby on Rails source code files
COPY . .

# 5. Precompile assets for high production speeds
ENV RAILS_ENV=production
RUN bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
