# frozen_string_literal: true

# -------------------------------
# HTML/Feed generation functions
# -------------------------------

require 'pathname'
require 'time'
require 'date'
require 'cgi'       # for HTML escaping
require 'nokogiri'  # for HTML post‐processing (similar to BeautifulSoup in Python)

module NotesAutomation
  module Utilities
    module HtmlGenerationUtilities
      # Generate the “last week” page grouping pages by the number of weeks ago they were modified.
      def generate_lastweek_page(pages, outdir)
        today = Date.today
        pages_by_weeks_ago = Hash.new { |h, k| h[k] = [] }
        # Sort pages in reverse order by modification time.
        pages.values.sort_by(&:mtime).reverse.each do |p|
          daysago = (today - Time.at(p.mtime).to_date).to_i
          week = (daysago - 1) / 7
          pages_by_weeks_ago[week] << p
          break if daysago > 21
        end
        File.write(File.join(outdir.to_s, 'lastweek.html'),
                   render('lastweek.html', pages_by_weeks_ago: pages_by_weeks_ago))
      end

      # Generate a search index page from the pages.
      def generate_search(pages, outdir)
        index = pages.values.each_with_index.map do |page, i|
          # Use Nokogiri to extract text content from the rendered HTML.
          doc = Nokogiri::HTML(page.html)
          { id: i,
            title: page.title,
            contents: doc.text,
            title_path: page.titlepath,
            link_path: page.link_path }
        end
        File.write(File.join(outdir.to_s, 'search.html'),
                   render('search.html', index: index))
      end

      # Generate the main index page (with lists of recently created and updated pages).
      def generate_index_page(tree, pages, outdir, recent)
        # Get the most recently created pages.
        by_ctime = pages.values.sort_by(&:ctime).reverse.first(recent)
        recently_created = by_ctime.map(&:link_path)
        by_mtime = pages.values.select { |p| !recently_created.include?(p.link_path) && (p.mtime != p.ctime) }
                        .sort_by(&:mtime).reverse.first(recent)
        File.write(File.join(outdir.to_s, 'index.html'),
                   render('index.html', recently_created: by_ctime, recently_updated: by_mtime, tree: tree))
      end

      # Generate an Atom feed file using the template.
      def generate_feed(pages, outfile, recent)
        sorted = pages.values.sort_by(&:mtime).reverse
        posts = sorted.first(recent)
        posts.each do |p|
          if p.html_escaped_content.to_s.empty?
            # Render the content if not already rendered.
            p.html_escaped_content = CGI.escapeHTML(render_content(p))
          end
        end
        File.write(outfile.to_s,
                   render('atom.xml', posts: posts, timestamp: rfc3339_time(Time.now.to_f)))
      end

      # Generate feeds for the root and any subdirectories specified.
      def generate_feeds(tree, pages, feeds, outdir, recent)
        generate_feed(pages, Pathname.new(File.join(outdir.to_s, 'atom.xml')), recent)
        feeds.each do |feed|
          subtree = tree.find_dir(feed)
          raise "Unable to find feed directory: #{feed}" if subtree.nil?

          generate_feed(subtree.child_pages, Pathname.new(File.join(outdir.to_s, "#{feed}.atom.xml")), recent)
        end
      end

      # Generate directory pages for each subdirectory in the file tree.
      def generate_dir_pages(root, pages, outdir)
        root.children.each do |child|
          next unless child.dir

          out_path = File.join(outdir.to_s, "#{child.reldir}.html")
          File.write(out_path, render('dir.html', tree: child))
          generate_dir_pages(child, pages, outdir)
        end
      end
    end
  end
end
