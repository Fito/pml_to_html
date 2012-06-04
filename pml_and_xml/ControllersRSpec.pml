<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.controllers-rspec">
<title>Understanding Controllers through Testing</title>
<p>In the most common controller tests, we use the <ic>assigns Hash</ic> to verify that a
controller method has correctly set up data for the view and we check that the correct template is rendered. Let’s write a controller for the <class>Person</class>
model in our class app using a test first
approach. <ed>why? What are we really building? A user interface to manage people? Or something different?</ed></p>

<sect1>
<title>Writing a Controller Spec</title>
<p>We can use an RSpec generator to create our people controller spec file. Remember the
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
