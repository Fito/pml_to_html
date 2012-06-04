<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.start">
  <title>Before You Start</title>
  
  <p>Before we start coding we want to be sure we have our development set up with all of the tools that we need.  This
  chapter explains what we need on our system to build applications in Ruby on Rails. If
  you have Ruby and Rails installed and want to dive right in, that’s cool. But before skipping this chapter,
  let’s first check that we have the right version of Rails and it is working, by typing <ic>rails -v</ic> on the command line.
  We should see the version printed afterwards.  Throughout this book, we’ll show you command-line output where the
  <ic>$</ic> is our command prompt with what we’re typing after a space on the same line. Then we’ll show you the output
  of the command, like this: <ed>I think you can kind of skip the "we" stuff here - it's ok to talk to the reader direectly - you did that a little bit in this paragraph. If you want them to check the version, that's fine, just tell them how to do it. We want to use "we" when we are actually working through things with our reader, like excercises. So it's not a hard and fast rule that you should always use "we". Clear as mud?</ed></p>
<code language="session">
$ rails -v
Rails 3.0.3
</code>
<p><ed>here too, you've got a mix of we and you. It's probably ok to stick with "you" here. </ed>To get the most out of this book, we should all be using the same version of Rails. Any version that starts with 3.0
is fine (like 3.0.1 or 3.0.3). If you don’t have the right
version or got an error when you tried to run the <commandname>rails</commandname> command, keep reading and we’ll help you
figure it out. Or if you just want to know a bit more about about what Rails sits on top of and nearby, read on! </p>
<sect1>
<title>Rails Dependencies</title> 
<p>In order to understand the various components and sub-systems that work and play with Rails, we’ve split them into a few
categories. First Rails has a few core dependencies -- if you don’t have these installed, Rails just won’t work at all: </p>
<ul>
<li><p>Ruby</p></li>
<li><p>Ruby gems</p></li>
<li><p>Rails</p></li>
</ul>
<p>Also there are a number of other tools and libraries that your application will
likely use and will be part of the book. These aren’t technically required for your Rails app to work, but are important
elements of our toolbox as Rails engineers:<ed>is it really worth talking about these now? How about "Along the way, we'll install other libraries as we work through the book" or something? </ed></p>
<ul>
<li><p>Database</p></li>
<li><p>Terminal or Command Prompt</p></li>
<li><p>Test Framework</p></li>
<li><p>Editor / IDE</p></li>
</ul>
<p>We’ll talk about each of the core dependencies and other components which we’ll need in our toolbox to begin, what
version of each we need to build the app in the book and a bit about what its for.</p>
</sect1>
<sect1>
<title>Core Dependencies</title>
<p>To be able to run the <commandname>rails</commandname> command and build the most minimal application, you will need Ruby and the Ruby Gems packaging manager, and, of course Rails. On Mac and
Linux, we highly recommend installing Ruby and Ruby Gems with
rvm<footnote><p><url>http://rvm.beginrescueend.com/</url></p></footnote>. <ed>windows installer talks about Git. What about git for mac?</ed> On Windows, we can install Ruby, Rails, and Git all at
once with RailsInstaller<footnote><p><url>http://railsinstaller.org/</url></p></footnote>.</p>
<sect2>
<title>Ruby</title>
<p>Great Rails developers are great Ruby developers. Rails is a framework written in the Ruby language.
  <ed>what's missing here? Why are we doing version checking? Is this sentence really needed? Have you said this previously?</ed></p>
<code language="session">
$ ruby -v
ruby 1.9.2p0 (2010-08-18 revision 29036) [x86_64-darwin10.4.0]
</code>
<p>Ruby 1.8.7 or higher is required for Rails 3.  Ruby 1.9.2 or higher is recommended.</p>
</sect2>
<sect2>
<title>Ruby Gems</title>
<p>A gem is a ruby library. Rubyists like to make up cute names for their creations. Jim Weirich was no exception when
he created Ruby Gems.  A gem is a precious bit of Ruby code that some developer has carved out for its usefulness. 
The name <emph>gem</emph> speaks to the Ruby aesthetic that our code should be beautiful and bring us delight as
well as having practical uses. Ruby Gems has a fabulous packaging system that supports having different versions installed
as well as installing native code extensions. We can also easily install libraries from local or remote sources.  To see
what version of Ruby Gems we have installed:
</p>
<code language="session">
$ gem -v
1.3.7
</code>
<p>To see the gems we have installed:</p>
<code language="session">
$ gem list
</code>
<p>To install a new gem</p>
<code language="session">
$ gem install <name>
</code>
<p>on Mac or Linux (without rvm), we need to preface the command with sudo (which will prompt us to enter our admininstrator password):</p>
<code language="session">
$ sudo gem install <name>
</code>
<p>When we’re developing in Rails, we often add gems that offer functionality that is common to many web applications.
Ruby engineers are exuberant in providing open source implementations of any code that is generally useful, creating an
ecosystem of tools that adds to our velocity as Rails engineers.</p>
</sect2>
</sect1>
<sect1>
<title>Gems We’ll Use Directly</title>
<p>Rails depends on a large collection of gems. In fact, Rails itself is split into many gems. Most of these we don’t
need to know anything about; however, there
are two gems that we will interact with directly on the command line: Bundler and Rake.  Bundler and Rake may each be
used with or without Rails and they are installed automatically as dependent gems when we install Rails.</p>
<sect2>
<title>Bundler</title>
<p>Bundler manages gem dependencies. During the development of Rails 3, Rails core team members, Yehuda Katz and Carl
Lerche created Bundler to solve challenges that many Rails development teams faced with previous systems for managing
gem dependencies.  Carl and Yehuda develop all of their code by pair programming, which
explains why we can find the Bundler source under a blend of their two names: <emph>carlhuda</emph> on
github<footnote><p><url>https://github.com/carlhuda/bundler</url></p></footnote>. With prior systems for managing dependencies that Bundler is required for Rails 3, but may be optionally used
by Rails 2 (or any Ruby project).</p>
<p>The <commandname>bundle</commandname> command will install all dependent gems specified in the
<filename>Gemfile</filename> which is kept the root of your app.</p> 
<p>To see a list of the bundler commands:</p>
<code language="session">
$ bundle --help
</code>
<p>Since bundler is a gem, <ed>can you go through and fix all these improper capitalization things like Gem, Ruby, etc? and is it Ruby Gems or RubyGems? I'm not going to mark any more of them up, so please just do a quick sweep of your book.</ed> we can see its version with:</p>
<code language="session">
$ gem list bundler

*** LOCAL GEMS ***

bundler (1.0.0)

</code>
<p>Rails 3 will not use any gem unless it is loaded by Bundler.  Prior versions of Rails would use any gem
installed on our system.  While the Rails 3 restriction might seem inconvenient at first, it is very helpful when we
inevitably deploy our application to a different machine.</p>
</sect2>
<sect2>
<title>Rake</title>
<p>Rake lets us run Ruby scripts with dependencies and manage sets of utility scripts. Created by the prolific Jim
Weirich, Rake is like the unix tool
<commandname>make</commandname> for Ruby. A <emph>rake task</emph> is some Ruby code with some additional annotations
that name the task and, optionally, specify dependencies.</p>
<p>Just like with all gems, we can see its version with:</p>
<code language="session">
$ gem list rake

*** LOCAL GEMS ***

rake (0.8.7)
</code>

<p> We
use many rake tasks routinely in our Rails development and often write our own. Where we might have used a <ic>bash</ic>
script in a Java environment for build automation or data import, with Rails we will typically write a Rake task. We’ll
learn how to write a Rake task in  <ref linkend="ch.rake"/>.<ed>are you going to be using bundle exec in this book?</ed></p>

</sect2>
</sect1>
<sect1>
<title>The Rest of our Toolbox</title>
<p>As Rails developers we will need more in our toolbox than just Rails and its core dependencies. We typically
interact with Rails on the command line, use an IDE or some kind of code editor, a database, source code control and,
since this is Ruby, and we want to make it easy on ourselves, we include one or more test frameworks.</p>
<sect2>
<title>Database</title>
<p>A databse is not strictly required for a web application built with Rails, but most web applications
provide a user interface on a relational database. In this book, we’ll use SQLite since it is easy to install and is
great for experimentation. The Rails code that we will develop will be database-independent, so we can use any of the
supported databases for deployment or continued development.</p>
  
<joeasks>
<title>When would we write a Rails application without a database?</title>
<p><ed>this doesn't read right. The question was "using without a database." not "without a relational database". Also, I don't think this adds much. The part about web services is stronger. But evene more, I'd lose the sentence in the previous section about "while a db is not required" and change the joeasks to "can I use Rails without a database" instead. What do you think?</ed>We can use Rails with a “noSQL” database, such as MongoDB or CouchDB, store our data elsewhere or not store data at all. A common use case for
using Rails without a database would be to connect to web services potentially storing data there or performing a
transaction such as making a purchase or other transaction using an external service.</p>
<p>Using name-value stores and other
non-relational approaches to storing data are increasingly popular for large scale data and cloud hosting. Sometimes,
such as with Google App Engine, we will store and retrieve our data using <class>DataMapper</class> instead of
<class>ActiveRecord</class>; however, many applications use “no SQL” data stores for high volume data that doesn’t require transactions and is not highly relational
in conjunction with a SQL database for core application data. In any case, it is valuable to first understand how to build web
applications that provide a user interface on a relational (SQL) database. </p>
</joeasks>
<sect3 id="sec.sql">
<title>Understanding SQL</title>
<p>We rarely write SQL directly in our Rails code, but to understand what our app is really doing in the
database, we’ll want to occasionally look at the SQL called by our app. If you don’t already know SQL, refer to <ref
linkend="fig.database-commands" /> for a quick cheat sheet of the basic commands.</p>
<figure id="fig.database-commands">
  <title>Database Commands</title>
  <imagedata fileref="images/database-commands.png" />
</figure>
</sect3>
<sect3 id="sec.dbconsole">
<title>The <commandname>dbconsole</commandname> command</title>
<p>One of the Rails commands <ic>rails dbconsole</ic> invokes our database console. Every database comes with a command
line tool which has a unique command to invoke it and sometimes different names for command line options to specify the user, password and database name. The dbconsole command simply calls the appropriate database console app. So for SQLite, rails dbconsole is the same as:</p>
<code language="session">
$ SQLite3 <my_development_database>
</code>
<p>and for MySql, it is the same as:</p>
<code language="session">
$mysql –u<name> –p<password> <my_development_database> 
</code>
<p>The <commandname>dbconsole</commandname> is a very useful tool for inspecting the contents of the database when we
are debugging or want to take a quick look at what tables and schema exist for our app.</p>
</sect3>
<sect3>
<title>Using a Different Database</title>
<p>If you want to use Rails with a different database, there are shortcuts for creating different configuration files for the most commonly used databases. For example, to generate a Rails application with a default configuration for MySql, you would use the following command:</p>
<code language="session">
$ rails new –d mysql app_name
</code>
<p>The contents of the <filename>database.yml</filename> file is the only difference in the generated app when calling “rails new” with the –d option. </p>
<p><ed>probably better if you use a definition list for this especially if it’s a sidebar.</ed></p>
<p>The following databases are supported:</p>
<table style="outerlines">
  <thead>
    <col><p>Database</p></col>
    <col><p>Configuration Option</p></col>
  </thead>
  <row> <col><p>SQLite</p></col><col><p>default</p></col> </row>
  <row> <col><p>MySQL</p></col><col><p>-d mysql</p></col> </row>
  <row> <col><p>PostgreSQL</p></col><col><p>-d postgresql</p></col> </row>
  <row> <col><p>Oracle</p></col><col><p>-d oracle</p></col> </row>
  <row> <col><p>DB2</p></col><col><p>-d ibm_db</p></col> </row>
  <row> <col><p>Frontbase</p></col><col><p>-d frontbase</p></col> </row>
  <row> <col><p>SQL Server</p></col><col><p>manual configuration required</p></col> </row>
  <row> <col><p>Sybase</p></col><col><p>manual configuration required</p></col> </row>
</table>

<p>When we use a different database, we need to install the database-specific driver so that our Ruby code can talk to
the database. Each of the supported databases requires a separate gem to connect to that database from Ruby.</p>
</sect3>
</sect2>
<sect2>
<title>Terminal or Command Prompt</title>
<p><ed>These tooling conventions don't feel right. This is really important stuff that might be better off in the preface. If I see I can skip this chapter, and then get confused cos I don't know what you're talking about with some of these unix commands, I might be lost. I'd move this, and maybe the section on text editors too. What do you think?</ed> Rails development relies heavily on command-line tools. On Mac or Linux, we run these in the <emph>terminal</emph>,
and on Windows, in the <emph>command prompt</emph>. We like running <emph>gitbash</emph> aka
<emph>msysgit</emph><footnote><p><url>http://code.google.com/p/msysgit/</url></p></footnote> on Windows, which is
distributed with git by the helpful folks who create git for Windows. Gitbash allows us to use the same Unix commands for
moving and copying files as we use on Mac and Linux.</p>
<p>Here’s a list of the Unix commands we find that we need to know while we we’re developing web apps: </p>
<dl>
<dt><commandname>cd</commandname></dt>
<dd><p>change directory</p></dd>
<dt><commandname>pwd</commandname></dt>
<dd><p>print working directory, displays the path of the current directory</p></dd>
<dt><commandname>cp</commandname></dt>
<dd><p>copy a file, use it like <ic>cp myfile newfile</ic></p></dd>
<dt><commandname>cp -r</commandname></dt>
<dd><p>copy a directory and all of its contents, use it like <ic>cp -r mydir newdir</ic></p></dd>
<dt><commandname>mv</commandname></dt>
<dd><p>move or rename a file or directory, use it like <ic>mv myfile newfile</ic></p></dd>
</dl>
</sect2>
<sect2>
<title>Editor or IDE</title>
<p>There are a lot of great IDEs that work well for Rails, such as RubyMine, Aptana’s RadRails, TextMate (for the Mac)
and Komodo. Every code editor we’ve tried lately has Ruby syntax highlighting, which is essential for spotting errors
when developing. Additionally, when developing, it is handy to have a project view to see the directory hierarchy, since
when we develop a Rails application, we often switch between files to follow the flow of control or see the test and the
tested code. We highly recommend finding a IDE you love and learning its ins and outs.</p>
</sect2>
<sect2>
<title>Test Frameworks</title>
<p>Ruby has a plethora of test frameworks. Test::Unit, the default option for Rails, was Ruby’s first test framework.
Originally written by Nathaniel Talbot, it is small, fast, and seems to have been largely influenced by JUnit, the unit
testing framework from the Java language. Test::Unit was bundled with Ruby 1.8; however, with 1.9, Ruby moved to
MiniTest.</p>
<p> In this book, we use RSpec, created by David Chelimsky. RSpec grew out of the behavior-driven development movement
and is focused on the idea that when we write our code test first, we are actually writing a specification of our code.
The key advantage of RSpec for both learning and in building production code is the clarity of its output.</p>


<p><ed>duplicate thought? you say this in the previous para. </ed>Throughout this book, we use RSpec, created by David Chelimsky. RSpec grew out of the behavior-driven development movement
and is focused on the idea that when we write our code test first, we are actually writing a specification of our code.
The key advantage of RSpec for both learning and in building production code is the clarity of its output. Like all of
the Ruby test frameworks, RSpec is distributed as a gem. Since we’re building a Rails application, we’ll use the
<commandname>rspec-rails</commandname> gem that includes RSpec and some additional helpers for Rails. Let’s install it now:</p>
<code language="session">
$ gem install rspec-rails
</code>
<p>We also use Capybara, which is also a gem, to install it:</p>
<code language="session">
$ gem install capybara
</code>
<p><ed>This needs some sort of transition to the next topic. Also, I know you think a lot of this stuff really needs to be here, but focus on your reader - how much of the content in this chapter do they really need to know about? Are you trying to pre-emptively handle any questions people might have? There are some things in here, like background information, that is actually very useful. But some other parts just don't seem absolutely essential. I'll leave it up to you, but I suggest you give it a read again and see what you think</ed></p>

</sect2>
</sect1>
</chapter>                                                                                                                    
