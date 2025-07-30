# frozen_string_literal: true

require_relative 'lib/notes_automation/version'

Gem::Specification.new do |spec|
  spec.name = 'notes_automation'
  spec.version = NotesAutomation::VERSION
  spec.authors = ['Jacob Penner']
  spec.email = ['japenner@gmail.com']

  spec.summary = 'This tool automates converting markdown notes to html pages.'
  spec.description = 'This tool will be iterated on and extended.'
  spec.homepage = 'https://github.com/Japenner/notes_automation'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Japenner/notes_automation'
  spec.metadata['changelog_uri'] = 'https://github.com/Japenner/notes_automation/CHANGELOG.md'

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.bindir = 'bin'

  spec.executables = ['notes_automation']

  spec.require_paths = ['lib']

  # Production dependencies

  spec.add_dependency 'csv', '~> 3.3'           # CSV serialization and parsing
  spec.add_dependency 'dotenv', '~> 3.0'        # Loads environment variables from .env file
  spec.add_dependency 'faraday', '~> 2.0'       # HTTP client for making API requests
  spec.add_dependency 'faraday-retry', '~> 2.2' # Retry middleware for Faraday
  spec.add_dependency 'fileutils', '~> 1.4'     # File and directory manipulation
  spec.add_dependency 'json', '~> 2.5'          # JSON serialization and parsing
  spec.add_dependency 'logger', '~> 1.4'        # Logging messages to a file or STDOUT
  spec.add_dependency 'octokit', '~> 9.0'       # GitHub API client
  spec.add_dependency 'open3', '~> 0.1'         # Process management for shell commands
  spec.add_dependency 'optparse', '~> 0.6'      # Command-line option parser
  spec.add_dependency 'rake', '~> 13.0'
  spec.add_dependency 'ruby-openai', '~> 7.3'   # OpenAI API client
  spec.add_dependency 'tempfile', '~> 0.3'      # Temporary file creation and management
  spec.add_dependency 'thor', '~> 1.3'          # CLI framework
  spec.add_dependency 'zeitwerk', '~> 2.7'      # Code autoloading

  # Development dependencies
  spec.add_development_dependency 'pry', '~> 0.14'       # Interactive Ruby shell
  spec.add_development_dependency 'rspec', '~> 3.0'      # Testing framework
  spec.add_development_dependency 'rubocop', '~> 1.21'   # Code style and linting
  spec.add_development_dependency 'simplecov', '~> 0.22' # Test coverage reporting
end
