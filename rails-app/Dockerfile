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

# 5. FIXED: Injected a mock fallback token to bypass encryption initializer crashes on cloud builds
ENV RAILS_ENV=production
RUN SECRET_KEY_BASE=dummy_token_for_asset_compilation_only bundle exec rails tailwindcss:build
RUN SECRET_KEY_BASE=dummy_token_for_asset_compilation_only bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]