<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.controllers">
  <title>Exploring Routes and Controllers</title>

     <p>When we create a web application, we craft a unified experience from a series of web pages. 
  Sometimes a single interaction takes place across multiple HTTP requests. The Model-View-Controller pattern helps us wrangling these disjoint pages into manageable code.</p>
  <p>In <ref linkend="ch.firstapp"/>, we learned
  about views, how Embedded Ruby templates let us declare the visual part of our web user interface. Then we learned about the model, in  <ref linkend="ch.activerecord"/> and <ref
  linkend="ch.activerecord-rspec"/>.  Now we’ll learn about how routes and
  controllers string our views together, letting us specify the
  interactive part of our user interface.</p><p> As we did with ActiveRecord, we’ll start by exploring interactively,
  but now we can use the browser to see how our code responds. Let’s take another look at the pages
  that scaffold made for our <class>Person</class> model. Making sure we’re in our
  <dir>class_app</dir> directory, we
  type <commandname>rails s</commandname> to run the server. The index page shows a list of people:</p>
  <p><url>http://localhost:3000/people</url></p>
  <p>From there, we can click the “New Person” link to go to a web form to fill in data for a
  new person to add to our database:</p>
  <p><url>http://localhost:3000/people/new</url></p>
  <p>Then when we fill in the name fields and click “Create” to submit the form, which sends an HTTP POST to:
  <ic>http://localhost:3000/people</ic> and then redirects to:</p>  
  <p><url>http://localhost:3000/people/4</url></p>
  <p>The database record was created and then the browser was redirected to display a page that showed the details of
  the person. That’s four HTTP requests and three web pages, but it feels like a unified experience because we’re used
  to interacting with web applications in this way.</p>

    <p>In Rails, a <emph>route</emph> specifies how an incoming URL calls our code. Routes are like street signs that point to destinations.  When someone accesses a URL of a Rails web
    application, Rails uses the routes specified in <filename>config/routes.rb</filename>.  This file
    contains a mapping of each URL to our Ruby code which decides what to do. </p>
<p>When we created our app with <commandname>rails new</commandname> the <filename>routes.rb</filename> file was created with no
routes defined. The routes file looks almost like a configuration file — it is even kept in the config directory;
however, it is
executable Ruby code. At first glance the file seems lengthy because Rails includes some in-line documentation in the
form of comments that show different example routes, but there is really just a single method call with a
configuration block. When we ran the scaffold generator, it modified this file to add
just one <ic>resources</ic> declaration: </p>
<code file="code/class_app_new/00_controllers/config/routes.rb"/>
<p>From that one line, we defined 7 routes which we explored interactively in <ref
linkend="sec.scaffold-rest-mvc"/>.
The <ic>resources</ic> method provides a nice shortcut for defining all of the standard REST routes; however, to use Rails effectively we need to understand what’s really going on. We’ll build a similar set of routes and corresponding controller behavior for our
<class>Course</class> model one step at a time.</p>
<sect1>
<title>Responding to a URL Request</title> 
 
  <p>When we go to <url>http://localhost:3000/people</url>, the browser sends the HTTP
  request <ic>GET /people</ic> to the server running at <ic>localhost</ic> (listening on port 3000). If the server were a plain old web server, it
  would just respond with the contents of the default file in the
  <dir>people</dir> directory, usually
  <filename>index.html</filename>. Our Rails app dynamically
  determines what page to send back to the browser.</p>
<p>We’ll follow an HTTP request from typing an URL into the browser
through a route to learn about the code we need to write to make it work, starting with a page to display a single
<class>Course</class> model. Let’s start by browsing to the URL we haven’t
built yet and see what happens. Let’s point our browser to a new, arbitrary url:
<url>http://localhost:3000/my_course</url>. We see the routing
error shown in <ref linkend="fig.routing-error" />. Go ahead and try it. </p>
<figure id="fig.routing-error">
  <title>We Have Not Yet Specified Where the URL Goes</title>
  <imagedata fileref="images/controllers/routing-error.png"  />
</figure>
<p>This error tells us that the URL <ic>/my_course</ic> is not hooked up to anything. There is no <emph>route</emph> into the app
that matches that string.</p>
<sect2>
<title>Let’s Create a Route</title>
<p>A route maps an external URL to internal code, so the route has two parts. The first is the path section of the URL, the part after the hostname and port, in our example
it’ll just be <ic>my_course</ic>. The second part references what code it calls, which is usually a method of a controller class.
We’ll hook up <url>http://localhost:3000/my_course</url> to the <method>show</method> method of our not yet written
<class>CoursesController</class> class. We’re using the standard Rails naming convention for the controller action that
displays a single record. Later we’ll learn how to implement the standard URL name with a parameter, but we’ll focus first on how a very simple
route works.
Let’s comment out the <ic>resources</ic> line so we can focus on our new
route:</p>
<code file="code/class_app_new/01_controllers/config/routes.rb"/>
<joeasks>
<title>How does the Match Method Work?</title>
<p>Let’s learn a little more Ruby to understand how the match method works.</p>
<code language="irb">
$ rails c
> result = "courses#show".split('#')                        
 => ["courses", "show"] 
> controller_name = result[0].camelize + "Controller"
 => "CoursesController" 
</code>
<p>First we call <method>split</method>, which is a Ruby <class>String</class> method, to get the two components. Then
we took the first component and call <method>camelize</method> which is a <emph>Rails</emph> <class>String</class> method. Rails
adds a lot of useful methods to the core Ruby classes. </p>
</joeasks>

<p>The routes syntax is chock full of shortcuts, so it looks more like a config file than source code. Remembering our Ruby syntax, we can see that it is actually calling the <ic>match</ic> method
and passing it a <ic>Hash</ic> parameter that has a single key-value pair with <ic>"my_course"</ic> as the key and
<ic>"courses#show"</ic> as the value.</p>
<p>Rails applies a
naming convention that many programmers already know — the Rails routing
syntax of “class#method” is also used in Ruby’s RDoc and ri documentation tools, as well as
Javadocs and documentation tools for other languages.  So, <ic>courses#show</ic> means
that we’ll be creating a <class>CoursesController</class> with a <method>show</method> method to be called when someone browses to
<ic>/my_course</ic>.</p>
<sect3>
<title>Routes Automatically Define Methods</title>
<p>In addition to defining as entry point for our app and referring to a controller method,  we automatically get methods that we can call from our
controller or views based on the names in the path. Let’s run <commandname>rake routes</commandname> to interactively inspect how our route is set up:</p>
<code language="session">
$ rake routes
my_course  /my_course(.:format) {:action=>"show", :controller=>"courses"}
</code>
<p>This little diagnostic script<footnote><p><commandname>rake routes</commandname> was added to Rails in 2007 by Josh Susser, inspired by Rick
Olson’s routing navigator plugin which was turned in a rake task by Chris Wanstrath, founder of github.com.
<url>http://blog.hasmanythrough.com/2007/7/3/check-out-your-routes</url>. If you find yourself wanting a debugging tool,
you might consider experimenting in Ruby, making something useful and adding it to Rails yourself.</p></footnote> originally shows some of the built-in features along with the controller and
action names that we specified explicitly. As part of the URL, we can see the <ic>:format</ic> option.
By default, a request will be assumed to be of <ic>html</ic> format, but this request will respond to <ic>/my_course.html</ic>
explicity or an alternate format like <ic>/my_course.xml</ic> or <ic>/my_course.txt</ic>. Our controller action can provide alternate behavior,
based on the format of the request.</p>
<p>At the beginning of the line is an internal method name that has been defined for us — actually it’s just part
of a method name. The command <commandname>rake routes</commandname> prints <ic>my_course</ic>,
but there are actually two methods <ic>my_course_path</ic> and <ic>my_course_url</ic>. Let’s hop into <commandname>rails
console</commandname>
and check that out:</p>
<code language="irb">
$ rails c
Loading development environment (Rails 3.0.1)
>> app.my_course_path
 => "/my_course" 
>> app.my_course_url
 => "http://www.example.com/my_course" 
</code>
<p> In <commandname>rails console</commandname> we use the <ic>app</ic> object to call these helper methods
interactively, but we can call them directly in our views and controllers.</p>
</sect3>
<p>We can change the name of the method by annotating the route. In our case, we’re using a non-standard name for the
route to our show page, so let’s annotate it with the standard path “course” which is just the model name:</p>
<code file="code/class_app_new/02_controllers/config/routes.rb"/>
<p>We can see the change when we call <commandname>rake routes</commandname>:</p>
<code language="session">
$ rake routes
course  /my_course(.:format) {:action=>"show", :controller=>"courses"}
</code>
<p>By using a standard name, we can now use another Rails URL helper that is built to help us
manage a <emph>resource</emph>, which just means that we can think about and interact with a model rather than
remembering the specific URLs that we’ve set up for it.  Check this out:</p>
<code language="irb">
$ rails c
Loading development environment (Rails 3.0.3)
>> c = Course.first
 => #<Course id: 1, title: "Creative Writing", description: "Learn to write…
>> app.url_for(c)
 => "http://www.example.com/my_course.1" 
</code>
<p>We can call <ic>app.url_for</ic> with a model and it automatically plucks the id from the model and creates a path
from the route that maps to the name of the model. We haven’t yet told it how we want to accept the id as a parameter,
so it just tacks it on the end. When we learn more about where routes lead to and to work with parameters,
we’ll come back and fix up our route.</p>

<figure id="fig.missing-courses-controller">
  <title>We Have a Route but no Controller</title>
  <imagedata fileref="images/controllers/missing-courses-controller.png" />
</figure>

<p>When we refresh our browser, we see the error shown
in <ref linkend="fig.missing-courses-controller"/>: <ic>uninitialized constant CoursesController</ic>. We know that
classes are constants in Ruby, so when the <class>CoursesController</class> can’t be found, we
get a general error that the <emph>constant</emph> is not initialized. Ruby is actually telling us that we have not yet defined
a <class>CoursesController</class> class.</p>
</sect2>
</sect1>
<sect1>
<title>Creating our First Controller</title>
  <p> We put code that connects one web page to the next in the controller, defining the flow of our application. The controller is like a policeman directing traffic across an intersection.  It receives HTTP requests and decides
  what to do with them. People in the right turn lane should be waved right.  Those in the left turn lane should be
  waved left.  The cop knows where to wave the cars based on which lane they arrive in, but also might make exceptions
  to direct trucks to the larger street or cars to the side in the case of an emergency.</p>
  <p>If we think about what we created with scaffold, we have a <class>PeopleController</class> class with a <method>create</method> method
  which redirects to the <method>show</method> page if the <class>Person</class> was successfully
  created, but renders the <ic>new</ic> view if validation failed and the data in
  the form needs to be corrected and re-submmitted. That small amount of direction is at the heart of a controller
  action – one destination for success and a
  different destination for failure. Many controller actions aren’t even that complex and just handle setting up data
  to render a single page.</p>
  <p>Our first controller method for the <ic>show</ic> action will be a simple one with no conditional logic that
  renders a single page. We’ll be displaying a single course by applying what learned about ActiveRecord along with our
  Ruby coding skills to fetch our model and then display its data.  We’ll start with the basics by rendering a dynamic view.</p>
<p>First to fix our latest error, we’ll use the <commandname>rails generate</commandname> script to create a controller. We use the short form of the
controller name, <ic>courses</ic>, to
create our <class>CoursesController</class> class:</p>
<code language="session">
$ rails generate controller courses
      create  app/controllers/courses_controller.rb
      invoke  erb
      create    app/views/courses
      invoke  rspec
      create    spec/controllers/courses_controller_spec.rb
      invoke  helper
      create    app/helpers/courses_helper.rb
      invoke    rspec
      create      spec/helpers/courses_helper_spec.rb
</code>
<p>The generator creates a controller and a <emph>helper</emph> along with a directory for the views and corresponding
tests.  Rails generates not only the controller, but the other files and directories we will usually need: a directory
for our views and a helper module where we keep code shared by our controller and views. Our focus right now is on the
  controller, since the error we needed to resolve is about a missing <class>CoursesController</class>. By
  defining the controller class in <filename>app/controllers/courses_controller.rb</filename>, we have addressed the
  error.</p>
  <p>When we refresh the browser at
<url>http://localhost:3000/my_course</url>, we see an “Unknown Action” error shown in <ref linkend="fig.unknown-action" />.
The error reports that “the action ‘show’ could not be found.”</p>
<figure id="fig.unknown-action">
  <title>We need to define a Controller action</title>
  <imagedata fileref="images/controllers/unknown-action.png" />
</figure>

</sect1>

<sect1>
<title>What’s a Controller Action?</title>
<p>A controller action may take several forms:</p>
<ul>
<li><p>a view template, implemented with EmbeddedRuBy (ERB)</p></li>
<li><p>a controller method that sets up instance variables for a default view template</p></li>
<li><p>a controller method that explicitly calls <method>render</method> or <method>redirect</method></p></li>
</ul>
<p>We’ll start with the simplest controller action by creating a view template with no additional code in our
controller class.</p> 
</sect1>
<sect1>
<title>Creating a View Template</title>
<p>Rails expects view templates for
the <class>CoursesController</class> to be found in the <dir>/app/views/courses</dir> directory. 
This directory was created when we generated the <class>CoursesController</class>. The views are visual
presentation of the human interface to our application, and like URLs, are kept separate from the code in our controller
which will determine the interaction that happens when someone clicks a link or a button.</p>
<p>When Rails matches a route, it will look
for a file with name of the action and “.html.erb” appended.  For the route <ic>courses#show</ic> we’ll create a file
  <filename>/app/views/courses/show.html.erb</filename> with some basic html, such as:</p>
<code file="code/class_app_new/01_controllers/app/views/courses/show.html.erb"/>
<p>Now when we point our browser to: <url>http://localhost:3000/my_course</url> we see &lquot;Here I am!&rquot; in large text as shown in <ref linkend="fig.here-i-am" />. 
</p>
<figure id="fig.here-i-am">
  <title>A simple view</title>
  <imagedata fileref="images/controllers/here-i-am.png"  />
</figure>
<p>Let’s take another look at the Rails log, which is output in the terminal window where we are running <ic>rails
server</ic>. We can now understand what is happening in the text that is spewed out for every request:</p>
<code language="session">
Started GET "/my_course" for 127.0.0.1 at 2011-05-01 15:12:40 -0700
  Processing by CoursesController#show as HTML
Rendered courses/show.html.erb within layouts/application (59.7ms)
Completed 200 OK in 100ms (Views: 99.3ms | ActiveRecord: 0.0ms)
</code>

<p>The server received a <ic>GET</ic> request for <ic>/my_course</ic> which was then processed by the
<class>CoursesController</class> <ic>show</ic> action rendering <ic>courses/show.html.erb</ic> as HTML. When
starting with a new framework, it is easy to let our eyes glaze over as pages of unfamiliar text scroll by, but if we
pay close attention to what the log output looks like normally, it helps us track down what is going on the first time
that our app starts doing something unexpected.</p>
<p>Whew! We wrote a <emph>route</emph> and created a <emph>controller</emph> and saw how Rails automatically called a
<emph>view template</emph> with the same name as the controller action without our needing to write any code in the
controller. That’s pretty cool, but at the moment we have nothing more exciting than we would have with a plain old web page
hosted on a plain old web site. But wait! We have everything in place to write some code for some dynamic content. The
file we made isn’t just a plain old html file, it’s called a view template because we  can add <emph>embedded
Ruby</emph> code to create a different presentation depending on circumstance.</p>
<sect2>
<title>Accepting Parameters in Our View</title>
<p>Let’s look at the parameters that are already built into Rails. These parameters are available to us in a <class>Hash</class> called <ic>params</ic>, which is
accessible from our view or our controller. We usually don’t access parameters directly in our view, but sometimes doing
so is handy for debugging. For now, let’s explore by displaying them in html. We’ll use Ruby in our view to iterate over
the <ic>params Hash</ic> and display each key-value pair:</p>
<code file="code/class_app_new/02_controllers/app/views/courses/show.html.erb"/>
<p>We can see in <ref linkend="fig.params" /> that the controller and action names are passed as parameters. URL query
arguments are passed the same way. In HTTP we can pass name-value pairs as part of the URL like
<url>http://localhost:3000/my_course.html?id=4</url>. These are parsed by Rails and turned into a
<class>Hash</class>, which we can see in the log:</p>
<code language="session">
Started GET "/my_course.html?id=4" for 127.0.0.1 at 2011-05-01 17:52:43 -0700
  Processing by CoursesController#show as HTML
  Parameters: {"id"=>"4"}
Rendered courses/show.html.erb within layouts/application (1.7ms)
Completed 200 OK in 5ms (Views: 5.0ms | ActiveRecord: 0.0ms)
</code>
<p>The log only shows the parameters that come from the browser. Any query argument we add to the URL will be added to
the <ic>params Hash</ic> along with the internal parameters of controller and action name. Try
it. <ref linkend="fig.params-query" /> shows an example with the query arguments <ic>foo=bar&amp;num=1</ic> but they
could, of course, be anything.</p>
<figure id="fig.params">
  <title>Default parameters</title>
  <imagedata fileref="images/controllers/params.png"  />
</figure>
<figure id="fig.params-query">
  <title>Query arguments foo=bar&amp;num=1</title>
  <imagedata fileref="images/controllers/params-query.png"  />
</figure>

</sect2>
<sect2>
<title>Parsing View Parameters from the URL String</title>
<p>These days it is common to use part of the URL to parameterize the view, largely because search engines will ignore
everything after the <ic>?</ic> in a URL and only index a single page, but also because plain URLs are easier to read
when people bookmark them. Rails gives us tremendous flexibility with how we define URLs and map them to our code. This is easy to do in Rails. We just specify
a symbol as part of the URL pattern in our routes and that is automatically parsed and assigned a value in the <ic>params
Hash</ic>. In fact we’ve already seen this with the format extension, as shown in <ref linkend="fig.params-with-format" /></p>
<figure id="fig.params-with-format">
  <title>Default parameters with format in URL</title>
  <imagedata fileref="images/controllers/params-with-format.png"  />
</figure>
<p>Now that we understand how URL parameters work, as well as custom routes, let’s change our route to use the standard
naming convention for a show page. The URL would be <ic>/courses/4</ic> to display the detailed data of a <class>Course</class>
with id 4. We can just make up any name we want, preface it with a colon (:), put it in the route and it will be added
to the <ic>params Hash</ic>. We’ll just use the name “id” because that’s what it is, and unsurprisingly, it matches the
Rails the naming convention.</p>
<code file="code/class_app_new/03_controllers/config/routes.rb"/>
<p>In <commandname>rake routes</commandname>, we can see that the invisible default format param is still there, even if
we specify other params in the URL:</p>
<code language="session">
$ rake routes
course  /courses/:id(.:format) {:controller=>"courses", :action=>"show"}
</code>
<p>We can look in <commandname>rails console</commandname> to see that <ic>url_for</ic> will now return a standard URL:</p>
<code language="irb">
$ rails c
Loading development environment (Rails 3.0.3)
>> c = Course.first
 => #<Course id: 1, title: "Creative Writing", description: "Learn to write…
>> app.url_for(c)
 => "http://www.example.com/courses/1" 
</code>
<p>Later we’ll use <ic>url_for</ic> in our views to link to pages without embedding literal strings which makes our code
harder to maintain.</p>
<p>We’ve learned about routes and how they pass information to views and controllers through the <ic>params Hash</ic> using old fashioned query arguments
as well as new-fangled parameterized URLs. We created a controller, which was
required to route a URL to a view, but we haven’t written any code for a controller yet. We’re now using standard naming
for our <class>Course</class> “show” page, but we have not yet implemented the standard behavior of displaying the model
  data in the show page. We want to keep our view code lean and focused on pure visual layout as much as possible, so
  we’ll put the next bit of code into a controller method.</p>
</sect2>
<sect2>
<title>How do Controller Methods fit in?</title>
<p>Now that we understand routes fairly well, let’s take a look at our controller in <filename>app/controllers/messages_controller.rb</filename>:</p>
<code file="code/class_app_new/03_controllers/app/controllers/courses_controller.rb"/>
<p>We can see there is no code in our subclass of ApplicationController.  So far we’ve been relying on the built-in
Rails behavior where the controller will render the html template with the same name as our action. To see how it works,
let’s use the Rails logger to make an instance method of the same name that just prints out
something we can easily see:</p>
<code file="code/class_app_new/05_controllers/app/controllers/courses_controller.rb"/>
<p>and also add some output when the view is rendered, and we can remove the displaying of params now:</p>
<code file="code/class_app_new/05_controllers/app/views/courses/show.html.erb"/>
<p>Then when we browse to <url>http://localhost:3000/courses/4</url>, we can see the output of <ic>Rails.logger</ic> in
our terminal window. <ic>Rails.logger</ic> does not affect the HTML that is rendered in the view.</p>
<sidebar>
<title>Why use Rails.logger instead of puts?</title>
<p>When we first experimented with Ruby code, we sometimes used <method>puts</method> to see what was going on outside
our program. Let’s see what happens to the output if we use <method>puts</method> instead of <ic>Rails.logger</ic>:</p>
<code language="session">
==================> show method
------------------------> show view


Started GET "/courses/4" for 127.0.0.1 at 2011-05-01 19:15:42 -0700
  Processing by CoursesController#show as HTML
  Parameters: {"id"=>"4"}
Rendered courses/show.html.erb within layouts/application (1.8ms)
Completed 200 OK in 8ms (Views: 6.6ms | ActiveRecord: 0.0ms)
</code>
<p>The server log looks out of sequence here.  The output of the show method happens before the view, but it
appears that the <ic>GET</ic> request started <emph>after</emph> the method and view were called. How could this be? This happens because the Rails
logger saves up its data and writes it once when it completes the HTTP response. Both the <method>puts</method>
method and the Rails logger are printing to the terminal window.</p>
<p>The controller method is called first and then the view is rendered and our statements are
interspersed in the sequence we expect with the built-in logger info. There are various logger methods which correspond
to level <emph>levels</emph>. The output
methods in order of level are: <ic>debug</ic>, <ic>info</ic>, <ic>warn</ic>, <ic>error</ic>, and <ic>fatal</ic>.</p>
<p> By default, Rails will log all levels in every environment except production, where
<ic>info</ic> and higher is logged.  We can set the log level in the environment-specific config files.  Usually we’ll
just leave the log levels as the defaults. In
<dir>app/environments/production.rb</dir>, Rails provides a handy comment <ic>config.log_level = :debug</ic>
which we occasionally turn on in the rare case that we need to debug an issue in production.</p>
</sidebar>
<p>The controller <method>show</method> happens before the view is rendered:</p>
<code language="session">
Started GET "/courses/4" for 127.0.0.1 at 2011-05-01 19:20:56 -0700
  Processing by CoursesController#show as HTML
  Parameters: {"id"=>"4"}
==================> show method!
------------------------> show view!
Rendered courses/show.html.erb within layouts/application (1.6ms)
Completed 200 OK in 5ms (Views: 5.1ms | ActiveRecord: 0.0ms)
</code>
<p>Our controller method gets called before our view is rendered, letting us handle the interaction logic of
what to show to the person using our web app.</p>
</sect2>
</sect1>
<sect1>
<title>Writing a Controller Method</title>
<p>Our controller method decides what to do in response to an HTTP request, usually it renders a view, but it can respond
with an HTTP redirect which will cause the browser to request another URL and the cycle will start all over again.  If a
controller method does not explicitly render a view or redirect, then the implicit behavior, as we saw with
<method>show</method>, is for the
Controller to render a view of the same name. Our controller method is the right place to set up data for our
view. Let’s experiment a bit in Rails console to get a better feel for the Ruby code we’ll need to write.</p>

<p>If our <ic>show</ic> method is called from <ic>/courses/1</ic>, then we’ll want to display the data for the record
with id 1:</p>
<code language="irb">
$ rails c
Loading development environment (Rails 3.0.1)
>> Course.find(1)
 => #<Course id: 1, title: "Creative Writing", description: "Learn to write…
</code>
<p>The id arrives inside our controller as <ic>params</ic>. We saw before that <ic>params</ic> is a <class>Hash</class>.
Is is actually a special subclass of <class>Hash</class>, called <class>HashWithIndifferentAccess</class> that allows us
to treat hash keys the same whether they are a string or a symbol. This is helpful since they key-value pairs of HTTP
query arguments are always strings, yet it is more efficient in Ruby to use symbols. In <ic>rails console</ic>, we can
see this in action:</p>
<code language="irb">
$ rails c
Loading development environment (Rails 3.0.1)
>> params = {}
 => {} 
>> params["id"] = "4"
 => "4" 
>> params[:id]
 => nil 
>> params = HashWithIndifferentAccess.new
 => {} 
>> params["id"] = "4"
 => "4"  
>> params[:id]
 => "4" 
</code>
<p>Now we know that we’ll be able to find the data we want using the <class>ActiveRecord</class> method
<method>find</method> and pass it the id from the query args:</p>
<code language="irb">
>> Course.find(params[:id])
 => #<Course id: 1, title: "Creative Writing", description: "Learn to write…
</code>
<p>To allow us to pass data to the view, Rails sets up another shortcut: whatever instance variables we set in the
controller are then available to us in the view.</p>
<code file="code/class_app_new/06_controllers/app/controllers/courses_controller.rb"/>
<p>The return value of the method is ignored. We’re not seeing exactly how views are created because Rails does that
internally. Part of the strength of the MVC pattern is to keep separate parts of our implementation in separate classes.
When the view is rendered we’re in a completely different context, so we need to specify which data we want sent to the
view and Rails implements this data passing with instance variables that we define in our controller method and can
later access in our view.</p>
<code file="code/class_app_new/06_controllers/app/views/courses/show.html.erb"/>
<p>After our <method>show</method> controller method executes, the
<class>ActionController</class> superclass looks through its own instance variables to see which ones have been added. It then
copies them into a <class>Hash</class> which the view uses to set its own instance variables.  This temporary
storage is called <ic>assigns</ic>, which we’ll use when we’re testing.</p>

<joeasks>
<title>Aren’t instance variables private?</title>
<p>The way that Rails passes data via instance variables between controller and a view is concise, but makes it seem
like instance variables aren’t really private. The view, which exists in the context of an entirely
different class <class>ActionView</class>, seems to have access
to the private instance variables of the controller. However, in reality, the view doesn’t directly access to the controller
instance variables. Whew, isn’t that a relief?  </p>
<p>In Ruby, instance variables <emph>are private</emph> to an instance of a class. This is no different inside of Rails.
However, in Ruby we can get a list of our instance variables and see what they are. Check this out inside of irb:</p>
<code language="irb">
$ irb
>> instance_variables
 => [:@prompt] 
>> old = instance_variables
 => [:@prompt] 
>> @foo = 1
 => 1 
>> @bar = "something"
 => "something" 
>> instance_variables
 => [:@prompt, :@foo, :@bar] 
>> new = instance_variables - old
 => [:@foo, :@bar] 
</code>
<p>With the model and view, Rails appears to mix together two separate
concern, but it is merely an unusual message passing convention.</p>
</joeasks>

<p>Through exploration in the browser and Rails console, we have worked through the creation of a route, controller
method and a corresponding view. We’ve learned a few variations on the <method>match</method> for declaring routes. We
built a controller action, both with just a view and by setting up data for the view with a controller method.
Later in the book, we’ll learn more ways to declare routes and understand more about the <method>resources</method> method, which was
originally added to our routes with scaffold for our <class>PeopleController</class>.  In the next chapter, we will test drive more of our <class>CourseController</class> development using the REST pattern and Rails
conventions.</p>



</sect1>

</chapter>
