require 'nokogiri'

module BlogPostMetadata
  def blog_plain_text(html)
    fragment = Nokogiri::HTML.fragment(html.to_s)
    fragment.css('script, style, pre, code, figure').remove
    fragment.css('p, div, li, blockquote, h1, h2, h3, h4, h5, h6, br').each do |element|
      element.add_next_sibling(Nokogiri::XML::Text.new(' ', fragment.document))
    end
    fragment.text.gsub(/[[:space:]]+/, ' ').strip
  end

  def blog_language(text)
    return 'Japanese' if text.match?(/[\p{Hiragana}\p{Katakana}]/)
    return 'Mandarin Chinese' if text.match?(/\p{Han}/)
    return 'English' if text.match?(/\p{Latin}/)

    nil
  end
end

Liquid::Template.register_filter(BlogPostMetadata)
