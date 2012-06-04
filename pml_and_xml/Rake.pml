<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.rake">
  <title>Rake Helps us Organize Our Ruby Scripts</title>
  <p>Remember how we created our database back in the ActiveRecord chapter?  It went something like this: <ic>rake db:create</ic> and then <ic>rake db:migrate</ic>. These commands are called rake tasks.  Rake is a build program written in Ruby.  It is also another example of a Domain Specific Language (DSL), meaning that it is a new language that sits on top of Ruby with the sole purpose of building files and running scripts. Rake tasks are great because they make our lives easier.  How would we have created our database without rake?  We could have used a sql console to create the database, add the tables and indexes.  Sounds much more time consuming and error prone than using our two rake commands, right?</p>
  
  <p>
    We've seen first hand how powerful rake can be.  Would you believe that when Jim Wierich came up with the idea for rake, he wasn't convinced it would be of use to Ruby programmers?  It's true.  Read all about it yourself and have a good giggle: http://rake.rubyforge.org/files/doc/rational_rdoc.html.  In this document Jim concedes that he's not sure that anyone would be interested in it.  Thankfully, Jim went ahead and built rake anyway.  Without rake (or something like it), we would need to worry about xml files or finicky Make syntax. Perhaps the most brilliant thing about rake is that we get to continue using Ruby.  With Rake we can use the basic DSL syntax for most tasks.  When tasks are more complex and the rake DSL doesn't have a solution, we can easily use Ruby from within Rake to accomplish our goal. 
  </p>
  <p>
    Let's get ready to learn all about rake.  We'll start off by understanding the basic syntax of common rake tasks.  Later we'll have a chance to talk about Ruby <firstuse>blocks</firstuse> and <firstuse>method missing</firstuse>.  First, let's start off learning about the rake tasks we've already used.
  </p>

<sect1>
  <title>ActiveRecord Built In Rake Tasks</title>
  <p>
    We can see all of the rake tasks that are built into our installed gems by running <ic>rake -T</ic> on the command line.  If we type <ic>rake -T db</ic>, we see a list of our tasks that include the characters <ic>db</ic>.  We see several familiar tasks that we've run before such as <ic>rake db:create</ic> and <ic>rake db:migrate</ic>.  Let's take a moment to dig into how rake tasks do what they do.
  </p>
  <p>
    Let's start off by understanding a task we've used before, <ic>rake db:create</ic>.  We can find this task inside of the activerecord gem.  We can see where the activerecord gem is installed with the following command: <ic>bundle show activerecord</ic>.  The output of this command should be a path to the gem directory.  Now here's a fancy trick: <ic>cd `bundle show activerecord`</ic>.  The code inside of the tic marks is executed so that we move into the directory where the activerecord gem is installed.  When doing Rails development we often need to get a better understanding of how a gem works.  Knowing how to navigate to each gem will make this easy.  Once we open up a gem, we can even put debugging information into the gem's code to inspect variables and make sure the right methods are getting called.
  </p>
  <sect2>
    <title>Namespaces in Rake Files</title>
      <p>
        To see how <ic>rake db:create</ic> works, let's open this file: lib/active_record/railties/databases.rake in a text editor. Check out that first line, <ic>namespace :db do</ic>.  The <method>namespace</method> method is defined in the rake gem and does exactly what it sounds like it would do. It allows us to create namespaces for our tasks, putting different tasks into different categories.  The <ic>rake db:create</ic> command is put into the namespace of <ic>db</ic>, short for database.  When we run the command we put a colon after the namespace and then type the name of the task, in this case our task is <ic>create</ic>.    
        
          

        explain rake db:create, rake db:migrate, rake db:seed
        rake -T
    </p>
  </sect2>
</sect1>

<sect1>
  <title>Test Driving A Custom Rake Task</title>
  <p>
    create a rake db:seed task (test first)
  getting rails environment to be loaded in the task
  task :add_students => :environment do; #code; end
  also, if you want to specify the environment to run the code in, you can do rake add_students RAILS_ENV=production
  eager loading
(http://stackoverflow.com/questions/4300240/rails-3-rake-task-cant-find-model-in-production) 
  could maybe go into method missing
too(http://stackoverflow.com/questions/4017069/correct-rails-3-replacement-for-envrails-env-production)
 </p>
</sect1>

<sect1>
  <title>Ruby Blocks</title>
  <p>
    explain blocks - show that you can use rake without a block too if your task just consolidates other tasks
 </p>
</sect1>

<sect1>
  <title>Rake Features</title>
  <p>namespaces</p>
  <p>accepting arguments </p>
  <p>desc method for documentation - shows up in rake -T</p>
  <p>default task </p>
</sect1>

<sect1>
  <title>Ruby Blocks</title>
  <p>
    explain blocks - show that you can use rake without a block too if your task just consolidates other tasks
 </p>
</sect1>

<sect1>
  <title>Test Driving Importing Students</title>
  <p>
  rake task that imports students from a csv file
  File, i/o
  open the csv file
  read/write/play with it
  Rake dependencies &amp; methods
  explain task method vs file method
  show how the file rake method works by having a directory that the csv file is in.  (show how dependencies work.)
  Arrays &amp; Hashes
  manipulate the csv data...maybe only insert some of the students into the db?  
 </p>
</sect1>

    
 </chapter>
