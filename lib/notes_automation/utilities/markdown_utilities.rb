# -------------------------------
# Markdown rendering and code highlighting
# -------------------------------

require 'fileutils'
require 'cgi'       # for HTML escaping
require 'kramdown'  # for Markdown -> HTML conversion (configured for GitHub flavored markdown)
require 'rouge'     # for syntax highlighting
require 'nokogiri'  # for HTML post‐processing (similar to BeautifulSoup in Python)

module NotesAutomation
  module MarkdownUtilities
    # Highlight a block of code. If no language is specified, simply escape the code.
    def highlight(code, lang, _unused = nil)
      if lang.to_s.strip.empty?
        "<div class=\"highlight\">#{CGI.escapeHTML(code)}</div>"
      elsif lang == "warning"
        # Special “warning” block rendered as an admonition.
        "<div class=\"admon-warning\"><p class=\"warning\">#{CGI.escapeHTML(code)}</p></div>"
      else
        lexer = Rouge::Lexer.find_fancy(lang, code) || Rouge::Lexers::PlainText
        formatter = Rouge::Formatters::HTML.new
        formatter.format(lexer.lex(code))
      end
    rescue => e
      err("Failed to highlight code for language", lang, e.message)
      "<div class=\"highlight\">#{CGI.escapeHTML(code)}</div>"
    end

    # Render the markdown content of a page into HTML.
    # Uses kramdown (configured for GitHub–flavored markdown) plus a post–processing step
    # to add an "external-link" CSS class to links not beginning with "#".
    def render_content(page)
      # Render markdown to HTML. Kramdown uses Rouge for syntax highlighting if configured.
      html = Kramdown::Document.new(page.source, input: 'GFM', hard_wrap: false, syntax_highlighter: 'rouge').to_html

      # Post–process the HTML with Nokogiri to add "external-link" class to links that do not start with "#".
      doc = Nokogiri::HTML::DocumentFragment.parse(html)
      doc.css('a').each do |link|
        href = link['href']
        if href && !href.start_with?("#")
          existing = link['class']
          link['class'] = [existing, "external-link"].compact.join(" ")
        end
      end
      doc.to_html
    end

    # Generate HTML pages for all pages.
    def generate_html_pages(pages, outdir)
      pages.values.each do |page|
        output_path = File.join(outdir.to_s, page.link_path)
        # Optimization: if the file already exists and is newer than the source, skip regeneration.
        if File.exist?(output_path) && (page.mtime < File.stat(output_path).mtime.to_f)
          page.html = render_content(page)
        else
          page.html = render_content(page)
          page.html_escaped_content = CGI.escapeHTML(page.html)
          mkdir(File.join(outdir.to_s, page.relpath))
          File.write(output_path, render("page.html", page: page))
        end
      end
    end

    # Copy attachment files (non-markdown) to the output directory.
    def copy_attachments(attachments, outdir)
      attachments.each_value do |att|
        mkdir(File.join(outdir.to_s, att.relpath))
        FileUtils.cp(att.fullpath, File.join(outdir.to_s, att.link_path))
      end
    end
  end
end
