# NotesAutomation

**NotesAutomation** is a Ruby gem for generating static websites from a directory of Markdown files. It processes Markdown files (with YAML frontmatter), supports wiki–style links and image attachments, and automatically generates HTML pages, search indexes, Atom feeds, and directory pages. This gem is perfect for publishing personal notes, blogs, or documentation from your Markdown sources.

## Features

- **Markdown Rendering:**
  Converts Markdown to HTML using [Kramdown](https://kramdown.gettalong.org/) with GitHub–flavored Markdown support.

- **Syntax Highlighting:**
  Integrates with [Rouge](https://github.com/rouge-ruby/rouge) to provide beautiful syntax highlighting for code blocks.

- **Custom Link Parsing:**
  Supports wiki–style links (e.g. `[[Page]]` or `[[Page|Nice Title]]`) and cross–linking between pages, with automatic replacement.

- **YAML Frontmatter:**
  Reads and processes YAML frontmatter to enable custom metadata (e.g. creation dates, draft status).

- **Git Timestamps:**
  Optionally uses git commit times to set file creation and modification timestamps instead of relying solely on file system data.

- **File Tree Generation:**
  Automatically builds a directory tree from your Markdown files to generate index pages and navigation links.

- **Atom Feed Generation:**
  Creates Atom feeds for your entire site and for specified subdirectories.

- **Search Index:**
  Generates a search page by extracting text from your rendered HTML.

- **Customizable Templates:**
  Uses ERB templates (stored in the `templates` directory) to let you fully customize the output HTML.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'notes_automation'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install notes_automation
```

## Usage

Once installed, you can run the static site generator from the command line. For example:

```bash
notes_automation --path /absolute/path/to/markdown_files --recent 15 --use-git-times --feed blog
```

### Command-Line Options

- `--path PATH`
  The absolute path to the folder containing your Markdown files. If not specified, the gem defaults to a preset location (for example, an Obsidian vault).

- `--recent N`
  Specifies the number of recent entries to show on the index page. The default is `15`.

- `--use-git-times`
  Use git commit timestamps instead of file modification times for file dates.

- `--feed NAME`
  Generate a separate Atom feed for the directory named `NAME`. This option can be given multiple times.

The generator processes your Markdown files, applies custom transformations (e.g. for images and crosslinks), and writes the generated HTML along with static assets into an `output` directory.

## Templates

The gem uses ERB templates stored in the `templates` folder to render HTML pages, Atom feeds, directory listings, and search pages. Customize these templates to change the look and feel of your site.

## Development

Contributions are welcome! To work on NotesAutomation locally:

1. **Fork and Clone** the repository.
2. Install dependencies using Bundler:

   ```bash
   bundle install
   ```

3. Run tests (if provided) to ensure everything is working as expected.
4. Submit a pull request with your improvements.

### Dependencies

- [kramdown](https://github.com/gettalong/kramdown)
- [rouge](https://github.com/rouge-ruby/rouge)
- [nokogiri](https://nokogiri.org/)
- Ruby (>= 2.7 recommended)

## License

This gem is released under the [MIT License](LICENSE).

## Acknowledgments

NotesAutomation is inspired by a Python static site generator and has been ported to Ruby to leverage modern libraries for Markdown rendering, syntax highlighting, and HTML processing. Special thanks to the developers behind kramdown, rouge, and nokogiri for providing robust tools that made this project possible.
