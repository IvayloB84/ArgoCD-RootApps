FROM ruby:3.2-alpine

# 1. FIXED: Added libc6-compat to allow the standalone tailwind binary to execute on Alpine Linux
RUN apk add --no-cache build-base sqlite-dev tzdata nodejs gcompat libc6-compat vips-dev imagemagick

# 2. Configure project directory workspace
WORKDIR /app

# 3. Cache and install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' \
    && bundle config set --local without 'development test' \
    && bundle install

# 4. Copy your actual Ruby on Rails source code files
COPY . .

# 5. FIXED: Use the official Rails 8 dummy compilation variable to allow database-less asset builds
ENV RAILS_ENV=production
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]