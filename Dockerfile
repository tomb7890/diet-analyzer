# Base image
FROM ruby:2.7.8

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile* ./

# Install gems
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

