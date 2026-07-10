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

# 5. FIXED: Force Tailwind compilation to fire explicitly right before asset precompilation
ENV RAILS_ENV=production
RUN bundle exec rails tailwindcss:build
RUN bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]