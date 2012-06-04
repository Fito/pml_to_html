<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.firstapp">
  <title>Diving Into Rails</title>
   
<p>Rails engineers are some of the speediest coders around, in part, because of the effective Rails code generators.
Rails generates just enough code to get us started, but not so much to bog us down. In this chapter, we’ll generate a
Rails app using the command-line generators. We’ll also edit a small amount of code and interact with the application in the
browser. This isn’t test first at all, but before we do any testing we need an
understanding of the tech we’re working with and the patterns we will use in creating web applications.</p>
<p>A two-word command is all we need to
create more than 70 files and directories that make up our first Rails app. These two words are: <ic>rails new</ic>.
Let's use this powerfull command to make a simple application that allows a to keep track of students and their work for
a class.</p>
<p>Along with <ic>rails new</ic> we need to specify an application name, in this case we'll call it <ic>class_app</ic>.
The application name is for our reference as developers and for the most part won't affect the code we generate, but we
don’t want to use a Ruby keyword like <ic>class</ic>. We’re also using RSpec in this book, so we’ll use the <ic>-T</ic>
option to turn off the default Test::Unit code generation:</p>

<code language="session">
$ rails new class_app -T
</code> 
<sidebar>
<title>Creating a Rails App with JRuby</title>
<p>With most versions of Ruby, like REE, MRI and YARV, you don’t need anything extra for Rails. However, JRuby has additional dependencies. To create a Rails app with appropriate dependendencies, the JRuby team has published a handy template:</p>
<code language="session">
$ rails new class_app –m http://jRuby.org
</code>
</sidebar>
<p>Doesn't get much easier than that!  Typing this command into the command line tells Rails to make a directory full of
new files and directories that combine to make a complete framework for our code.  A framework that we call
&lquot;opinionated&rquot; because of its built in patterns.</p>

<p>If you see errors at this step, check <ref linkend="sec.online-resources"/> for online references to installation instructions. Assuming Ruby, Rubygems and the Rails gem are installed properly, you’ll have a
<dir>class_app</dir> directory with dozens of files in it and output on the command line that looks like this: </p>
<code language="session">
      create  
      create  README
      create  Rakefile
      create  config.ru
      create  .gitignore
      create  Gemfile
      create  app
      create  app/controllers/application_controller.rb
      create  app/helpers/application_helper.rb
      create  app/mailers
      create  app/models
      create  app/views/layouts/application.html.erb
      create  config
      create  config/routes.rb
      create  config/application.rb
        :
        :
      create  tmp/sockets
      create  tmp/cache
      create  tmp/pids
      create  vendor/plugins
      create  vendor/plugins/.gitkeep
</code>


<p>We have just created a simple, yet complete web application. Rails prefers <emph>convention over
configuration</emph> meaning that having a conventional way of
doing things is preferred to spending time configuring each new project. Rails generates its configuration files 
 with <commandname>rails new</commandname>. Each configuration option has a well-thought out default value, so we can
 get started without spending time on configuration.</p>

<sect1>
<title>Running Our Web App</title>
<p>The whole Rails app is in our newly created <dir>class_app</dir> directory.  This is convenient for a few reasons:</p>
<ul>
<li><p>There are no hidden configuration files in system directories.</p></li>
<li><p>We can delete the directory and its contents if we want to throw it away and start over.
  <footnote><p>We’re using SQLite so even the database is in this directory, but usually the database is the only part
  of our application that lives somewhere else.</p></footnote>
    </p></li>
<li><p>We can simply copy this directory to our server to deploy the app.</p></li>
</ul>
<p>We will add and modify many files in our <dir>class_app</dir> directory during development. All of the commands that we will run on the command line will be at the root of the the application directory, so let’s be sure to change the working directory:</p>
<code language="session">
$ cd class_app
</code>
<p>We have a complete boilerplate web application that has everything it needs to run.  Let’s start up our server:</p>
<code language="session">
$ rails server
=> Booting WEBrick
=> Rails 3.0.1 application starting in development on http://0.0.0.0:3000
=> Call with -d to detach
=> Ctrl-C to shutdown server
[2010-11-28 09:52:39] INFO  WEBrick 1.3.1
[2010-11-28 09:52:39] INFO  Ruby 1.8.7 (2010-08-16) [i686-darwin10.4.0]
[2010-11-28 09:52:39] INFO  WEBrick::HTTPServer#start: pid=27080 port=3000
</code>

<p> We'll need to point our browser at <url>http://localhost:3000</url> to see our running webapp. We can admire our first Rails app in action!  The default home page of the generated Rails web
app, as shown in <ref linkend="fig.welcome-aboard" />, contains information about the app’s configuration and links to documentation.</p>
<figure id="fig.welcome-aboard">
  <title>Default Home Page</title>
  <imagedata fileref="images/welcome-aboard.png" />
</figure>
<p>Our app is all set up with required boilerplate and default configuration.  Let’s make it our own by modifying the home page of the app.</p>
</sect1>

<sect1>
<title>Modifying the Home Page</title>
<p>If this were a static HTML web site, we
would find the home page in the root directory, probably in a file called <filename>index.html</filename>.  There is no
such file in our root directory. Rails will look first for static files in the <dir>public</dir> directory.  Here we
keep static HTML pages and other files such as images, CSS and Javascript.</p>
<p>Rails will look for a static page before it looks for a dynamic page, so if both are available, the static page will win and be served up to the browser.  If we take a look in our <dir>public</dir> directory we will find a file called <filename>index.html</filename>.  This file contains the HTML that formed our home page.  We have found the code we need to modify to make our static homepage more snazzy.</p>
<p>In Rails we can modify most files without stopping and starting the server.  To stop the server, just type control-C,
but it is much easier to just keep the server running.  Let’s open another terminal window and go to the
<dir>class_app</dir> directory, so we can run the server (and see the output) and keep using the command-line in our
first window. Next we’ll open the <filename>/public/index.html</filename> file in an
editor to modify the web page title or some text.</p><p>For example, let’s change:</p>
<code file="code/class_app_new/00a_rails_new/public/index.html" part="title"/>
<p>to:</p>
<figure id="fig.home-page-change">
  <title>Home Page with Modified Title</title>
  <imagedata fileref="images/home-page-change.png" />
</figure>
<code file="code/class_app_new/00b_change_home_page/public/index.html" part="title"/>
<p>Now we can just refresh the page at <url>http://localhost:3000</url> to see that its title now reads “My Cool Web App.” <ref linkend="fig.home-page-change"/> shows a screen shot of the app in the Chrome browser, so the web page title appears as the name of the tab, but it might appear in your browser in the window title bar.
</p>
<p>Now that we know the basics of running our Rails app and understand how the <dir>public</dir> directory
stores static content,  let's set up our web app for development, configuring the test framework we want to use since it
is different from the default and also look at some of the configuration that Rails has already done for us.</p>
</sect1>
<sect1>
 <title>Setting up RSpec for Rails</title>
 <p>We’ve decided to use the RSpec test framework, instead of the default Test:Unit, so we’ll take a moment and
 configure that.</p> 
   <sidebar>
  <title>Rails Environments</title>
   <p>The group names in our Gemfile
  match the names of our Rails environments. Rails starts with configuration for three environments: development, test,
  and production.</p><p>By default, when we run the server on the command line, Rails will use the development environment.
  When RSpec runs, it will set the environment to test. When we deploy our server for real people to use it, we make
  sure we are running the production environment.</p><p>The <emph>environment</emph> is simply a set of configuration
  options. The general application config is kept in <dir>config/application.rb</dir>, which we can override in the
  specific environment config files:</p>
<code language="session">
$ ls config/environments/
development.rb	production.rb	test.rb
</code>
<p>Also, we have a different log files for each environment, in addition to the web server log file:</p>

<code language="session">
$ ls log
development.log		production.log		server.log		test.log
</code>
<p>The rspec-rails gem provides a rake task,
  <commandname>rake spec</commandname>, which will take care of setting
  the environment to “test” when we run our specs.</p>
  </sidebar>
  <p>
  We need to install the rspec-rails gem, which includes additional configuration and support for working with a Rails
  app.  We specify this dependency in the Gemfile, which we find in the root directory of our Rails app:</p>
<code file="code/class_app_new/00c_add_rspec/Gemfile" part="test"/>  
  <p>By adding rspec-rails to the <ic>:test</ic> and <ic>:development</ic> groups in the Gemfile, we
  tell Rails that we are just using this gem for testing and development. We don’t want our test frameworks to be a dependency in
  production.</p>
 <p> We don’t need to specify that we need the RSpec gem in the Gemfile. Since
  rspec-rails has an
  internal dependency list, it will automatically install RSpec.</p> 
<p>After we’ve edited the Gemfile, we need to call <commandname>bundle</commandname> to tell Rails that we have
modified the dependencies.</p>
<code language="session">
$ bundle
</code>
<p>The <commandname>bundle</commandname> command can take some time because it will go out to the Internet to find gems
that we haven’t installed locally. It will tell us what gems it installs and which ones it just uses from what we
already have installed with Ruby Gems.</p>
<p>
  Now that we have configured Rails to be able to use the RSpec gem, we can use RSpec’s own generator on the command
  line, to create the default configuration and other files required for running RSpec with Rails:</p>
<code language="session">
$ rails generate rspec:install 
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
</code>
<p>The <filename>.rspec</filename> file contains the options for the <commandname>rspec</commandname> command when it is
called with the <commandname>rake</commandname> task. To see all of the options for
<commandname>rspec</commandname>, we can type <ic>rspec --help</ic> on the command-line.</p>
<p>We’ll be keeping all of our specs for our Rails application in the <dir>spec</dir> directory. Inside
<dir>spec</dir>, we now also have <filename>spec_helper.rb</filename>, which contains some additional
configuration needed for using RSpec with Rails. We’ll require <filename>spec_helper.rb</filename> in each spec that we
write for our app.</p>
<p>The name <emph>Rails</emph> is a metaphor for its philosophy. Like
 a train on a track, our development can be very fast with Rails; however, it is not a precise metaphor. Unlike with a
 train, when we follow a slightly different path, we are not immoblized. We can veer a little off the common path and
 still maintain velocity for much of our development. The power of Ruby allows Rails to be flexible. We can adapt it
 to our needs, going incredibly fast when our web app is
 very much like most other web applications in the world and needing to take more time, slowing our development only
 when developing something very unique to our application.</p>

</sect1>




<sect1 id="database-yaml">
<title>Connecting to a Database</title>

<p>Rails excels at creating database-driven web applications. By default, Rails is configured to use a relational database, catering to the most common type of web application. The vast majority of applications on the web today are merely a thin layer of HTML and code on top of a relational database. </p>
<p>We’ll use SQLite as the database in learning Rails because it requires no additional configuration and is easy for learning and
experimenting. You can see that the default Rails configuration uses SQLite in <filename>config/database.yml</filename>:</p>
<code file="code/class_app_new/00c_add_rspec/config/database.yml"/>
<p>In the <filename>database.yml</filename> file there are three sets of configurations: development, test, and production. Typically we want at least these three isolated environments, each with their own database. The <emph>development</emph> environment is the default environment in Rails, which acts as a
sandbox for us to work with new code. </p>


<sect2>
<title>The Rails MVC Pattern and REST</title>
<p>Rails includes a default implementation of the Model-View-Controller pattern with Representational State Transfer (REST).<footnote><p>In 2000, Roy Fielding described REST as an architectural pattern well-suited to web applications.
<url>http://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm</url></p></footnote>  When we use the REST pattern in our websites we are piggybacking on the Web's architecture.  This makes for intuitive design that benefits us and our users.</p>
<sect3>
<title>REST Principals</title>
<p>The REST architecture simplifies our web application by treating data on the server as an abstract
<emph>resource</emph> with a consistent representation to the client. This allows for a separation of concerns between the user interface and data storage and for stateless communication between client and server.  The key REST principals are:</p>
<ul>
<li><p>Separation of concerns between UI and data storage</p></li>
<li><p>Uniform interface between components</p></li>
<li><p>Stateless communication</p></li>
</ul>
<p>We’ll see this pattern in action with our <class>Person</class> class, which is acts as a <emph>resource</emph> in
Rails.
Rails implements REST by creating a standard set of web pages for the user interface to represent a collection of data.
We’ll start by using scaffold which creates a default representation in both HTML and XML, as well as standard URLs and HTTP actions.  </p>
</sect3>
<p>So, what are the models, views and controllers, exactly?. <ed>this sentence actually seems unnecessary now because
it's nearly a repeat of what you said  at the beginning of the previous sect2. </ed><author>Sarah: agreed but the list
below needs some kind of intro, edited.</author></p>
<ul>
 <li><p><emph>Model</emph> represents what is in the database</p></li>
 <li><p><emph>View</emph> is typically HTML, rendered from a template which mixes static content and dynamic data</p></li>
 <li><p><emph>Controller</emph> receives HTTP actions (GET, POST, PUT, DELETE) and then decides what to do, typically rendering a view</p>
 </li>
</ul>
<p> In <ref linkend="fig.rails-mvc"/> you can see the HTTP request-response cycle showing the
flow-of-control through the controller, to the model, then to the view. 
The visitor types a URL into the browser which generates an HTTP request to the Rails web app. That request is handled by a class
called a <emph>controller</emph>. The controller will typically use a <emph>model</emph> to get data from the database which it then renders
using a <emph>view</emph>. Rendering the view creates HTML which is sent to the browser and displayed. Then the visitor
may click a link, which generates a request, and the cycle begins again. </p>
<figure id="fig.rails-mvc">
  <title>The MVC Request-Response Cycle</title>
  <imagedata fileref="images/rails-mvc.pdf" />
</figure>
<p>The easiest way to understand this is by example.  Before we create a web application of our own design, let’s use
the Rails scaffold generator to get a feel for the Rails patterns that are easy to build in our own applications. The
<commandname>rails generate scaffold</commandname> command creates a set of web pages and Ruby code for accessing the database and responding to HTTP requests. Rails makes it easy to develop web pages and application code for standard database operations: create, read, update, and delete. </p>
<p>Our application needs to have a list of people in a class.
We’ll specify that we want to create a <ic>person</ic> object that has <ic>given_name</ic> and <ic>surname</ic> attributes which are both strings. </p>
<code language="session">
$ rails generate scaffold person given_name:string surname:string
      invoke  active_record
      create    db/migrate/20110508181731_create_people.rb
      create    app/models/person.rb
      invoke    rspec
      create      spec/models/person_spec.rb
       route  resources :people
      invoke  scaffold_controller
      create    app/controllers/people_controller.rb
      invoke    erb
      create      app/views/people
      create      app/views/people/index.html.erb
      create      app/views/people/edit.html.erb
      create      app/views/people/show.html.erb
      create      app/views/people/new.html.erb
      create      app/views/people/_form.html.erb
      invoke    rspec
      create      spec/controllers/people_controller_spec.rb
      create      spec/views/people/edit.html.erb_spec.rb
      create      spec/views/people/index.html.erb_spec.rb
      create      spec/views/people/new.html.erb_spec.rb
      create      spec/views/people/show.html.erb_spec.rb
      invoke      helper
      create        spec/helpers/people_helper_spec.rb
      create      spec/routing/people_routing_spec.rb
      invoke      rspec
      create        spec/requests/people_spec.rb
      invoke    helper
      create      app/helpers/people_helper.rb
      invoke      rspec
      invoke  stylesheets
      create    public/stylesheets/scaffold.css
</code>
<p>Since we’re using SQLite we don’t need to do anything special to create the database that our app will use. For any
other kind of database, we would need to call <ic>rake db:create:all</ic> which does nothing when we are using SQLite.</p>
<p>With three environments, specified in <filename>database.yml</filename>, our application will have three databases.
When we experiment with our code interactively, we use the <emph>development</emph> environment and the development database.  With Rails we create database tables and make schema changes using a <emph>migration</emph>, which we'll learn more about in <ref linkend="ch.migrations"/>. Our person object will store its data in a table in the database. To create the table we call:</p>
<code language="session">
$ rake db:migrate
(in .../class_app)
==  CreatePeople: migrating ===================================================
-- create_table(:people)
   -> 0.0012s
==  CreatePeople: migrated (0.0013s) ==========================================
</code>
<p>We can see by the output that we just created a <emph>people</emph> table in the database.  </p>
</sect2>
<sect2>
<title>What’s up with these plural nouns?</title>
<figure id="fig.pluralization">
  <title>MVC Pattern with Pluralized Names</title>
  <imagedata fileref="images/pluralization.pdf" />
</figure>
<p>How did we get a list of <emph>people</emph> when we specified that
we wanted a <emph>person</emph> object? Rails prides itself in letting
programmers be human and speak in English. If we have a person object, a collection of those objects should be
grammatically correct. We should be able to call them people, both in terms of the user interface and internally in the
code. Rails follows a set of naming conventions where a single entity, such as a &lquot;customer&rquot; is referred to in the singular, whereas collections, like a bunch of &lquot;customers&rquot;  are
referred to as plural. To put it another way, the model object which refers to a single row in the database table is singular, but the
table itself which stores the data for a whole collection of models is plural. The default names in Rails take advantage of helper methods to pluralize the model name to create the
database table name and other names too.  We’ll get into the details of database tables, model and controller classes
and how they work in a bit, but first let’s look at how they are named.</p>

<joeasks>
<title>How does Rails know about irregular nouns?</title>
<p>Pluralization rules are controlled by the ActiveSupport::Inflector class in Rails. The <commandname>rails new</commandname> command generates a placeholder configuration file with comments that indicate exactly how to configure this.</p>
<p>Using <ic>rails console</ic> we can see that the irregular noun "foot" is not correctly pluralized in Rails.</p>
<code language="session">
> "foot".pluralize
 => "foots" 
</code>
<p>To fix this, let’s edit the file <filename>config/initializers/inflections.rb</filename> changing the commented out person/people line to
foot/feet:</p>
<code file="code/class_app_new/00c_add_rspec/config/initializers/inflections.rb" />
<p>Now when we go back to the console (after exiting and  starting again, <commandname>reload!</commandname> is not sufficient in this
case) we’ll  see the correct pluralization:</p>
<code language="session">
> "foot".pluralize
 => "feet" 
</code>
<p>Looking at <filename>inflections.rb</filename>, we can see that Rails supports flexible rules for pluralization,
which are well documented in the API
reference<footnote><p><url>http://api.rubyonrails.org/classes/ActiveSupport/Inflector/Inflections.html</url></p></footnote>.

There’s also a nice interactive demonstration of Rails pluralization online<footnote><p>
<url>http://nubyonrails.com/tools/pluralize</url></p></footnote>.</p>

<p>Internally, Rails uses Ruby to extend the <class>String</class> class to include a
<method>pluralize</method> method.</p>

</joeasks>
<sect3>
<title>Models are Singular</title>

<p>The model represents a single object (which maps to a single row in the corresponding database table). You’ll find
the code for the <class>Person</class> class in <filename>app/models/person.rb</filename></p>
<code file="code/class_app_new/00d_person_scaffold/app/models/person.rb"/>
<p>This code is explained in <ref linkend="ch.activerecord"/></p>
</sect3>
<sect3>
<title>Views Directory is Plural</title>
<p>There are many views for a specific model, so the views sub-directory is plural. For the whole application there is a
<dir>views</dir> directory. The views associated with this model and controller are kept in the
<dir>people</dir> directory.</p>
</sect3>
<sect3>
<title>Database tables are Plural</title>
<p>A database table stores the data for a collection of model objects so the table is named with a plural
noun.  We keep data in a <ic>people</ic> table.</p>
<code language="session">
rails dbconsole
>> select * from people;
</code>
<p>We'll learn more about interacting with the database console in <ref linkend="ch.activerecord"/>.</p>
</sect3>
<sect3>
<title>Controllers are Plural</title>
<p>The controller works with a collection of models so its name is plural.  In
<filename>app/controllers/people_controller.rb</filename>, we can see that <class>PeopleController</class> is a
subclass of <class>ApplicationController</class>. We have just one <emph>application</emph> that provides access
to a list of <emph>people</emph>.</p>
<code file="code/class_app_new/00d_person_scaffold/app/controllers/people_controller.rb"  part="class"/>
<p>This code is explained in <ref linkend="ch.controllers"/></p>
</sect3>
</sect2>
<sect2>
<title>What are all these files generated by scaffold?</title>
<p>Let’s take a quick look at the files that were generated by the <commandname>rails generate
scaffold</commandname> command. We will focus on the core files that implement the MVC pattern.</p>
<p>The <emph>model</emph>, which we’ll look at in depth in the <ref linkend="ch.activerecord"/> has two associated files. The
<class>Person</class> class that implements the model in <filename>person.rb</filename> and the migration that creates the database table that we executed with the “rake db:migrate” command.</p>
<ul>
 <li><p>app/models/person.rb</p></li>
 <li><p>db/migrate/20090611073227_create_people.rb</p></li>
</ul>
<p>The <emph>controller</emph>, which we’ll learn all about in <ref linkend="ch.controllers"/> is implemented in the PeopleController class in people_controller.rb. It also has a line added to the routes configuration in config/routes.rb which affects how the URL requested from the browser triggers controller actions. </p>
<ul>
 <li><p>app/controllers/people_controller.rb</p></li>
 <li><p>route map.resources :people</p></li>
</ul>
<p>The <emph>views</emph> generated by scaffold are the four pages required for create, update, delete and viewing all
of the data in a table and a the details of a single record. plus a fifth file (_form.html.erb) which
contains snippet of code which is shared by two of the other views. We’ll learn a little about views in <ref
linkend="sec.intro-views"/> and more
in <ref linkend="ch.integration"/>.</p>
<ul>
 <li><p>app/views/people/index.html.erb</p></li>
 <li><p>app/views/people/show.html.erb</p></li>
 <li><p>app/views/people/new.html.erb</p></li>
 <li><p>app/views/people/edit.html.erb</p></li>
 <li><p>app/views/people/_form.html.erb</p></li>
</ul>
</sect2>
<sect2>
<title>Exploring the HTML Generated with Scaffold</title>
<p>To see our scaffold in action, we don't need to stop the server, just browse to
<url>http://localhost:3000/people</url>.  Here we see a the listing of the <emph>people</emph> in the database --
a plural noun for the default URL because the page displays a collection.</p>

<p>We have an empty list right now, as shown in <ref linkend="fig.people-listing-empty" />, but we can see that with
just one command we have a complete web interface for adding, editing and deleting records from our database. We'll
explore it a bit to understand how different parts of Rails work together to create a compelling default implementation
of REST using the MVC pattern.</p>
<figure id="fig.people-listing-empty">
  <title>Index Page with No Data</title>
  <imagedata fileref="images/people-listing-empty.png"  />
</figure>
<sect3 id="sec.scaffold-rest-mvc">
<title>How Does Scaffold Implement REST and MVC?</title>
<p>The <commandname>generate scaffold</commandname> command adds just one line to <filename>config/routes.rb</filename>, which implements all of the REST
URLs: <ic>resources :people</ic>. We'll explore more details about routes in <ref linkend="ch.controllers"/>.  Using
the <method>resources</method> method for 
a route allows us to specify a whole group of URLs. In just one line, we can express all of the URLs needed for the common database
interactions.</p>

<p>Under the class_app application, we can inspect our routes on
the command-line using a useful rake task:</p>
<code language="session">
$ rake routes     
people GET	/people(.:format)     	{:action=>"index", :controller=>"people"}
people POST	/people(.:format)      	{:action=>"create", :controller=>"people"}
new_person GET	/people/new(.:format)	{:action=>"new", :controller=>"people"}
edit_person GET	/people/:id/edit(.:format) {:action=>"edit", :controller=>"people"}
person GET	/people/:id(.:format)  	{:action=>"show", :controller=>"people"}
person PUT	/people/:id(.:format)  	{:action=>"update", :controller=>"people"}
person DELETE	/people/:id(.:format)  	{:action=>"destroy", :controller=>"people"}
</code>
<p>Looking at the first line, we can see that the <ic>/people</ic> URL maps to the <ic>index</ic> action when we type
the URL into the browser or follow a link, which results in an HTTP GET request. However, when the same URL is sent an HTTP POST request, the <method>create</method> action is triggered.</p>
<p> Let’s go back to our browser to see how this works.  When we click the <emph>New Person</emph> link, we move to a page with a form where we can input data for a new Person record.  The <emph>new</emph> page, as shown in <ref
linkend="fig.new-person" />, corresponds to the URL <ic>/people/new</ic>.  </p>
<figure id="fig.new-person">
  <title>The  “New” Page</title>
  <imagedata fileref="images/new-person.png"  />
</figure>

<p>When we fill in the fields with a name, like “Fred” for the first name and “Flintstone” for the last name and click
“Create Person” the browser will send an HTTP POST to the <ic>/people</ic> URL.  The <method>create</method>
action inserts a new record in the database and redirects to the <emph>show</emph> page, which is <ic>/people/1</ic> for
our first record.</p>

<p>We can then click the “Back” link and to see the the list of people which includes our new record, as shown in <ref
linkend="fig.people-listing-fred" />.</p>
<figure id="fig.people-listing-fred">
  <title>Index Page with One Record</title>
  <imagedata fileref="images/people-listing-fred.png" />
</figure>

<p>From the people index page we now have the option to show the detail page, edit the record or destroy the record. Go ahead and create a few people for your list. Experiment with editing and deleting a record.</p>
</sect3>
</sect2>

</sect1>

<sect1 id="sec.intro-views">
<title>Editing Views</title>
<p>View files, also known as <emph>templates</emph>, ending in .erb are <emph>Embedded Ruby</emph> files.  Similar to JSP, ASP and PHP, these are dynamic web pages that mix HTML and Ruby code.</p>
<p><ic>&lt;%  ... %></ic>	executes Ruby code	(e.g., setting up conditionals) </p>
<p><ic>&lt;%= ... %></ic>	evaluates Ruby code, inserting the result in HTML	
(e.g., displaying value returned from a method) 
</p>
<p>Let’s look at part of the code in <filename>app/views/people/index.html.erb</filename>:</p>
<code file="code/class_app_new/00d_person_scaffold/app/views/people/index.html.erb" part="example"/>

<p>On line <cref linkend="code.people-index.each"/>, in between &lt;% and %&gt; is Ruby code, where <ic>@people</ic> is an instance variable containing an array of
person objects which have a given_name and surname attribute. Calling <method>each</method> on the array
iterates over the list, each time assigning the next object to the variable <ic>person</ic> which is available to the
following block of code. Notice that the loop ends on line <cref linkend="code.people-index.end"/> – you can continue a multiline
Ruby expression with HTML interspersed. For every iteration, the inner lines HTML will be output as part of the response, so we will see a table row for each person in the collection.</p>
<p>Inside the loop, the Ruby code is evaluated as part of the output stream. <ic>&lt;%= person.first_name
%&gt;</ic> will evaluate <ic>(person.first_name).to_s</ic> and insert the result into the given HTML. If we had Fred Flintstone and Barney Rubble in our list, we would see the following HTML response:</p>

<code language="html"> 
<tr>
    <td>Fred</td>
    <td>Flintstone</td>
</tr>
<tr>
    <td>Barney</td>
    <td>Rubble</td>
</tr>
</code>

<p>The key points to remember are that <ic>&lt;%</ic> just lets us execute Ruby code and that <ic>&lt;%=</ic> will call
<ic>to_s</ic> on the result and insert it into the HTML that is generated.</p>
<sect2>
<title>Exercise</title>
<p>On the main people page </p>
<ol>
<li><p>Change &lquot;Listing people&rquot; to &lquot;My Class List&rquot;</p></li>
<li><p>List people with first initial and last name in one visual column (e.g. F. Flintstone) </p></li>
</ol>
<p>When editing views, you will see some helper methods that we haven’t explained yet. Don’t worry about them for now,
you’ll need to understand models, controllers and routes first. However, you may find them fairly easy to read and
understand anyhow. The intent with Rails views is that any Ruby code is small and human readable, so that someone
familiar with HTML and the high-level functionality of the applications would be able to change the visual appearance of
the page, moving around elements generated with Ruby without necessarily understanding the code underneath. Go ahead and
try the exercise yourself before we go through it together. It’s okay. We’ll wait.</p>
</sect2>
<sect2>
<title>Solution</title>
<p>To modify the main page, we need to edit <filename>app/views/people/index.html.erb</filename>. The first challenge is changing plain
HTML. We can see “Listing people” in an <ic>&lt;h1&gt;</ic> tag at the top and we can just change the text to “My Class
List”. For the second challenge, we need to
remove a visual column <ic>&lt;th&gt;Last Name&lt;/th&gt;</ic> and combine the two table cells (<ic>&lt;td&gt;</ic> tags) into one Ruby
expression that concatenates the first letter of the first name with the last name. Below we use string interpolation to
accomplish this the results can be seen in <ref linkend="fig.people-listing" />.</p>
<code file="code/class_app_new/00e_view_edits/app/views/people/index.html.erb" part="example"/>
</sect2>

<figure id="fig.people-listing">
  <title>Modified People Index Page</title>
  <imagedata fileref="images/people-listing.png"/>
</figure>
<p>We have created our first database-driven Rails application using the <commandname>rails new</commandname> and
<commandname>generate scaffold</commandname> commands.</p>
<sect2 id="sec.running-tests">
<title>Running Our Tests</title>
<p>Since we configured our application to use RSpec, when we
generated our scaffold, Rails generated tests for our model, views and controller. Since we just modified the code
without test-driving it, let’s take a look at what happens when we run the tests:</p>
<code language="session">
$ rake spec
(in /Users/sarah/…/class_app_new_source)
...............**.........F..

Pending:
  PeopleHelper add some examples to (or delete) …/people_helper_spec.rb
    # Not Yet Implemented
    # ./spec/helpers/people_helper_spec.rb:14
  Person add some examples to (or delete) …/spec/models/person_spec.rb
    # Not Yet Implemented
    # ./spec/models/person_spec.rb:4

Failures:

  1) people/index.html.erb renders a list of people
     Failure/Error: assert_select "tr>td", :text => "Given Name".to_s,…
     MiniTest::Assertion:
       <"Given Name"> expected but was
       <"G Surname">.
     # (eval):2:in `assert'
     # ./spec/views/people/index.html.erb_spec.rb:20:in `block (2 lev…

Finished in 0.39219 seconds
29 examples, 1 failure, 2 pending
rake aborted!
</code>
<p>RSpec will first print out one character per test. The dots are for tests that pass, <ic>*</ic> for
<firstuse>pending</firstuse> specs that are placeholders for tests we plan to write later, and <ic>F</ic> for a failing
test. The RSpec framework creates some tests for us and for other parts of our code, it
leaves them for us to fill in. We can see that our change in the view introduced a test failure. We don’t want to leave our code with failing and pending tests, so let’s just delete
those files now. Later we’ll learn how to add our own test code, but for now we want to just leave this chapter with all
of our tests passing.</p>
<code language="session">
$ rm spec/views/people/index.html.erb_spec.rb
$ rm spec/models/person_spec.rb
$ rm spec/helpers/people_helper_spec.rb
$ rake spec
(in …/code/class_app_new_source)
…/bin/ruby -S bundle exec rspec ./spec/controllers/people_controller_spec.rb
./spec/requests/people_spec.rb ./spec/routing/people_routing_spec.rb ./spec/
views/people/edit.html.erb_spec.rb ./spec/views/people/new.html.erb_spec.rb 
./spec/views/people/show.html.erb_spec.rb
..........................

Finished in 0.34845 seconds
26 examples, 0 failures
</code>
<p>Scaffold is rarely used in the development of production Rails applications, largely because the generated code may
or may not fit exactly what we need, and can lead to maintenance headaches if we’re not careful to delete unused code
and modify or delete broken tests as we develop our application. However, scaffold is an effective learning and
prototyping tool.</p>
</sect2>
<p>Through our experiments with scaffold, we have a feel for how the
Model-View-Controller pattern works in Rails and the default implementation of REST. We understand how to edit view
templates and the static files that we keep in the <dir>public</dir> directory.  Next we'll dive deeper into
models, controllers and views using interactive testing with the Rails console and test first learning with RSpec. </p>

</sect1> 
</chapter>
