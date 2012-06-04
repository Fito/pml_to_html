<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.preface">
<title>Come On In</title>
<p>We’re diving into Ruby on Rails test first. We’ll be using techniques designed to create robust production code that
can be delivered quickly and adapt nimbly to new business requirements. We’ll experience testing as a software
development methodology, rather than in its traditional use in isolating and resolving defects. In most of the book,
we’ll focus on testing as an effective way to learn a new language and framework.</p>
<p>As kids we explore our world through experimentation. Researchers test hypotheses, learning about our world through
the scientific method. As programmers, we have test frameworks, originally developed for verifying defects, that can be
applied to learning.</p>
<p>Learning programming through testing has been independently discovered by dozens of engineers as a natural way to learn. We use two different kinds of testing in this book.
First we do exploratory testing: like kids exploring nature, we poke around Ruby using an
interactive console called <commandname>irb</commandname> (Interactive RuBy), Ruby’s own REPL (Read Eval Print Loop). Then, we use test
frameworks RSpec and Capybara.</p>
<p>Using test first development techniques, we have the opportunity to see all of the error
messages we will later see in the wild. We explore APIs in detail. We don’t just learn recipes for building an
application with Ruby on Rails – we learn the fundamentals of how the different parts of the framework fit together.
Much of time saving benefit of using a framework is created by the built-in behaviors that happen without our writing
any code at all,
and those are the hardest to learn. Using test first techniques, we can see those behaviors more
clearly and better understand what the framework does for us.
</p>
<p>A happy side benefit of a test first approach to learning is that we are learning to code using best practices. At the
end of the book, we will have written a whole application that includes tests. We will experience how testing helps us
effectively design our code and develop our software. We will see how testing goes beyond the bug find-fix cycle,
liberating us to write great code at high velocity.</p>
<sect1>
<title>Web Development with Rails</title>
<p>Speaking of high velocity, Ruby on Rails is a framework for building web applications that is optimized for
programmer productivity. David Hansson who created Rails in the early 2000s says that it was <emph>extracted</emph>
rather than created. He first wrote Basecamp, a popular online collaboration tool, as a web application in Ruby; then he
pulled out the code which was common to all web applications to create the Rails framework. Rails was created from a real-world use case at a time when web application design patterns were well
established. Since most web applications share a lot of common patterns and behaviors, the Rails framework speeds our
development by letting us create a lot of functionality with very little code.
</p>
<p>Rails is written in the Ruby language. When we develop Rails applications we are writing Ruby code.
First developed in the early 1990s by Japanese engineer, Yukihiro “Matz” Matsumoto, Ruby was designed not only for
programmer productivity, but also to increase programmer happiness. Matz believes that language design must follow the
same principles as user interface design, emphasizing human, rather than computer needs. Today, when time-to-market is
more often the gating factor of software development than compute power, this emphasis of Rails and Ruby on productivity
is particularly valuable.</p>
</sect1>
<sect1>
<title>Who Should Read This Book?</title>
<p>This book is written for programmers.  You’ve been developing in Java, C++, PHP or some other language, or perhaps
you studied programming in college and are considering diving back in with web development. Total beginners might want
to consider starting with Chris Pine's <bookname>Learn to Program</bookname> before jumping into this book.</p>
</sect1>
<sect1>
<title>Software We’ll Need</title>
<p>We recommend working through this book with the same versions of software that were used to write it. Almost
everything will be the same in the next incremental version of anything, but when you are learning, sometimes a small
difference can be confusing.</p>

  <p>Let’s first check that we have the right version of Rails and it is working, by typing <ic>rails -v</ic> on the command line.
  We should see the version printed afterwards.  Throughout this book, we’ll show you command-line output where the
  <ic>$</ic> is our command prompt with what we’re typing after a space on the same line. Then we’ll show you the output
  of the command, like this:</p>
<code language="session">
$ rails -v
Rails 3.0.3
</code>

<p><ed>watch the you vs. we here. It's probably ok to use "you" for these. You can tell us how to install things. We can jump to "we" when we are really doing things together.</ed>To get the most out of this book, we should all be using the same version of Rails. Any version that starts with 3.0
is fine (like 3.0.1 or 3.0.3). If you don’t have the right
version or got an error when you tried to run the <commandname>rails</commandname> command or for any of the commands in
this section, check out <ref linkend="sec.online-resources"/> for online references to installation instructions.</p>
<p>To be able to run the <commandname>rails</commandname> command and build the most minimal application, you will need Ruby and the Ruby Gems packaging manager.</p>
<sect2>
<title>Ruby</title>
<p>Great Rails developers are great Ruby developers. We need Ruby to build and run Rails applications. Check your
version:
</p>
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
<p><ed>I would very strongly suggest you lose the 'sudo' stuff here. Just tell them to use
RVM.</ed><author>Sarah:removed</author> When we’re developing in Rails, we often add gems that offer functionality that is common to many web applications.
Ruby engineers are exuberant in providing open source implementations of any code that is generally useful, creating an
ecosystem of tools that adds to our velocity as Rails engineers.</p>
</sect2>
<sect2>
<title>Database</title>
<p> In this book, we’ll use SQLite since it is easy to install and is
great for experimentation. A database is not strictly required for a web application built with Rails, but most web applications
provide a user interface on a relational database, so that’s the kind of app we’ll build. The Rails code that we will develop will be database-independent, so we can use any of the
supported databases for deployment or further development.</p>
</sect2>
<sect2>
<title>Editor or IDE</title>
<p>There are a lot of great IDEs that work well for Rails, such as RubyMine, Aptana’s RadRails, TextMate (for the Mac)
and Komodo. Every code editor we’ve tried lately has Ruby syntax highlighting, which is essential for spotting errors. Additionally, it is handy to have a project view to see the directory hierarchy, since
when we develop a Rails application, we often switch between files to follow the flow of control or see the test and the
tested code. We highly recommend finding a IDE you love and learning its ins and outs.</p>
</sect2>
<sect2>
<title>Terminal or Command Prompt</title>
<p>Rails development relies heavily on command-line tools. On Mac or Linux, we run these in the <emph>terminal</emph>,
and on Windows, in the <emph>command prompt</emph>. We like running <emph>gitbash</emph> aka
<emph>msysgit</emph><footnote><p><url>http://code.google.com/p/msysgit/</url></p></footnote> on Windows, which is
distributed with git by the helpful folks who create git for Windows. Gitbash allows us to use the same Unix commands for
moving and copying files as we use on and Linux.</p>
</sect2>
<sect2>
<title>Test Frameworks</title>
<p>Throughout this book, we use RSpec, created by David Chelimsky. RSpec grew out of the behavior-driven development movement
and is focused on the idea that when we write our code test first, we are actually writing a specification of our code.
The key advantage of RSpec both for learning and for building production code is the clarity of its output. This is the
primary reason we use RSpec. When we’re learning, clear output will help us learn from the test failures. When part of
our existing test suite fails during development of new code, being able to clearly see the failure saves time fixing
it. Also, there are many smaller test framework details that work together in RSpec to make tests easier to read and
maintain once we understand the syntax. Trust us, it’s a good way to go, but if you find later that you want to switch
or find yourself in the midst of a project that uses Test::Unit, no worries – the principles and patterns we cover in
this book apply to all test frameworks.</p> 
<p>Like all of
the Ruby test frameworks, RSpec is distributed as a gem. Since we’re building a Rails application, we’ll use the
<commandname>rspec-rails</commandname> gem that includes RSpec and some additional helpers for Rails.</p>
<p>You don’t need these gems installed right now, but here are are the versions we’ll be using:</p>
<code language="session">
$ gem list rspec

*** LOCAL GEMS ***

rspec (2.5.0)
rspec-core (2.5.2, 2.5.1)
rspec-expectations (2.5.0)
rspec-mocks (2.5.0)
rspec-rails (2.5.0)
</code>
<p>We also use Capybara for integration testing:</p>
<code language="session">
$ gem list capybara

*** LOCAL GEMS ***

capybara (0.4.1.2)
</code>
<p>Now you have everything you need to build Ruby on Rails web applications test first.</p>

<p><ed>This is a little strange.... this whole section seemed full of tagents. The "do I have to use a db" part, the
diversion into the various types of databases and the consoles... one of that seems like it belongs in a "how to get set
up" section, which is what this started out as. I know you think this info is important, but does your reader need to
know this stuff right now? Can you get them set up with Rails, SQlite, and then get us on our way? The background info
on RSpec is good, but seems out of place with the installation instructions, especially since we probably shouldn't be
installing the gems this way now that we have Bundler. Another thing i didn't really see is enough of a justification
for using rspec. I could just as easily meet the same requirements with test:unit which is the default. Personally, I
  favor Rspec, but my reasons are completely arbitrary -- I like it cos I like it.  Why are you using it? Does it belong
  in the installation section, or should it go in another section in the preface, where you talk about Ruby and Rails? I
  feel like it belongs there, with the IDE stuff too.</ed><author>Sarah:moved from intro to preface, some stuff in
  appendix, installation stuff
  will go online. This is much more concise and I think it works better.</author></p>

</sect2>


</sect1>
<sect1>
<title>What is in This Book?</title>
<p>Throughout this book, you will learn both the Ruby language and the Rails framework. We first will explore a concept
with exploratory testing through <commandname>irb</commandname> and sometimes with the command line and the browser. 
Then in the following chapter, we will continue our development test first using Ruby automated test frameworks.</p>
<p>In each chapter, we will build one small part of a larger application. The application is for an imaginary
creative writing class and serves as a resource for the students in the class. The domain of the application that we
first implement when learning Rails isn’t important, since most Rails applications, like most web applications, are very
similar to each other. We have some
data that we want to store in a database and later see it again. Sometimes we want to change it or delete it. We want to
provide the user interface in HTML so anyone with a web browser connected to the Internet can access it. Whether it is
the text of a writing assignment, the name and part number of a piece of equipment or items in a product catalog, these
are all just data that we can keep in a database and display in HTML.</p>
<p>In <ref linkend="ch.intro"/>, we’ll  talk about
how testing is first and foremost about good design, how it helps the software development workflow and collaboration,
how we can write more maintainable code and how the creation of tests is a nice artifact of the process, not the
main point. We’ll also introduce how we test first with the Red-Green-Refactor pattern of test first development. We’ll
also talk more about the app we will build in the book and we’ll work through all of the tools and components we need to develop a Rails application.</p>
<p>In <ref linkend="ch.ruby-intro"/>, we’ll learn just enough of the Ruby language to get started with Rails. We’ll
start using <commandname>irb</commandname> and write our first class and a method that we’ll use later in our Rails
application. Then in <ref linkend="ch.rspec-intro"/>, we’ll learn how to use RSpec, the automated test framework that
we’ll use throughout the book. We’ll test drive the development of some Ruby as well as understanding how to test the
code that we already wrote.</p>
<p>In  <ref linkend="ch.firstapp"/>, we’ll start our Rails application with command line generators that we’ll
explore in the browser. We’ll gain some experience with our first Rails pattern, most importantly the
Model-View-Controller (MVC) pattern, which we will learn in more detail throughout the first half of the book. We’ll get
a feel for how views work with ERB (Embedded RuBy) templates.</p>
<p>We’ll learn about ActiveRecord, the <emph>model</emph>, in the MVC pattern, interactively in <ref
linkend="ch.activerecord"/> and with RSpec in <ref
linkend="ch.activerecord-rspec"/>.</p>
<p> In <ref
linkend="ch.rake"/> we’ll get deeper into Ruby code, which will give us a firm foundation for the rest of the book.
We’ll also learn about the command line tool <commandname>rake</commandname>, which is like the Unix tool
<commandname>make</commandname>, but for Ruby. With Rake, we’ll write a Ruby script that uses our ActiveRecord class
that we created in the previous chapters.<ed>in the beforeyoustart chapter you have nearly identical content about Rake.
Do you want to consolidate?</ed><author>Sarah: I think that has been deleted now.</author></p>
<p>In <ref linkend="ch.migrations"/>, we’ll understand how our database schema is created and modified. We’ll learn the
mechanisms of how Rails can be database independent.</p>
<p>In <ref linkend="ch.controllers"/>, we’ll build a dynamic web page one step at a time, experimenting with how the browser
responds with the default Rails behavior and with our code. We’ll get to know how Rails handles HTTP requests. Then
we’ll continue the development of our controller by test-driving the rest of its behavior in <ref
linkend="ch.controllers-rspec"/>.</p>
<p>In <ref linkend="ch.integration"/>, we’ll solidify our understand of the MVC pattern and how it is implemented in
Rails core classes by test driving new behavior with the Capybara integration test framework. <ed>that "rodent" thing
doesn't work for me. it's a bit of a stretch.</ed><author>Sarah: removed</author></p>
<p>In <ref linkend="ch.stubs"/>, we’ll learn more about testing Ruby code, coping with uncertainty when the results of our code are
      non-deterministic and keeping our tests running fast.
</p>
<p>As we add more behavior to our application, in <ref linkend="ch.helpers"/>, we’ll learn some
techniques to keeping our code manageable and easy to read.</p>
<p>In <ref linkend="ch.associations"/>, we’ll take a closer look at ActiveRecord and learn how to leverage the power of
our relational database. Through <commandname>rails console</commandname>, we’ll gain experience with common association
methods in a “has many” relationship. Then, in <ref linkend="ch.associations-rspec"/> we’ll learn more about the details
by understanding how to define associations with RSpec.</p>
<p>In <ref linkend="ch.has-many-through"/>, we’ll learn how to create a many-to-many relationship using another kind of association.</p>
<p>In <ref linkend="ch.auth"/>, we’ll gain experience using a gem to extend Rails. We’ll also learn about how to lock
down controller actions, securing the entry points to our app with “before” filters. </p>
<p>At the end of the book, inn <ref linkend="ch.dunno"/>, we’ll highlight the parts of Rails that you’ll want to learn
next.</p> 
<p><author>Sarah: if you like the way this is going, I’ll fill in the rest.</author><ed>yup keep going.</ed>
 <ed>you've said this a couple of times. </ed> Through testing and experimentation, we’ll have
developed a thorough understanding of Rails. You will know
enough to build an intranet application or kick-off the development of a small-scale web app, and you will have enough
of a foundation to support further learning on your own to create highly-scalable consumer-facing web applications. </p>
</sect1>
<sect1 id="sec.online-resources" >
<title>Online Resources</title>
<p>
This book has its own web page, <url>http://pragprog.com/titles/satfr</url>, where you can find more information about the book.
You can:</p>
<ul>
<li><p>Get links to all of the software dependencies, so you can install what you need to work through the examples.</p></li>
<li><p>Download the full source code for the application that we’ll build in the book, including code for the
intermediate stages and Ruby scripts.</p></li>
<li><p>Participate in a discussion forum with Sarah, Liah, and other readers like you.</p></li>
<li><p>Help improve the book by reporting typos and code that didn’t work the way you expected. We also welcome
suggestions for improvement.</p></li>
</ul>
<p>You are free to use the source code in your own applications in any way that you want. If you’re reading the ebook, you can also click the little gray rectangle before the code listings to download that source file directly.</p>
<p>Throughout the book, we’ll also point you to online resources where you can learn more about Ruby and Rails.</p>
</sect1>

<sect1>
<title>How to Read This Book</title>
<p>Except for  <ref linkend="ch.intro"/><ed>ref it, don't say "the first chapter"</ed><author>Sarah:ok</author>, this book is not meant to be read on the bus or leaning back on the sofa. You should have hands on the keyboard and try out each experiment. For most of the code, you’ll be able to see the expected result, but now and then we’ll
challenge you to take what you’ve learned and write some of the application on your own.</p>
<p>Let’s start by learning a bit more about why and how we write code test first.  </p>
<p><ed>I think you did a good job on this chapter, but I think you both need to read this and the beforeyoustart chapter together and consolidate some of the information. I think some things are in the wrong place and other things are definitely repeated. There are a couple of sections in the beforeyoustart that could go here, and a little bit of content  here that could go over there. The first paragraph isn't really a good first paragraph but it's a great second paragraph. "come on in" is such a great welcoming title, but the paragraph that follows is a little weak.</ed></p>


</sect1>
</chapter>
