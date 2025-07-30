# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in notes_automation.gemspec
gemspec

# ================== General Dependencies =================== #

gem 'dotenv'          # Loads environment variables from .env file
gem 'rake', '~> 13.0' # Rake for task automation

# =========== Development and Testing Dependencies ========== #

group :development, :test do
  gem 'pry', '~> 0.14'       # Interactive Ruby shell
  gem 'rspec', '~> 3.0'      # Testing framework
  gem 'rubocop', '~> 1.21'   # Code style and linting
  gem 'simplecov', '~> 0.22' # Test coverage reporting
end

# =========================== CLI =========================== #

gem 'open3', '~> 0.1'     # Process management for shell commands
gem 'optparse', '~> 0.6'  # CLI option parsing
gem 'thor', '~> 1.3'      # CLI framework

# ================ HTTP and Network Requests ================ #

# gem 'faraday', '~> 2.0'       # HTTP client
# gem 'faraday-retry', '~> 2.2' # Retry middleware for Faraday

#=============== File and Directory Management=============== #

gem 'fileutils', '~> 1.4' # File and directory manipulation
gem 'tempfile', '~> 0.3'  # Temporary file creation

# ============= Data Serialization and Parsing ============== #

gem 'csv', '~> 3.3'      # CSV serialization and parsing
gem 'json', '~> 2.5'     # JSON serialization and parsing
gem 'cgi', '~> 0.4'      # HTML escaping
gem 'kramdown', '~> 2.5' # Markdown -> HTML conversion (configured for GitHub flavored markdown)
gem 'rouge', '~> 4.5'    # Syntax highlighting

# ================== Logging and Debugging ================== #

gem 'logger', '~> 1.4' # Logging messages to a file or STDOUT

# ================== Dependency Management ================== #

gem 'zeitwerk', '~> 2.7' # Code autoloading
