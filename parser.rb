require 'rubygems'
require 'nokogiri'

class Parser
  def load(filepath)
    file = File.open(filepath)
    @document = Nokogiri::XML(file)
    file.close
    
    @string_document = File.read(filepath).to_s
  end
  
  def document
    @string_document
  end
  
  def replace_tag(xml_tag, html_tag, html_class)
    @string_document.gsub!(/<#{xml_tag}>/, "<#{html_tag} class='#{html_class}'>")
    @string_document.gsub!(/<\/#{xml_tag}>/, "<\/#{html_tag}>")
    @string_document
  end
    
  def replace_tag_with_attribute(xml_tag, xml_attribute, html_tag, html_class, html_attribute)
    @document.css(xml_tag).each do |tag|
      attribute = tag.attributes[xml_attribute]
      @string_document.gsub!(/<#{xml_tag}\s#{xml_attribute}="(#{attribute})">/, "<#{html_tag} class='#{html_class}' #{html_attribute}='#{attribute}'>")
      @string_document.gsub!(/<\/#{xml_tag}>/, "<\/#{html_tag}>")
    end
    @string_document
  end
  
  def replace_tag_with_content(xml_tag, html_tag, html_class, html_attribute)
    @document.css(xml_tag).each do |tag|
      content = tag.content
      @string_document.gsub!(/<#{xml_tag}>#{content}<\/#{xml_tag}>/, "<#{html_tag} class='#{html_class}' #{html_attribute}='#{content}'>#{content}<\/#{html_tag}>")
    end
    @string_document
  end
  
  def replace_selfclosing_tag_with_attribute(xml_tag, xml_attribute, html_tag, html_class, html_attribute)
    @document.css(xml_tag).each do |tag|
      attribute = tag.attributes[xml_attribute]
      @string_document.gsub!(
        /<#{xml_tag}\s#{xml_attribute}="(#{attribute})"\s*\/>/, 
        "<#{html_tag} class='#{html_class}' #{html_attribute}='#{attribute}'></#{html_tag}>")
    end
    @string_document
  end
  
  def replace_selfclosing_tag_with_attributes(xml_tag, xml_attribute_1, xml_attribute_2, html_tag, html_class, html_attribute_1, html_attribute_2)
    @document.css(xml_tag).each do |tag|
      attribute_1 = tag.attributes[xml_attribute_1]
      attribute_2 = tag.attributes[xml_attribute_2]    
      if attribute_1 && attribute_2
        @string_document.gsub!(
          /<#{xml_tag}\s#{xml_attribute_1}="(#{attribute_1})"\s+#{xml_attribute_2}="(#{attribute_2})"\s*\/>/, 
          "<#{html_tag} class='#{html_class}' #{html_attribute_1}='#{attribute_1}' #{html_attribute_2}='#{attribute_2}'></#{html_tag}>")
      end
    end
    @string_document
  end
  
  def change_doctype
    @string_document.slice!(/<\?xml.*>/)
    @string_document.gsub!(/<!DOCTYPE\s.*>/, '<!DOCTYPE html>')
    @string_document
  end
  
  def replace_selfclosing_code
    replace_selfclosing_tag_with_attributes('code', 'file', 'part', 'a', 'code', 'href', 'part')
    replace_selfclosing_tag_with_attribute('code', 'file', 'a', 'code', 'href')
  end
  
  def replace_chapter
    replace_tag_with_attribute('chapter', 'id', 'div', 'chapter', 'id')
  end
  
  def replace_title
    @string_document.sub!(/<chapter.*>.*\n*\s*<title>/, "<h2 class='chapter_title'>")
    @string_document.sub!(/<\/title>/, "<\/h2>")
    replace_tag('title', 'h3', 'title')
  end
  
  def replace_footnote
    replace_tag('footnote', 'span', 'footnote')
  end
  
  def replace_joeasks
    replace_tag('joeasks', 'div', 'ask_sidebar')
  end
  
  def replace_firstuse
    replace_tag('firstuse', 'span', 'firstuse')
  end
  
  def replace_ed
    replace_tag('ed', 'span', 'ed')
  end
  
  def replace_author
    replace_tag('author', 'span', 'author')
  end
  
  def replace_commandname
    replace_tag('commandname', 'span', 'commandname')
  end
  
  def replace_method
    replace_tag('method', 'span', 'method')
  end
  
  def replace_emph
    replace_tag('emph', 'em', 'emph')
  end
  
  def replace_sidebar
    replace_tag_with_attribute('sidebar', 'id', 'div', 'sidebar', 'id')
  end 
  
  def replace_ref
    @document.css('ref').each do |tag|
      attribute = tag.attributes['linkend']
      if @string_document.slice(/<ref\n(.*)linkend="(#{attribute})"\/>/)
        @string_document.gsub!(/<ref\n(.*)linkend="(#{attribute})"\/>/, "<a class='ref' href='#{attribute}'>#{attribute}</a>")
      elsif @string_document.slice(/<ref\slinkend="(#{attribute})"\/>/)
        @string_document.gsub!(/<ref\slinkend="(#{attribute})"\/>/, "<a class='ref' href='#{attribute}'>#{attribute}</a>")
      end
    end
    @string_document
  end 

  def replace_sect1
    replace_tag_with_attribute('sect1', 'id', 'div', 'sect1', 'id')
  end
  
  def replace_sect2
    replace_tag_with_attribute('sect2', 'id', 'div', 'sect2', 'id')
  end
  
  def replace_sect3
    replace_tag_with_attribute('sect3', 'id', 'div', 'sect3', 'id')
  end
  
  def replace_quotes
    @string_document.gsub!('&lquot','&ldquo')
    @string_document.gsub!('&rquot','&rdquo')
    @string_document
  end
  
  def replace_class
    replace_tag('class', 'span', 'rubyclass')
  end
  
  def replace_ic
    replace_tag('ic', 'span', 'ic')
  end
  
  def escape_symbols
    while @string_document.slice(/\#<[A-Z]/) != nil
      if @string_document.slice(/\#<[A-Z]+\S+>/)
        object = @string_document.slice(/\#<[A-Z]+\S+>/).slice(/[A-Z]+\S+/)
        @string_document.gsub!(/\#<[A-Z]+\S+>/,"#&#060;#{object}&#062;")
      elsif @string_document.slice(/#<[A-Z]+[a-z]+\s+/)
        object = @string_document.slice(/#<[A-Z]+[a-z]+\s+/).slice(/[A-Z]+\S+/)
        @string_document.gsub!(/#<[A-Z]+[a-z]+\s+/,"#&#060;#{object}")
      end
    end
    @string_document
  end
  
  def replace_constant
    replace_tag('constant', 'span', 'constant')
  end
  
  def replace_filename
     replace_tag('filename', 'span', 'filename')
  end
  
  def replace_keyword
     replace_tag('keyword', 'span', 'keyword')
  end
  
  def replace_figure
  	replace_tag_with_attribute('figure', 'id', 'div', 'figure', 'id')
  end
  
  def replace_imagedata
  	replace_selfclosing_tag_with_attribute('imagedata', 'fileref', 'img', 'imagedata', 'src')
  end
  
  def replace_url
    replace_tag_with_content('url', 'a', 'url', 'href')
  end
  
  def replace_all
    change_doctype
    replace_constant
    replace_chapter
    replace_title
    replace_footnote
    replace_joeasks
    replace_firstuse
    replace_ed
    replace_author
    replace_commandname
    replace_method
    replace_emph
    replace_sidebar
    replace_filename
    replace_keyword
    replace_ref
    replace_sect1
    replace_sect2
    replace_sect3
    replace_quotes
    replace_class
    replace_ic
    escape_symbols
    replace_selfclosing_code
    replace_figure
    replace_imagedata
    replace_url
    @string_document
  end
   
end















