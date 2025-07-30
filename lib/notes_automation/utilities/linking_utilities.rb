# frozen_string_literal: true

module NotesAutomation
  module Utilities
    module LinkingUtilities
      IMAGE_LINK_REGEX = /!\[\[(.*?)\]\]/  # Regex for image “wikilinks”: ![[some image]]
      CROSSLINK_REGEX = /\[\[(.*?)\]\]/    # For crosslink replacement (again, using [[...]] syntax)

      # -------------------------------
      # Attachment replacement for image links
      # -------------------------------

      # Return a lambda that will be used to replace attachment markdown with HTML.
      def attachment_replacer(pages, attachments)
        lambda do |match|
          filename = match[1]
          linked_att = find(pages, attachments, filename)
          if linked_att.nil?
            err('Unable to find attachment', filename)
            ''
          else
            path = linked_att.link_path
            # Determine what kind of file it is and generate appropriate HTML.
            if filename.end_with?('.pdf')
              %(<iframe src="/#{path}" width="800" height="1200"></iframe>)
            elsif filename.end_with?('.mov')
              %(<video controls><source src="/#{path}" type="video/quicktime" /><a href="/#{path}">download</a></video>)
            elsif filename.end_with?('.mp4')
              %(<video controls><source src="/#{path}" type="video/mp4" /><a href="/#{path}">download</a></video>)
            elsif filename.end_with?('.webm')
              %(<video controls><source src="/#{path}" type="video/webm" /><a href="/#{path}">download</a></video>)
            else
              %(<a href="/#{path}"><img class="bodyimg" src="/#{path}"></a>)
            end
          end
        end
      end

      # Replace image wikilinks (e.g. ![[image.png]]) with appropriate HTML.
      def substitute_images(pages, attachments)
        replacer = attachment_replacer(pages, attachments)
        pages.each_value do |page|
          page.source = page.source.gsub(IMAGE_LINK_REGEX, &replacer)
        end
      end

      # -------------------------------
      # Crosslink replacement for internal links
      # -------------------------------

      # Sanitize a string (used for creating anchor IDs).
      def sanitize(s)
        s.rstrip.gsub(/[^\w]/, '-').downcase
      end

      # Return a lambda for replacing crosslinks in markdown.
      def crosslink_replacer(pages)
        lambda do |match|
          rawlink = match[1]
          title = rawlink
          nicetitle = nil
          anchor = nil

          # If a pipe is present, split into page title and nicer title.
          if rawlink.include?('|')
            parts = rawlink.split('|')
            title = parts[0]
            nicetitle = parts[1]
          end

          # If a hash is present, split into title and anchor.
          if title.include?('#')
            parts = title.split('#')
            title = parts[0]
            anchor = parts[1]
          end

          linked_page = find(pages, {}, title)
          # If no matching page is found, leave the text unchanged.
          if linked_page
            linktitle = nicetitle || title
            anchor_part = anchor ? "##{sanitize(anchor)}" : ''
            %(<a href="/#{linked_page.link_path}#{anchor_part}" class="internal-link">#{linktitle}</a>)
          else
            err('Unable to find page', title)
            match[0]
          end
        end
      end

      # Replace crosslinks in markdown (i.e. [[page]] or [[page|nice title]]).
      def substitute_crosslinks(pages)
        replacer = crosslink_replacer(pages)
        pages.each_value do |page|
          page.source = page.source.gsub(CROSSLINK_REGEX, &replacer)
        end
      end
    end
  end
end
