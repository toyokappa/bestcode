module MarkdownHelper
  class HTMLwithCoderay < Redcarpet::Render::HTML
    def block_code(code, language)
      lang = language.presence || "md"
      CodeRay.scan(code, lang).div
    end
  end

  def markdown(text)
    unless @markdown
      options = {
        filter_html: true,
        hard_wrap: true
      }
      extensions = {
        no_intra_emphasis: true,
        tables: true,
        fenced_code_blocks: true,
        autolink: true,
        disable_indented_code_blocks: false,
        strikethrough: true,
        lax_spacing: true,
        space_after_headers: true,
        superscript: false,
        underline: false,
        highlight: false,
        quote: false,
        footnotes: false
      }
      renderer = HTMLwithCoderay.new(options)
      @markdown = Redcarpet::Markdown.new(renderer, extensions)
    end

    @markdown.render(text).html_safe
  end
end
