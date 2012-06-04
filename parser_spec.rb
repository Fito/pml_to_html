require 'rubygems'
require 'rspec'
require 'nokogiri'

DIR = File.dirname(__FILE__)
require "#{DIR}/parser.rb"

describe Parser do
  before do
    @parser = Parser.new
    @parser.load("#{DIR}/chapter.xml")
  end
  
  it 'loads the file as a string' do
    @parser.document.class.should == String
  end
  
  it 'should replace the doctype with html' do
    @parser.change_doctype.should include("<!DOCTYPE html>")
    @parser.change_doctype.should_not include("<?xml")
  end
  
  it 'replaces <chapter> with <div class="chapter" id="some_id">' do
    @parser.replace_chapter.should include("<div class='chapter' id='ch.ruby-intro'>")
    @parser.replace_chapter.should include("</div>")
  end
  
  it 'replaces the first <title> after a <chapter> with <h2 class="chapter_title">' do
    @parser.replace_title.should include("<h2 class='chapter_title'>")
    @parser.replace_title.should include("</h2>")
  end
    
  it 'replaces <title> with <h3 class="title">' do
    @parser.replace_title.should include("<h3 class='title'>")
    @parser.replace_title.should include("</h3>")
  end
  
  it 'replaces <footnote> with <span class="footnote">' do
    @parser.replace_footnote.should include("<span class='footnote'>")
    @parser.replace_footnote.should include("</span>")
    
  end
  # 
  it 'replaces <joeasks> with <div class="ask_sidebar">' do
    @parser.replace_joeasks.should include("<div class='ask_sidebar'>")
    @parser.replace_joeasks.should include("</div>")
  end
  
  it 'replaces <firstuse> with <span class="firstuse">' do
    @parser.replace_firstuse.should include("<span class='firstuse'>")
    @parser.replace_firstuse.should include("</span>")
  end
  
  it 'replaces <author> with <span class="author">' do
    @parser.replace_author.should include("<span class='author'>")
    @parser.replace_author.should include("</span>")
  end
  
  it 'replaces <commandname> with <span class="commandname">' do
    @parser.replace_commandname.should include("<span class='commandname'>")
    @parser.replace_commandname.should include("</span>")
  end
  
  it 'replaces <method> with <span class="method">' do
    @parser.replace_method.should include("<span class='method'>")
    @parser.replace_method.should include("</span>")
  end
  
  it 'replaces <emph> with <em class="emph">' do
    @parser.replace_emph.should include("<em class='emph'>")
    @parser.replace_emph.should include("</em>")
    
  end
  
  it 'replaces <sidebar> with <div class="sidebar" id="some_id">' do
    @parser.replace_sidebar.should include("<div class='sidebar' id='side.dsl'>")
    @parser.replace_sidebar.should include("</div>")
  end
    
  it 'inserts the href as content of an <a> tag' do
    @parser.replace_ref.should include("<a class='ref' href='ch.rspec-intro'>ch.rspec-intro</a>")
  end
  
  it 'replaces <sect1> with <div class="sect1" id="some_id">' do
    @parser.replace_sect1.should include("<div class='sect1' id='ruby.lang.tools.syntax'>")
    @parser.replace_sect1.should include("</div>")
  end
  
  it 'replaces <sect2> with <div class="sect2" id="some_id">' do
    @parser.replace_sect2.should include("<div class='sect2' id='ruby.poetry.syntax'>")
    @parser.replace_sect2.should include("</div>")
  end
  
  it 'replaces <sect3> with <div class="sect3" id="some_id">' do
    @parser.replace_sect3.should include("<div class='sect3'")
    @parser.replace_sect3.should include("</div>")
  end
  
  it 'replaces &lquot; with &ldquo;' do
    @parser.replace_quotes.should include('&ldquo;')
  end
  
  it 'replaces &rquot; with &rdquo;' do
    @parser.replace_quotes.should include('&rdquo;')
  end
  
  it 'replaces <class> with <span class="rubyclass">' do
     @parser.replace_class.should include("<span class='rubyclass'>")
     @parser.replace_class.should include("</span>")
     
  end
  
  it 'replaces <ic> with <span class="ic">' do
     @parser.replace_ic.should include("<span class='ic'>")
     @parser.replace_ic.should include("</span>")
  end
  
  it 'escapes symbols "<" with &#060; and ">" with &#062' do
    @parser.escape_symbols.should include('&#060;')
    @parser.escape_symbols.should include('&#062;')
  end
  
  it 'replaces <constant> with <span class="constant">' do
    @parser.replace_constant.should include("<span class='constant'>")
    @parser.replace_constant.should include("</span>")
    
  end
  
  it 'replaces <filename> with <span class="filename">' do
    @parser.replace_filename.should include("<span class='filename'>")
    @parser.replace_filename.should include("</span>")
  end
  
  it 'replaces <keyword> with <span class="keyword">' do
    @parser.replace_keyword.should include("<span class='keyword'>")
    @parser.replace_keyword.should include("</span>")
  end
  
  it 'replaces <ed> with <span class="ed">' do
    @parser.replace_ed.should include("<span class='ed'>")
    @parser.replace_ed.should include("</span>")
  end
  
  it 'replaces <figure> with <div class="figure" id="some_id">' do
    @parser.replace_figure.should include("<div class='figure' id='fig.routing-error'>")
    @parser.replace_figure.should include("</div>")
  end
  
  it 'replaces <imagedata fileref="some_file"/> with <img class="imagedata" src="some_file"/>' do
  	@parser.replace_imagedata.should include("<img class='imagedata' src='images/controllers/missing-courses-controller.png'>")
  	@parser.replace_imagedata.should include("</img>")
  end
  
  it 'should parse everything' do
    methods = [:change_doctype, :replace_constant, :replace_chapter, :replace_title,
               :replace_footnote, :replace_joeasks, :replace_firstuse, :replace_ed, 
               :replace_author, :replace_commandname, :replace_method, :replace_emph,
               :replace_sidebar, :replace_filename, :replace_keyword, :replace_ref,
               :replace_sect1, :replace_sect2, :replace_sect3, :replace_quotes, :replace_class,
               :replace_ic, :escape_symbols, :replace_selfclosing_code]
    
    methods.each do |method|
      @parser.should_receive(method)
    end
    @parser.replace_all
  end

  it 'replaces the selfclosing code tag with <a>' do
    @parser.replace_selfclosing_code.should include("<a class='code' href='code/full_name/person.rb' part='define_method'>")
    @parser.replace_selfclosing_code.should include("<a class='code' href=")
  end
  
  it 'should return a string after parsing everything' do
    @parser.replace_all.class.should == String
  end
end 























