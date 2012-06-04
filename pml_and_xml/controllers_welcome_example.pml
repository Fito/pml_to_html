<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.controllers">
  <title>Routes and Controllers</title>
  <p><ed>Ok, this chapter really feels like it's nearly twice as long as it needs to be, and I don;t think that's because of the concepts or the content as much as the way the content is presented. I've left lots of comments about that throughout. I like where this is going and it's obvious you spent a lot of time working on it. There are two major issues I'd like you to think about with this chapter:</ed></p>
  <p><ed>First, this is a very long chapter. In your book proposal, you mentioned how each chapter would do some experimentation in the console and IRB but then do the hands-on stuff with tests first. We don't get to the hands-on stuff till pretty far in, and I wonder if some of the experimentation stuff we do could be better expressed with tests. To be clear, I don't think that the chapter would end up much shorter, but I question how much time we need to spend going over things only to go over them again in tests. Perhaps the part where you parse params out of the route can go, because you never use it later - we don't do a show or update. </ed></p>
  <p><ed>The other thing is a bit of a tone issue - it feels like you're trying too hard to be conversational - you've over-corrected a bit in a few places and towards the end of the chapter it becomes very noticeable and a bit tiring. </ed></p>
  
  <p><ed>Content-wise, it's pretty good. It hits all the good points.</ed></p>

     <p>When we create a web application, we craft a unified experience from a series of web pages. 
  Sometimes a single interaction takes place across multiple HTTP requests.</p><p>Let’s take another look at the pages
  that scaffold made for our <class>person</class> model. Making sure we’re in our
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
  <p> Wrangling these disjoint pages into
  manageable code was challenging in the 1990’s when everyone was first creating web apps, but people recognized a
  Model-View-Controller pattern that made it easier. In <ref linkend="ch.firstapp"/>, we learned about views, how the visual part of our web user interface, are made with
  Embedded Ruby templates in Rails. Then we learned about the model, in  <ref linkend="ch.activerecord"/> and <ref
  linkend="ch.activerecord-rspec"/>.  Next we’ll learn about how <firstuse>routes</firstuse> and
  <firstuse>controllers</firstuse> glue the views together and let us specify the
  interaction part of our user interface. These core Rails components help us focus on supporting effective human interface design with a small amount of maintainable code.</p>
    <p>In Rails, a <emph>route</emph> specifies how an incoming URL calls our code. Routes are like street signs that point to destinations.  When someone accesses a URL of a Rails web
    application, Rails uses the routes specified in <filename>config/routes.rb</filename><ed> filename tag, not ic</ed> to figure out what to do.  This file
    contains a mapping of each URL to our Ruby code which decides what to do. </p>
<p>When we created our app with <commandname>rails new</commandname> the <filename>routes.rb</filename> file was created with no
routes defined. However, it is a deceptively lengthy file because Rails includes a kind of in-line documentation with
many comments that show different example route syntax. When we ran the scaffold generator, it modified this file to add
just one <ic>resources</ic> declaration: </p>
<code file="code/class_app_new/00_controllers/config/routes.rb"/>
<p>From that one line, we defined 7 routes which we explored interactively in <ref
linkend="sec.scaffold-rest-mvc"/>.
The <ic>resources</ic> method provides a nice shortcut for defining all of the standard REST routes; however, to use Rails effectively we need to understand what’s really going on. We’ll build a similar set of routes and corresponding controller behavior for our
<class>Course</class> model one step at a time.</p>
<sect1>
<title>Responding to a URL Request</title>
 
  <p><ed>I liked where you referred us back to the previous app in your intro. Should you maybe walk through that app
  instead of having us do a new one? A diagram here might be helpful too. Help us think in terms of what we've built. If
  you're going to have us build that first Rails app, you might as well use it throughout this first part as the
  example.</ed> When we go to <url>http://localhost:3000/people</url>, the browser sends the HTTP
  request <ic>GET /people</ic> to the server running at <ic>localhost</ic> (listening on port 3000). If the server were a plain old web server, it
  would just respond with the contents of the default file in the
  <dir>people</dir><ed>dirname?</ed><author>Sarah:ok</author> directory, usually
  <filename>index.html</filename>. But our Rails app dynamically
  determines what page to send back to the browser.</p>
<p>To understand how these dynamic web pages work in Rails, we’ll follow an HTTP request from typing an URL into the browser
through a route to learn about the code we need to write to make it work.</p>
<p> We’re going to make a page that shows a welcome message like “hello” or “good morning.” <ed>I get where you're going, but this and the previous paragraph kind of say the same thing. Can you shorten it up? Maybe just lose the next sentence?</ed>  But to understand exactly
how routes work, we’ll just go to some URL we haven’t built yet and see what happens. When we point our browser to
<url>http://localhost:3000/hello</url>, we see the routing
error shown in <ref linkend="fig.routing-error" />. Go ahead and try it. </p>
<figure id="fig.routing-error">
  <title>We Have Not Yet Specified Where the URL Goes</title>
  <imagedata fileref="images/controllers/routing-error.png"  />
</figure>
<p>This error tells us that the URL /hello is not hooked up to anything. There is no <emph>route</emph> into the app
that matches that string.</p>
<sect2>
<title>Let’s Create a Route</title>
<p>Our routes are defined <ed>no, we haven't defined them. How about "We define routes in...."</ed> in <filename>config/routes.rb</filename>. When this file is generated by <ic>rails new</ic> it
includes a lot of comments in it, which can remind you of the syntax later. We’ll be starting with a simple routes, so let’s delete the
comments to more easily see what’s going on.  Writing our first route will make the file look like this: <ed>That feels awkward... and I think you need to explain what we're writing first in this case - how would I know what to write?</ed></p>
<code file="code/message_app0/config/routes.rb"/>
<p>The routes file looks almost like a configuration file — it is even kept in the config directory; however it is
executable Ruby code. <ed>I wonder if that last sentence belongs next to the one about all the comments. </ed>Remembering our Ruby syntax, we can see that it is actually calling the <ic>match</ic> method
and passing it a <ic>Hash</ic> parameter that has a single key-value pair with <ic>"hello"</ic> as the key and
<ic>"messages#greeting"</ic> as the value.</p>
</sect2>
<sect2>
<title>What does that route do?</title>
<p><ed>I think this is too far away from the definition of the route. And why is it a subsection?</ed> The route maps an external URL string to internal code. It let’s <ed>do you mean "lets"?</ed> us separate the human experience of our application
from the internals. After we build our application, we can easily edit this file if inspiration strikes us with better
names. This adds to our development velocity. We don’t need to design everything up front or have a meeting to figure
out the best names, since we can easily change it later.<author>Liah: this is reiterating the point made earlier about being able to easily change routes.  I think it is an interesting point, but I'm not sure it fits in either of the current locations</author></p>
<p><author>Liah: by the time I got down here I'd gotten off track of the code in the last section...I think the next two sentences belong next to the route code above.  Then this section could be more about routing internals and how rails parses the code we put in routes.rb</author>Specifically, in this route, we’ve hooked up the URL “/hello”<author>Liah: should use the html entities</author><ed>I agree with Liah, and  the tangent about developer velocity and meetings to discuss names seems off. I would much rather see this discussion about routes here than in the previous location though.</ed> to a class called
<class>MessagesController</class>. When Rails receives a request for "/hello" it will now call the
<class>MessagesController</class> and invoke the  <method>greeting</method> action. <ed>I think you have made this point a few times, and if you haven't, I think you want to say this well before we define the first route.</ed> Rails applies a
naming convention that many programmers already know — the Rails routing
syntax of class#method is also used in Ruby’s RDoc and ri documentation tools, as well as
Javadocs and other languages. The <method>match</method> method takes the first
part of the route destination, “messages,” capitalizes it, concatenates it with "Controller" and looks for
a class of that name. In this case, <class>MessagesController</class>.  So, <ic>messages#greeting</ic> means
that we’ll be creating a <class>MessagesController</class> with a <method>greeting</method> method to be called when someone browses to
<ic>/hello</ic>.</p>
<figure id="fig.missing-messages-controller">
  <title>We Have a Route but no Controller</title>
  <imagedata fileref="images/controllers/missing-messages-controller.png" />
</figure>

<p>We haven’t finished yet, but let’s explore what we have so far by refreshing our browser. This time we see the error
in <ref linkend="fig.missing-messages-controller"/>: <ic>uninitialized constant MessagesController</ic>. We know that, in Ruby, classes are constants, so when the <class>MessagesController</class> can’t be found, we
get a general error that the <emph>constant</emph> is not initialized. Ruby is actually telling us that we have not yet defined
a <class>MessagesController</class> class.</p>
</sect2>
</sect1>
<sect1>
<title>Creating our First Controller</title>
<p>We’ll use the <commandname>rails generate</commandname> script to create a controller. We use the short form of the
controller name, <commandname>messages</commandname>, to
create our <class>MessagesController</class>:</p>
<code language="session">
$ rails generate controller messages
      create  app/controllers/messages_controller.rb
      invoke  erb
      create    app/views/messages
      invoke  test_unit
      create    test/functional/messages_controller_test.rb
      invoke  helper
      create    app/helpers/messages_helper.rb
      invoke    test_unit
      create      test/unit/helpers/messages_helper_test.rb
</code>
<p>The generator creates a controller and a <emph>helper</emph> along with a directory for the views and corresponding
tests.  Rails generates not only the controller, but the other files and directories we will usually need: a directory
for our views and a helper module where we keep code shared by our controller and views. Our focus right now is on the
  controller, since the error we needed to resolve is about a missing <class>MessagesController</class>. By
  defining the controller class in <filename>app/controllers/messages_controller.rb</filename>, we have addressed the
  error.</p>
  <p>Let’s see what happens next. <ed>I don't think you need any of these "let's see what happens next" bits you're adding. They're becoming very repetitive.</ed> When we refresh the browser at
<url>http://localhost:3000/hello</url>, we see an “Unknown Action” error shown in <ref linkend="fig.unknown-action" />.
The error reports that “the action ‘greeting’ could not be found.”</p>
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
<p>Let’s start with the simplest controller action by creating a view template with no additional code in our
controller class.</p>  
<sect2>
<title>Creating a View Template</title>
<p>Rails expects view templates for
the <class>MessagesController</class> to be found in the <dir>/app/views/messages</dir> directory. 
This directory was created when we generated the <class>MessagesController</class>. The views are visual
presentaion of the human interface to our application, and like URLs, are kept separate from the code in our controller
which will determine the interaction that happens when someone clicks a link or a button.</p>
<p>When Rails matches a routes, it will look
for a file with name of the action and “.html.erb” appended.  For the route <ic>messages#greeting</ic> we’ll create a file
  <filename>/app/views/messages/greeting.html.erb</filename> with some basic html, such as:</p>
<code file="code/message_app0/app/views/messages/greeting.html.erb"/>
<p>Now when we point our browser to: <url>http://localhost:3000/hello</url> we see &lquot;Here I am!&rquot; in large text as shown in <ref linkend="fig.here-i-am" />. 
</p>
<figure id="fig.here-i-am">
  <title>A simple view</title>
  <imagedata fileref="images/controllers/here-i-am.png"  />
</figure>
<p>Let’s take another look at the Rails log, which is output in the terminal window where we are running <ic>rails
server. We can now understand what is happening in the text that is spewed out for every request:</ic>:</p>
<code language="session">
Started GET "/hello" for 127.0.0.1 at 2011-01-02 12:34:07 -0800
  Processing by MessagesController#greeting as HTML
Rendered messages/greeting.html.erb within layouts/application (40.5ms)
Completed 200 OK in 76ms (Views: 75.1ms | ActiveRecord: 0.0ms)
</code>

<p>The server received a <ic>GET</ic> request for the "/hello" URL which was then processed by the
<class>MessagesController</class> <ic>greeting</ic> action rendering "messages/greeting.html.erb" as HTML. When
starting with a new framework, it is easy to let our eyes glaze over as pages of unfamiliar text scroll by, but if we
pay close attention to what the log output looks like normally, it helps us track down what is going on the first time
that our app starts doing something unexpected.<author>Liah: this sentence is weird</author><author>Sarah: better?</author></p>
<p>Whew! We wrote a <emph>route</emph> and created a <emph>controller</emph> and saw how Rails automatically called a
<emph>view template</emph> with the same name as the controller action without our needing to write any code in the
controller. That’s pretty cool, but at the moment we have nothing more exciting than we would have with a plain old web page
hosted on a plain old web site. But wait! We have everything in place to write some code for some dynamic content. The
file we made isn’t just a plain old html file, it’s called a view template because you <ed>we</ed>  can add <emph>embedded
Ruby</emph> code to create a different presentation depending on circumstance.<author>Liah: I like this paragraph</author></p>
</sect2>
<sect2>
<title>Looking at our Routes</title>
<p>Rails comes with a handy rake task <ed>does Rake need to be capitalized?</ed> that lets us look at the routes that are defined in our application.  Try this:</p>
<code language="session">
$ rake routes
hello  /hello(.:format) {:action=>"greeting", :controller=>"messages"}
</code>
<p>The first thing that is printed out is an internal method name that has been defined for us — actually it’s just part
of a method name.
<commandname>rake routes</commandname> prints <ic>hello</ic>,
but there are actually two methods <ic>hello_path</ic> and <ic>hello_url</ic>. Let’s hop into <ic>rails console</ic>
and check that out:</p>
<code language="irb">
$ rails c
Loading development environment (Rails 3.0.1)
>> app.hello_path
=> "/hello" 
>> app.hello_url
=> "http://www.example.com/hello"
</code>
<p><ed>very cool way to show those urls.</ed> When we define a route using <commandname>match</commandname>, we automatically get methods that we can call from our
controller or views based on the names in the path. It’s awkward to get into the context of our controller and views in
irb, so rails console has an <ic>app</ic> object that we can use to call these helper methods interactively. If we
wanted to change this internal name, we could modify our route, like:</p>
<code file="code/message_app1/config/routes.rb"/>
<p>When we specify <ic>:as</ic> that only affects the names of the internal methods that are dynamically generated for
your routes. These internal names are important because they let us separate what the human bookmarks and
search engines see from what’s going on inside our well ordered code. Let’s see that change in <ic>rake routes</ic>:</p>
<code language="session">
$ rake routes
greeting  /hello(.:format) {:action=>"greeting", :controller=>"messages"}
</code>
<p>Now we could use <ic>greeting_path</ic> and <ic>greeting_url</ic> in our code. The next component in the output of
<ic>rake routes</ic> is the URL path that will match the
route <ic>/hello</ic>, and then what the URL is hooked up to, in this case the <ic>greeting</ic> action of the
<ic>MessagesController</ic>.  The one additional piece of information provided here is the optional <ic>:format</ic>.
By default, a request will be assumed to be of <ic>html</ic> format, but this request will respond to /hello.html
explicity or an alternate format like /hello.xml or /hello.txt. Our controller action could provide alternate behavior,
based on the format of the request.</p>
</sect2>
<sect2>
<title>Accepting Parameters in Our View</title>
<p>We started this adventure seeking to create a greeting at the URL <ic>/hello</ic>. Let’s look at how we would
customize our view to accept a parameter. In HTTP we can pass name-value pairs as part of the URL like
<url>http://localhost:3000/hello?name=emma</url>.  These are parsed by Rails and turned into a
<class>Hash</class>, which we can see in the log:</p>
<code language="session">
Started GET "/hello?name=emma" for 127.0.0.1 at 2011-02-05 19:24:06 -0800
  Processing by MessagesController#greeting as HTML
  Parameters: {"name"=>"emma"}
Rendered messages/greeting.html.erb within layouts/application (2.9ms)
Completed 200 OK in 7ms (Views: 6.8ms | ActiveRecord: 0.0ms)
</code>
<p>In our controller and view we have access to these as <ic>params</ic>, so if we wanted to say “Hello Emma!” when we
pass <ic>name=emma</ic> as a query arg, we could change the view to include embedded Ruby that accesses the paramter:</p>
<code file="code/message_app1/app/views/messages/greeting.html.erb" part="one"/>
<figure id="fig.hello-emma">
  <title>View with a Parameter from a Query Arg</title>
  <imagedata fileref="images/controllers/hello-emma.png"  />
</figure>
<p>When we go to <url>http://localhost:3000/hello?name=emma</url>, we can see in <ref linkend="fig.hello-emma" /> that
the view faithfully reproduced the name as written in the query arg with a lowercase “e”.</p>
<p>We could fix this by writing a bunch of Ruby code in the view, but that would quickly lead to our stuffing most of
our application code into the view, which is hard to work with after a while.</p>
<p>The <ic>params</ic> Hash is accessible in the view, but we don’t access it
directly there except occasionally for debugging. Instead we  like to keep very little code in the view so that it is easy to focus on the implementation of the visual design when we’re editing the view template. We use a controller action to set up data for the view. This is the
<emph>VC</emph> part of the MVC pattern.</p>
</sect2>
<sect2>
<title>View Parameters as Part of the URL</title>
<p>These days it is common to use part of the URL to parameterize the view. This is easy to do in Rails. We just specify
a symbol as part of the URL pattern in our routes and that is automatically parsed and assigned a value in the params
Hash:</p>
<code file="code/message_app2-0/config/routes.rb"/>
<p>Now we can go to <ic>http://localhost:3000/hello/emma</ic> and params[:name] will be assigned the value “emma” which
will cause “Hello emma” to appear in our view.  If we want to make the name optional, we can include it as part of the
route in parenthesis:</p>
<code file="code/message_app2-1/config/routes.rb"/>
<p>Rails gives us tremendous flexibility with how we define URLs and map them to our code.</p>
</sect2>
<sect2>
<title>Writing a Controller Method</title>
<p>Let’s take a look at our controller in <filename>app/controllers/messages_controller.rb</filename>:</p>
<code file="code/message_app0/app/controllers/messages_controller.rb"/>
<p>We can see there is no code in our subclass of ApplicationController.  So far we’ve been relying on the built-in
Rails behavior where the controller will render the html template named in the second part of our route
<ic>messages#greeting</ic>. To see how it works, let’s make an instance method of the same name that just prints out
something we can easily see:</p>
<code file="code/message_app1/app/controllers/messages_controller.rb"/>

<p>and also add some output when the view is rendered:</p>
<code file="code/message_app1/app/views/messages/greeting.html.erb" part="two"/>

<p>The Ruby method <method>puts</method> prints text to <emph>standard out</emph> which is the terminal window
where we’re running the server. It does not affect the HTML that is rendered in the view.</p>
<code language="session">
=> Booting WEBrick
=> Rails 3.0.1 application starting in development on http://0.0.0.0:3000
=> Call with -d to detach
=> Ctrl-C to shutdown server
[2011-02-06 10:08:04] INFO  WEBrick 1.3.1
[2011-02-06 10:08:04] INFO  ruby 1.9.2 (2010-08-18) [x86_64-darwin10.4.0]
[2011-02-06 10:08:04] INFO  WEBrick::HTTPServer#start: pid=21220 port=3000
==================> greeting method
------------------------> greeting view

Started GET "/hello" for 127.0.0.1 at 2011-02-06 10:08:18 -0800
  Processing by MessagesController#greeting as HTML
Rendered messages/greeting.html.erb within layouts/application (2.3ms)
Completed 200 OK in 22ms (Views: 21.6ms | ActiveRecord: 0.0ms)
</code>
<p>The server log looks out of sequence here.  We can see that the greeting method is called before the view, but it
shows the <ic>GET</ic> request started <emph>after</emph> the method and view were called. How could this be? This happens because the Rails
logger saves up its data and writes it once when it completes the HTTP response. Both the <method>puts</method>
method and the Rails logger are printing to the terminal window.</p>
</sect2>
<sect2>
<title>Using the Rails Logger</title>
<p>Let’s see what happens when we use
<ic>logger.info</ic> instead of <ic>puts</ic>:</p>
<code file="code/message_app2/app/controllers/messages_controller.rb"/>

<code file="code/message_app2/app/views/messages/greeting.html.erb" part="two"/>
<p>We can see that the <ed>I think you can start here without the "we can see that"</ed> output is printed in the sequence that we would expect:</p>
<code language="session">
=> Booting WEBrick
=> Rails 3.0.1 application starting in development on http://0.0.0.0:3000
=> Call with -d to detach
=> Ctrl-C to shutdown server
[2011-02-06 10:24:00] INFO  WEBrick 1.3.1
[2011-02-06 10:24:00] INFO  ruby 1.9.2 (2010-08-18) [x86_64-darwin10.4.0]
[2011-02-06 10:24:00] INFO  WEBrick::HTTPServer#start: pid=21455 port=3000

Started GET "/hello" for 127.0.0.1 at 2011-02-06 10:24:03 -0800
  Processing by MessagesController#greeting as HTML
==================> greeting method!
------------------------> greeting view!
Rendered messages/greeting.html.erb within layouts/application (1.9ms)
Completed 200 OK in 8ms (Views: 7.5ms | ActiveRecord: 0.0ms)
</code>
<p>We can see that <ed>again here... no "we can see that" </ed> the controller method is called first and then the view is rendered and our statements are
interspersed in the sequence we expect with the built-in logger info. There are various logger methods which correspond
to level <emph>levels</emph>. The output
methods in order of level are: <ic>debug</ic>, <ic>info</ic>, <ic>warn</ic>, <ic>error</ic>, and <ic>fatal</ic>.</p>
<p> By default, Rails will log all levels in every environment except production, where
<ic>info</ic> and higher is logged.  We can set the log level in the environment-specific config files.  Usually we’ll
just leave the log levels as the defaults. In
<dir>app/environments/production.rb</dir>, Rails provides a handy comment <ic>config.log_level = :debug</ic>
which we occasionally turn on in the rare case that we need to debug an issue in production.</p>
</sect2>
<sect2>
<title>Writing Custom Controller Methods</title>
<p>Now we understand that our controller method is called before the view is rendered.  In fact, it is the job of
the controller method to render a view and if it does not render a view, then the implicit behavior is for the
Controller class to render a view of the same name.  So, our previous version of the <method>greeting</method>
method that had no content could also have been written like this to create the exact same behavior:</p>
<code file="code/message_app2-1/app/controllers/messages_controller.rb"/>
<p>By default Rails will assume the <ic>.html.erb</ic> extension, but we could have explicitly written <ic>render 'greeting.html.erb'</ic> and if we had wanted to be even more explicit we could write <ic>render
:template => 'messages/greeting.html.erb'</ic></p>

<p><ed>This feels like you're throwing everything you know about controllers in here. "We can do this.. and we can do this..." but there's not any application. You need to explain the "why" and it can't just be "cos we can."</ed></p>


<p>Let’s dig into some more implicit behavior to understand how we usually
set up data for the view template in the controller:</p>
<code file="code/message_app3/app/controllers/messages_controller.rb"/>
<code file="code/message_app3/app/views/messages/greeting.html.erb"/>
<p>Whatever instance variables we set in the controller are then available to us in the view. Hold on there, partner…
what’s up with that?</p>
<p>We’re not seeing exactly how views are created because Rails does that internally, but MVC is
supposed to keep separate parts of our app in separate classes. If the view is in a separate class from the controller,
how could it be that instance variables are shared? In Ruby, instance variables are private to an instance of a class. Could Rails
somehow be different from the Ruby language and create a situation where instance variables are public? Not at all, but Rails does use some dynamic
language tricks to share data between controllers and their views. The syntax is nice because it is concise, but can be confusing to experienced
object-oriented programmers and Ruby novices until we know what is really going on.<author>Liah: I think this paragraph break is
splitting up an idea.  Also, the word disturbing disturbs me. It doesn't describe what the actual problem is and feels
like hyperbole.  I think you could rework the ideas here to be more engaging and clear.</author><author>Sarah: re-wrote
that bit</author><ed>This sounds like a joeasks and doesn't feel right here.</ed></p>
<p>In Rails, the relationship between the controller
and view seems to subvert the whole object-oriented paradigm. The view, which exists in the context of an entirely
different class <class>ActionView</class>, seems to have access
to the private instance variables of the controller. However, in reality, the view doesn’t directly access to the controller
instance variables. Whew, isn’t that a relief?  <ed>why is this concept important for us to know right now? Do you get people complaining about this when you teach them, or is this something that *you* feel is a problem with Rails? How does knowing this benefit the reader? I think that's lost. We're not dealing with this concept right now, so we're not going to know why we should care. (hint: see next comment!)</ed> After our <method>greeting</method> controller method executes, the
<class>Controller</class> looks through its own instance variables to see which ones have been added. It then
copies them into a <class>Hash</class> which the view uses to set its own instance variables.  This temporary
storage is called <ic>assigns</ic>, which we’ll use when we’re testing. <ed>This is important. Can you replace all that stuff above with this nice, brief explanation?</ed></p>
<p>Mostly Rails implements shortcuts which fit easily into a clear conceptual model of how a web application works.
Often Rails follows best practices of object-oriented design — not so in this case. Rails fails us by mixing together two separate
concerns. We can only speculate as to what possessed David Hansson to rummage through the private instance variables of
one object in order to pass a message to another class. It sure is nice to only have to type one extra character to
indicate that a variable is destined for a view, but couldn’t he have chosen ‘_’ or maybe ‘v’? It is unfortunate that we need to understand
the Rails internals in order to effectively use this communication between controllers and their views and not get
confused about how the Ruby language works in general. But now that we know, we can move on and effectively use this
weird message passing convention.<ed>We talked about adding your opinions, but this rhetorical style here isn't a good fit. I think you can make the point without the "speculation" part. Personally, I agree with you, but I've never once bothered to point this out, and it's only experienced Rails developers who notice. So I wonder if you might just phrase this as just a couple of sentences like "When Rails renders a view, it takes all of the instance variables and sends them along to the view without your intervention While this is a clear violation of accepted object-oriented practices, it does let us reach our goal faster. However, we have to understand how it works in order to properly test it." and you can talk about the assigns hash in there somewhere. This is another reason why I think getting to the TDD stuff early could be beneficial-you could talk about assigns and how it works and then talk about how it's a compromise between good code practices and ease-of-use.</ed></p>

<p><ed>Ok, here we are some ways into the chapter and we've not talked about testing. I understand that your approach is to show it one way and then show it again but with tests, but I really think that you need to get to the testing stuff a lot earlier in these chapters. A lot of what you discussed can be taken care of a little quicker. You're calling this book "test first rails" and the chapters I've seen have us doing testing later. At what point do we actually get to "testing first"? Suggestion: Can the "your first Rails app" chapter cover all of this "how routes work, how controllers and views and stuff work" so we can get a lot of that out of the way all at once? Some of the other details, like adding the route, etc, can be covered by looking at the output of failing tests instead of looking at the output in the console or in the browser. </ed></p>


</sect2>
</sect1>
<sect1>
<title>Understanding Controllers through Testing</title>
<p>In the most common controller tests, we use the <ic>assigns Hash</ic> to verify that a
controller method has correctly set up data for the view and we check that the correct template is rendered. Let’s write a controller for the <class>Person</class>
model in our class app using a test first
approach. <ed>why? What are we really building? A user interface to manage people? Or something different?</ed> We can use an RSpec generator to create our people controller spec file. Remember the
<class>Controller</class> works with multiple <class>Person</class> models, so it is plural:</p>
<code language="session">
  $ rails generate rspec:controller people
</code>
<p>Let’s first make sure that when we browse to the <ic>people/index</ic> page the
<class>PeopleController</class> renders the <ic>index</ic> template: <ed>is that really what you want to test? You told us that Rails will do that. I think you want to test that there's a template to render. Or that the URL works.</ed></p>
<code file="code/class_app/1_controller/spec/controllers/people_controller_spec.rb"/>
<p>When we’re testing controllers, we’ll use a <emph>nested describe</emph> to group each request. In this spec, we’ve got
an overall context for the <class>PeopleController</class> on line <cref linkend="code.people_controller_context"/> and
within that another context for <ic>"GET index"</ic> on line <cref linkend="code.people_index_context"/>  which is
just a string that tells us which request we’re testing.</p>
<p>Now that we’ve set up the example, we’re on to the interesting part! On line <cref linkend="code.get_index"/> we’re calling the
<method>index</method> method of the controller as if it came from a <ic>GET</ic> request. We’re not 
really performing an <ic>HTTP GET</ic> — we’re calling the controller using some testing
helpers which call into Rails the same way the web server will. Those same testing helpers create a <ic>response</ic> object to store the result. We then verify on line <cref linkend="code.should_render"/> that the
controller method rendered the template <filename>index.html.erb</filename>. </p>
<p>Whew! At first glance, it seems
like we’re learning a lot of extra stuff just for testing. But as we dig in, we find out that this extra stuff is just part
of how controllers work. By learning to test controllers, we understand them.<ed>and this is why I think this should be all the chapter should be about. And this feels more like a conclusion to the chapter than something that belongs right here.</ed></p>
<p>So, let’s run the spec!</p>
<code language="session">
$ rake spec
(in /Users/sarah/class_app)
/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -S bundle exec 
rspec ./spec/controllers/people_controller_spec.rb ./spec/models/assignment_spec.rb 
./spec/models/person_spec.rb
/Library/Ruby/Gems/1.8/gems/rspec-core-2.5.1/lib/rspec/core/backward_compatibility
.rb:20:in `const_missing': uninitialized constant PeopleController (NameError)
	from /Users/sarah/class_app/spec/controllers/people_controller_spec.rb:5
  …
  …long stack trace here…
  …
rake aborted!
ruby -S bundle exec rspec ./spec/controllers/people_controller_spec.rb 
./spec/models/assignment_spec.rb ./spec/models/person_spec.rb failed
</code>
<p><ed>how much of that stack trace do you need to show to effectively show the error?</ed></p>
<p>Here’s our old friend, the <ic>uninitialized constant</ic> error, telling us that we have not yet
defined our <class>PeopleController</class> class. We’ll generate one, being careful not to overwrite our spec
when prompted:<ed>wait, why would we end up overwriting our spec? Should you explain that? and isn't there an option to skip spec generation?</ed> </p>
<code language="session">
$ rails generate controller people
      create  app/controllers/people_controller.rb
      invoke  erb
      create    app/views/people
      invoke  rspec
    conflict    spec/controllers/people_controller_spec.rb
  Overwrite /Users/sarah/class_appplt 
  (enter "h" for help) [Ynaqdh] n
        skip    spec/controllers/people_controller_spec.rb
      invoke  helper
      create    app/helpers/people_helper.rb
      invoke    rspec
      create      spec/helpers/people_helper_spec.rb    
</code>
<p>Defining the <class>PeopleController</class> class in <filename>app/controller/people_controller.rb</filename>
should address our first spec error. We don’t expect to be done yet, but we still run the spec again to see that our test
fails in the way we expect:</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
(in /Users/sarah/src/satfr/Book/code/message_app)
F
Failures:

  1) PeopleController GET index renders
     Failure/Error: get :index      
     ActionController::RoutingError:
       No route matches {:controller=>"people"}
     # ./spec/controllers/people_controller_spec.rb:8:in `block (3 levels)
     in <top (required)>'

Finished in 0.10692 seconds
1 example, 1 failure
</code>
<p>We’re seeing the same kinds of errors we saw interactively when we were experimenting with the web app, so we know we
are on the right track.  This error is similar to the one we saw in <ref linkend="fig.routing-error" /> except we’re
looking at it from the other direction. Instead of a URL that has no route connecting it to a controller action, we have
a controller action with no route leading to it.</p>
<p>Of course, to fix this we need to a add route. Looking in <filename>config/routes.rb</filename>, we see a lot of
comments generated as inline documentation for Rails. Let’s just delete those and add a simple route that matches our
people index page to our people index action:</p>
<code file="code/class_app/1_controller/config/routes.rb"/>
<p>That looks a little redundant, but for now let’s do <emph>the simplest thing that could possibly work</emph>. We’ll
worry about code prettiness later, because we know we’re still not done. Let’s run the spec again and expect to watch it fail:</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
F

Failures:

  1) PeopleController GET index renders
     Failure/Error: get :index       
     AbstractController::ActionNotFound:
       The action 'index' could not be found for PeopleController
     # ./spec/controllers/people_controller_spec.rb:8:in `block (3 levels) 
     in <top (required)>'

Finished in 0.0427 seconds
1 example, 1 failure
</code>
<p>Now the failure points to a missing action <ic>index</ic> for our <class>PeopleController</class>. We have
multiple options for how to create a controller action: write a controller method, create a view template or both. Let’s
do the simplest thing:</p>
<code language="session">
$ touch app/views/people/index.html.erb
</code>
<p>Um… huh? <ed>that doesn't work for me.</ed> We just used the Unix command <commandname>touch</commandname> which will create an empty file if it doesn’t
already exist <ed>which does not work on windows. have to  use echo instead, or use Ruby to create the file.</ed> In our controller spec, we’re verifying that the response is set up to render a specific template, but
we’re not yet checking to see if the view has anything interesting in it. We’re just making sure it is all hooked up. Let’s run the spec and see how that works:
</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
.

Finished in 0.07397 seconds
1 example, 0 failures
</code>
<p>Woo hoo! Our spec passes!</p>
<p>Time for a beer? Not yet! It is now time for us to reflect on our code and make it better if we see room for
improvement. This is the third step of TDD’s red-green-refactor mantra. Let’s take a look at the route we created, from
two angles. Here’s the declaration:</p>
<code file="code/class_app/1_controller/config/routes.rb"/>
<p>The other way we can look at our routes is with <commandname>rake routes</commandname>:</p>
<code language="session">
$ rake routes
people_index  /people/index(.:format) {:controller=>"people", :action=>"index"}
</code>
<p>Now there are are two things that aren’t lovely about this route. First we’re using a non-standard name for the
route — usually we simply call the route the main people page <ic>people_path</ic> rather than
<ic>people_index_path</ic>. The second bit is actually the cause of this. We can specify the index page more concisely
since that is the default page for any route:</p>
<code file="code/class_app/1a_controller/config/routes.rb"/>
<p>Now when we look at our routes, we see:</p>
<code language="session">
$ rake routes
people  /people(.:format) {:action=>"index", :controller=>"people"}
</code>
<p>Ah. Lovely. Go grab yourself a beverage!</p>
<sect2>
<title>Testing More Controller Action</title>
<p>Controller tests are all about the details of the <emph>controller</emph> — we’re not testing the contents of
the view. Still we are going to want our “people/index” page to show a list of people and the controller is where we
fetch models and lay the foundation for the view. We want to have an array of all of the people models which we can send
to the view by referencing it with an instance variable. <ed>can probably end here. You're getting a little *too* conversational and it's starting to feel awkward.</ed> Yep, that’s just how it is.</p>
<p>We’ll write the test first and check the <ic>assigns Hash</ic> to make sure our controller method set up the data
correctly, but first we need some fake data to test. There are a lot of fancy gems to help us create fake data for
tests, but we’ll start by simply creating some sample data with an ActiveRecord method we already know and love: <ed>do you think there's a need to even mention the gems or other options at this point?</ed>
<ic>Person.create!</ic>. We like to use <ic>!</ic> methods in our tests because if for some unexpected reason the
creation of the object were to fail, the method would raise an exception and any uncaught exception will cause our test
to fail.</p>
<p>At the beginning of our <class>PeopleController</class> spec, we’ll add this:</p>
<code file="code/class_app/1a_controller/spec/controllers/people_controller_spec.rb" part="create_people"/>
<p>At the beginning of each test we’ll create records for three of our favorite Nobel laureates to our test database.
This is why rspec tests are called <emph>examples</emph>.  We’re testing just one example case at a time. For this one,
we’ll write our example like this:</p>
<code file="code/class_app/1a_controller/spec/controllers/people_controller_spec.rb" part="setup"/>
<p>We first <ic>get</ic> the index page, then we test the <ic>assigns Hash</ic>, checking the value at <ic>:people</ic>
to see if it contains an Array of the three specific records we added to the database. We’re just making up the fact that we expect our controller method to set the instance variable <ic>@people</ic>.  It’s
a good design though — we’re following the Rails conventions on naming since we want to display a whole list of Person
objects, we name our variable with the plural noun, people.</p>
<p>Now let’s run the spec and see how it fails</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb 
.F

Failures:

  1) PeopleController GET index sets up the whole list of people
     Failure/Error: assigns[:people].should == [@emmy, @marie, @lise]
       expected: [#<Person id: 1, first_name: "Emmy", last_name: "Noether", 
       created_at: "2011-02-27 22:39:59", updated_at: "2011-02-27 22:39:59">, 
       #<Person id: 2, first_name: "Marie", last_name: "Curie", created_at: 
       "2011-02-27 22:39:59", updated_at: "2011-02-27 22:39:59">, #<Person 
       id: 3, first_name: "Lise", last_name: "Meitner", created_at: 
       "2011-02-27 22:39:59", updated_at: "2011-02-27 22:39:59">]
            got: nil (using ==)
     # ./spec/controllers/people_controller_spec.rb:21:in `block (3 levels) 
     in <top (required)>'

Finished in 0.22362 seconds
2 examples, 1 failure
</code>
<p>We can see that the new example fails because <ic>assigns[:people]</ic> has a value of nil, which is exactly how we
would expect it to fail since we haven’t written any code to give it a value.</p>
<p>To make the example pass, we need to modify our controller to have an index method that sets the value of its
<ic>@people</ic> instance variable to all of the people records:</p>
<code file="code/class_app/1b_controller/app/controllers/people_controller.rb"/>
<p>Behind the scenes, the Rails Controller superclass will take the contents of the <ic>@people</ic> instance variable
and stuff it into <ic>assigns[:people]</ic>. Just like that! Now we can watch the whole spec pass:</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
..

Finished in 0.18329 seconds
2 examples, 0 failures
</code>
<p>Are done yet?<ed>missing word?</ed> Nope. Time to reflect upon our code. Now it is hard to imagine something simpler than our 5 line
<class>PeopleController</class> class, but that’s not everything we’ve done. We also need to look at our specs.
Now is a good time to refactor tests as well as production code. There’s just one change we might make: </p>
<code file="code/class_app/1b_controller/spec/controllers/people_controller_spec.rb"/>
<p>We’ve moved the repeated code <ic>get :index</ic> into a <ic>before</ic> block. This reads a little clearer, even
though arguably we’ve replaced two lines of code with three – they are shorter lines and they don’t repeat themselves.
The code is fresh, airy and light.</p>
</sect2>
<sect2>
<title>Let’s Make a Person!</title>
<p>Controller actions aren’t just for displaying data in views, we can also use them to create objects. Following the
REST convention, HTTP POST requests are used for object creation. Following Rails convention, we POST to <ic>/people</ic> to create a
<class>Person</class> object.  Let’s write the test to show how a RESTful
controller expects to be called to create a new <class>Person</class> object. In a web application, an HTTP POST
typically <emph>redirects</emph> to another URL, which means that the web application will return a 302 status code and
the browser is responsible for making an HTTP GET request to the URL given in the Location field of the HTTP Header.  In
a RESTful web application, when an object is created, the address of that object is returned.  In Rails, we call the
page that displays the object the <firstuse>show</firstuse> page and the URL is something like
<ic>/people/1</ic>.</p>
<p>Let’s start by making our HTTP POST to <ic>/people</ic> do a redirect to an action that we’ve already defined, instead of the default
render</p>
<code file="code/class_app/1c_controller/spec/controllers/people_controller_spec.rb" part="post_create"/>
<p>
The parameters to a create action are conventionally given as a nested hash. There are Rails helpers to create forms
that generate POSTs just this way. <ed>I find it interesting that you are jumping into taking in parameters through testing rather than exploration through the view layer. I actually think this is great but it also validates my earlier opinion that this entire chapter should be test-driven.</ed> For now our focus is on the controller.  Let’s see how our example fails:</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
..F

Failures:

  1) PeopleController POST create redirects
     Failure/Error: post :create, :person => {:first_name => "Barbara", 
                                              :last_name => "Liskov"}
     ActionController::RoutingError:
       No route matches {:person=>{:first_name=>"Barbara", :last_name=>"Liskov"}, 
       :controller=>"people", :action=>"create"}
     # ./spec/controllers/people_controller_spec.rb:27:in `block (3 levels) 
     in <top (required)>'

Finished in 0.21168 seconds
3 examples, 1 failure
</code>
<p>Hmmm… we’re missing a route.  We’ve got one that connects to <ic>/people</ic> to the <ic>index</ic> action, but we
need that to only happen for a GET request and we need the POST to go somewhere else. Well, as it turns out, the
<method>match</method> method will match any kind of
request that comes in for that URL which can be convenient for implementing certain kinds of APIs, but it’s not a good
fit for what we want to do here.</p>
<p>Let’s change our routes so the two HTTP actions map to two different controller actions:</p>
<code file="code/class_app/1d_controller/config/routes.rb"/>
<p>Now let’s check out our routes:</p>
<code language="session">
$ rake routes
people GET  /people(.:format) {:action=>"index", :controller=>"people"}
       POST /people(.:format) {:action=>"create", :controller=>"people"}
</code>
<p>If we run our spec again, we see…</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
..F

Failures:

  1) PeopleController POST create redirects
     Failure/Error: post :create, :person => {:first_name => "Barbara", 
                                              :last_name => "Liskov"}
     AbstractController::ActionNotFound:
       The action 'create' could not be found for PeopleController
     # ./spec/controllers/people_controller_spec.rb:27:in `block (3 levels) 
     in <top (required)>'

Finished in 0.22273 seconds
3 examples, 1 failure
</code>
<p>Now our example is failing since we don’t yet have a <method>create</method> action in our
<class>PeopleController</class>.  We’ll start by fixing just this error:</p>
<code file="code/class_app/1d_controller/app/controllers/people_controller.rb" />
<p>Then let’s run the spec again.  We still expect it to fail, but we want to make sure it fails the way we expect:</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
..F

Failures:

  1) PeopleController POST create redirects
     Failure/Error: post :create, :person => {:first_name => "Barbara", 
                                              :last_name => "Liskov"}
     ActionView::MissingTemplate:
       Missing template people/create with {:handlers=>[:erb, :rjs, :builder, 
       :rhtml, :rxml], :formats=>[:html], :locale=>[:en, :en]} in view paths 
       "#<RSpec::Rails ::ViewRendering::PathSetDelegatorResolver:0x0000010111ae20>"
     # ./spec/controllers/people_controller_spec.rb:27:in `block (3 levels) 
     in <top (required)>'
</code>
<p>Well, we’re not even getting to our check for redirect before the <ic>post</ic> to the <ic>create</ic> action fails.
Our empty create method is doing a render by default and then finding that it has no template – to fix that, let’s add
in the redirect: <ed>is this the first time we've seen redirect in a controller? Or is there a place you've explained this already?</ed></p>
<code file="code/class_app/1e_controller/app/controllers/people_controller.rb"/>
<p>Now we expect our example to pass:</p>
<code language="session">
$rspec spec/controllers/people_controller_spec.rb
...

Finished in 0.13336 seconds
3 examples, 0 failures
</code>
<p>and it does pass.  Good stuff, but we’re not done yet.<ed>this phrase shows up a lot.</ed> Our create action successfully redirects, but it doesn’t yet
create a record in the database.  Let’s add another example for that:</p>
<code file="code/class_app/1e_controller/spec/controllers/people_controller_spec.rb" part="post_create"/>
<p>and watch it fail:</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
...F

Failures:

  1) PeopleController POST create creates a person record
     Failure/Error: Person.where(:first_name => "Barbara", 
                                  :last_name => "Liskov").should_not be_empty
       expected empty? to return false, got true
     # ./spec/controllers/people_controller_spec.rb:35:in `block (3 levels) 
     in <top (required)>'

Finished in 0.46923 seconds
4 examples, 1 failure
</code>
<p>We need to actually create the <class>Person</class> object from the given attributes from the nested Hash
that we called with the <ic>post</ic> action:</p>
<code file="code/class_app/1f_controller/app/controllers/people_controller.rb" />
<p>When we run the spec again, it passes:</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
....

Finished in 0.22511 seconds
4 examples, 0 failures
</code>
<p>Are we done yet? <ed>I bet we're not!</ed> With a passing spec, it is once again time for reflection.  Our code is nice and concise. Our tests
are readable, but we’re not testing all of the cases we want the code to handle. In <ref linkend="ch.activerecord"/>
we added validations, so we know that we could provide an empty first or last name and the record will fail to save, but
what will happen with our code? Let’s write an example for that and find out.</p>
<code file="code/class_app/1g_controller/spec/controllers/people_controller_spec.rb" part="post_create" />
<p>We put the first set of examples into their own context for “valid data” and then put our new examples into a context
for “invalid data.” Now when we run the specs:</p>
<code language="session">
rspec spec/controllers/people_controller_spec.rb
.....F

Failures:

  1) PeopleController with invalid data should render new template
     Failure/Error: response.should render_template(:new)
       expecting <"new"> but rendering with <"">.
       Expected block to return true value.
     # ./spec/controllers/people_controller_spec.rb:49:in `block (3 levels) 
     in <top (required)>'

Finished in 0.2994 seconds
6 examples, 1 failure
</code>  
<p>Our invalid person object is not saved, because of the model validation, but it is still redirecting to the people
index page instead of re-rendering the “new” form.  To fix that, we can use <ic>Person.new</ic> and the
<method>save</method> method so that we can check if the save was successful or not:</p>
<code file="code/class_app/1g_controller/app/controllers/people_controller.rb" part="create" />
<p>Now when we run the spec:</p>
<code language="session">
$ rspec spec/controllers/people_controller_spec.rb
....FF

Failures:

  1) PeopleController with invalid data does not create a person
     Failure/Error: post :create, :person => {:first_name => "Barbara"}
     ActionView::MissingTemplate:
       Missing template people/new with {:handlers=>[:erb, :rjs, :builder, 
       :rhtml, :rxml], :formats=>[:html], :locale=>[:en, :en]} in view paths 
       "#<RSpec::Rails::ViewRendering::PathSetDelegatorResolver:0x000001013011a8>"
     # ./app/controllers/people_controller.rb:11:in `create'
     # ./spec/controllers/people_controller_spec.rb:43:in `block (3 levels) 
     in <top (required)>'

  2) PeopleController with invalid data should render new template
     Failure/Error: post :create, :person => {:first_name => "Barbara"}
     ActionView::MissingTemplate:
       Missing template people/new with {:handlers=>[:erb, :rjs, :builder, 
       :rhtml, :rxml], :formats=>[:html], :locale=>[:en, :en]} in view paths 
       "#<RSpec::Rails::ViewRendering::PathSetDelegatorResolver:0x000001011faf98>"
     # ./app/controllers/people_controller.rb:11:in `create'
     # ./spec/controllers/people_controller_spec.rb:43:in `block (3 levels) 
     in <top (required)>'

Finished in 0.31349 seconds
6 examples, 2 failures
</code>
<p>We can see that both “invalid data” examples fail because we’re missing the new template. Let’s do the simplest thing
that could possibly work: <ed>you used this phrase last time - how about just explain what you're doing?</ed></p>
<code language="session">
$ touch app/views/people/new.html.erb
$ rspec spec/controllers/people_controller_spec.rb
......

Finished in 0.31042 seconds
6 examples, 0 failures
</code>
<p>Now we understand the basics of controllers, how they act as traffic directors for the web interface. Each controller
action either renders a view or re-directs. If a view is rendered, information may be passed to the view by assigning
instance variables. For very simple controller actions, we’ll often rely on integration tests rather than testing
controller actions in isolation. However, in understanding how to test controllers, we understand exactly how they work
and can make good decisions about where to apply testing in practice.</p>
<p>We also learned about routes and how to include parameters in a URL and specify which controller and action
should be called. We know how to <ic>match</ic> any kind of HTTP request or <ic>get</ic>, <ic>post</ic>,
<ic>put</ic> or
<ic>delete</ic> specifically.</p>

<p><ed>but we didn't talk about deletes, or puts at all in this chapter.</ed></p>

<p>In our development we work hard to keep our controller methods to be small and clearly written. Controllers should do
as little as possible, so that all they are doing is directing traffic: fetching a model, then rendering a view or
redirecting. When our controller actions are small, we can see the whole implementation of a controller on a page or two
which helps us follow the interaction across multiple web requests in our heads as we read the code. It make debugging
easier and makes it easier to work together on a team and modify each other’s code.<ed>good conclusion, but you need to transition us to the next chapter.</ed></p>
</sect2>
</sect1>


</chapter>
