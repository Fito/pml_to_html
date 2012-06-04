<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.activerecord-rspec">
<title>Test Driving Model Development</title>
<p>With a basic understanding of ActiveRecord and validations, let’s use a test-driven approach to
creating model behavior.  In test-driven development, we write the test first, detailing our requirements by example
with an executable specification before we write the code that implements the feature.  We’ll use RSpec, which we
learned about in <ref linkend="ch.rspec-intro"/> for test-driving Ruby code.  RSpec works well for testing Rails as well as Ruby. </p>
<p>When we generated our <class>Person</class> scaffold, the <ic>rspec-rails</ic> gem created a spec for each class that
was generated. In <ref linkend="sec.running-tests"/> we used <commandname>rake spec</commandname> for the first time to
run the generate test files. We deleted the failing and pending specs, so we could learn about testing from a good
starting point. If we run <commandname>rake spec</commandname> again, everything should pass:</p>
<code language="session">
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
<p>We’ll start by writing fresh specs to learn about test first development. Later we’ll review what RSpec generated, so
we can understand how to test-drive changes to code once we have a good foundation for the RSpec syntax and the test
first workflow.</p>
<sect1>
<title>Writing our First Model Spec</title>
<p>Let’s create a blank model spec using the generator. This will also  create a <dir>spec/models</dir>
directory if we didn’t have one already. Placing our tests in the same file hierarchy as our application files saves effort since
<commandname>rspec-rails</commandname> will automatically set up the correct load paths and make it so we don’t have to explicitly require the model source file.  </p>

<code language="session">
  $ rails generate rspec:model course
      create  spec/models/course_spec.rb  
</code>
<p>Just like when we were using RSpec with Ruby, All spec files end with “_spec.rb” and by convention begin with the lower-case name of the class that is being tested with
words separated by underscores.  So the spec for the <class>Course</class> class, is in the file <filename>course_spec.rb</filename></p>
<p>RSpec generates a file that looks like this:</p>
<code file="code/class_app_new/01a_active_record/spec/models/course_spec.rb"/> 
<p>On line <cref linkend="code.spec_helper"/>, the spec requires <filename>spec_helper</filename> which was created with
the <commandname>rspec:install</commandname> generator and provides Rails-specific configuration for RSpec and our Rails
testing. We can see, on line <cref linkend="code.course_describe"/>, that this spec will test our
<class>Course</class> class, using the same syntax we are familiar with from testing our
<class>Person</class> class in Ruby.</p>
<p>RSpec doesn’t generate actual test code for our model – it doesn’t presume
to know what we want our model to do. Instead it provides a <firstuse>pending</firstuse> note, 
which will remind us that we need to write examples for this spec when we run our test suite. </p>
<p>Let’s write our first example and see how it works. We want our <class>Course</class> to have a title and a description, so we’ll start
by writing an example that creates the model exactly as we expect it to work in its most normal case:</p>
<code file="code/class_app_new/01b_active_record/spec/models/course_spec.rb"/> 
<p>By calling <method>create!</method>, we know that ActiveRecord will raise an exception if it fails to create the
record in the database. As in all test frameworks, RSpec will report a failure if an exception is
raised that is not caught, so we know that if create doesn’t work our test will fail.</p>
<p>We’ve only got one spec, but let’s just use the <commandname>rake spec</commandname> command that runs them all:</p>
<sidebar>
<title>RSpec rake tasks</title>
<p>The rspec-rails gem provides a number of rake tasks.  They are all grouped together in the “spec” namespaces, so we
can easily list them:</p>
<code language="session">
$ rake -T spec
(in /Users/sarah/code/class_app_source)
rake spec              # Run all specs in spec directory (excluding plugin specs)
rake spec:controllers  # Run the code examples in spec/controllers
rake spec:helpers      # Run the code examples in spec/helpers
rake spec:lib          # Run the code examples in spec/lib
rake spec:mailers      # Run the code examples in spec/mailers
rake spec:models       # Run the code examples in spec/models
rake spec:rcov         # Run all specs with rcov
rake spec:requests     # Run the code examples in spec/requests
rake spec:routing      # Run the code examples in spec/routing
rake spec:views        # Run the code examples in spec/views
</code>
</sidebar>

<code language="session">
$ rake spec
(in /Users/sarah/code/class_app_source)
/Users/sarah/.rvm/rubies/ruby-1.9.2-p0/bin/ruby -S bundle exec rspec 
./spec/models/course_spec.rb
/Users/sarah/.rvm/gems/ruby-1.9.2-p0@book/gems/rspec-core-2.5.1/lib
/rspec/core/backward_compatibility.rb:20:in `const_missing': uninitialized 
constant Course (NameError)
	from /Users/sarah/src/tfr/svn/Book/code/class_app_new_source/spec/models
/course_spec.rb:3:in `<top (required)>'
	from /Users/sarah/.rvm/gems/ruby-1.9.2-p0@book/gems/rspec-core-2.5.1/lib
/rspec/core/configuration.rb:386:in `load'
	from /Users/sarah/.rvm/gems/ruby-1.9.2-p0@book/gems/rspec-core-2.5.1/lib
/rspec/core/configuration.rb:386:in `block in load_spec_files'
…long stack trace here…
rake aborted!
ruby -S bundle exec rspec ./spec/models/course_spec.rb failed

(See full trace by running task with --trace)

</code>
<p>Amidst this crazy stack trace, we can see <ic> uninitialized constant Course (NameError)</ic>.  We saw this same kind
of error when we were testing our <class>Person</class> class in <ref linkend="ch.rspec-intro"/>. We know from our
explorations of Ruby that classes are constants, so this error means we’re missing a
<class>Course</class> class. This is exactly what we expect since we haven’t written it yet!</p>
<p>We could just write the class from scratch in a new file, but we want to follow Rails conventions for creating not
only our model class, but also its corresponding database table. The easiest way to do that is with a generator. When we
created our <class>Person</class> model, we used <commandname>generate scaffold</commandname>. Scaffold is a great learning and
prototyping tool, but now that we understand the MVC pattern at a high-level and have a little experience with
<class>ActiveRecord</class>, we’ll follow a more typical workflow of building the model, controller and views step by
step. We’ll create our model with the model generator. By default, the rspec-rails gem will also create a model spec, but since we
are test-driving this code, we need to be sure not to overwrite the spec we just wrote when we generate the model:</p>
<code language="session">
$ rails generate model course title:string description:string
      invoke  active_record
      create    db/migrate/20110416135407_create_courses.rb
      create    app/models/course.rb
      invoke    rspec
    conflict      spec/models/course_spec.rb
    Overwrite …/spec/models/course_spec.rb? (enter "h" for help) [Ynaqdh] n
        skip      spec/models/course_spec.rb
</code>
<p>Now that we’ve created our model class, we believe we’ve resolved our <ic>Uninitialized Constant</ic> error. So let’s
run our spec again:</p>
<code language="session">
sarah:class_app_new_source(01b_active_record)$ rake spec
(in /Users/sarah/src/tfr/svn/Book/code/class_app_new_source)
You have 1 pending migrations:
  20110416135407 CreateCourses
Run "rake db:migrate" to update your database then try again.
</code>
<p>Cool. The <commandname>rake spec</commandname> command reminds us that we need to run our migration before running
our tests. In fact, it does a whole lot more than that.</p>
<sect2>
<title>Understanding <commandname>rake spec</commandname></title>
<p>There are a whole bunch of best practices rolled in this one
command. To see exactly what is going on, we can run <commandname>rake spec</commandname> with the <ic>--trace</ic>
option:</p>
<code language="session">
$ rake spec --trace
(in /Users/sarah/src/tfr/svn/Book/code/class_app_new_source)
** Invoke spec (first_time)
** Invoke db:test:prepare (first_time)
** Invoke db:abort_if_pending_migrations (first_time)
** Invoke environment (first_time)
** Execute environment
** Execute db:abort_if_pending_migrations
** Execute db:test:prepare
** Invoke db:test:load (first_time)
** Invoke db:test:purge (first_time)
** Invoke environment 
** Execute db:test:purge
** Execute db:test:load
** Invoke db:schema:load (first_time)
** Invoke environment 
** Execute db:schema:load
** Execute spec
</code>
<p>When it says <ic>invoke</ic> it is calling a particular rake task, but then it will call its dependencies. To really
see what is happening in what order, check out the <ic>execute</ic> commands. The commands
<commandname>db:test:prepare</commandname> and <commandname>db:test:load</commandname> don’t do
much themselves, aside from setting up the environment and executing another task or two.  We can see from the output that it is
actually executing the following steps:</p>
<ol>
<li><p>
Don’t run the specs if there are pending migrations in the development database:
<commandname>db:abort_if_pending_migrations</commandname>
</p></li>
<li><p>
Drop the test database: <commandname>db:test:purge</commandname>
</p></li>
<li><p>
Load the schema into the test database: <commandname>db:schema:load</commandname> in environment “test”
</p></li>
</ol>
<p>These steps make sure that we are always testing in a clean environment, so we know exactly what we’re testing when
we run our specs.</p>
</sect2>
<p>Now that we understand what’s going on. Let’s call <ic>rake db:migrate</ic> to set up our development database and
then call <ic>rake spec</ic> again:</p>
<code language="session">
$ rake db:migrate
(in …/code/class_app_new_source)
==  CreateCourses: migrating ==================================================
-- create_table(:courses)
   -> 0.0010s
==  CreateCourses: migrated (0.0011s) =========================================

$ rake spec
(in /Users/sarah/src/tfr/svn/Book/code/class_app_new_source)
/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -S bundle…
...........................

Finished in 0.62362 seconds
27 examples, 0 failures
</code>
<p>Great! We’ve added one more spec to our test suite and they all pass. We’ve confirmed that we generated a model that
matches our expectations. Let’s can step into <ic>rails console</ic> for a quick
look interactively and double-check:</p>

<code language="session">
$ rails c
Loading development environment (Rails 3.0.3)
> c = Course.create!(:title => "Creative Writing",
>     :description => "Learn to write fiction!")
 => #<Course id: 1, title: "Creative Writing", description: "Learn to write..."
</code>

<p>Sometimes, when doing something particularly tricky or using an unfamiliar Ruby class or method, we still test
interactively to get a good feel for how the underlying code works; then, once we have an rspec example for that test
case, we know that we never have to check that behavior again. Also if we forget how some section of my code is supposed to
behave, we can just look at the spec.</p>
</sect1>
<sect1>
<title>Test Driving Validations</title>
<p>We want to make sure our <class>Course</class> model always has a title, just like we validated that our
<class>Person</class> model always had its <ic>given_name</ic> filled in. To write a test for that, we need to think
about what it would be like if our code was already working the way we want it to and then we testing for the correct
behavior. The trick is to do this <emph>before</emph> we’ve written any code to implement that behavior.</p>
<p>Let’s apply what we learned in
<ref linkend="sec.validations"/> when we experimented with our <class>Person</class> model in the console. We can set up
our model with invalid attributes, then call <ic>valid?</ic> and verify that it returns false. When we’re testing we are
always thinking about what effects our code should have and how would we know if it worked or didn’t work. We’re
defining our model API in a very precise way.</p>
<p>The way we would write these expectations in RSpec is:</p>
<code file="code/class_app_new/01c_active_record/spec/models/course_spec.rb" part="title_validation"/> 
<p>Any method that ends in
a “?” like <commandname>valid?</commandname> can be handled specially in RSpec. These methods, called <emph>predicates</emph>, can be used automatically with RSpec in a way that sounds a bit like English.  Above we see that <method>valid?</method> can be tested with <ic>p.should be_valid</ic>.</p>
<p>RSpec provides this for all predicates. If the matcher begins with &lquot;be_&rquot;, RSpec removes the &lquot;be_&rquot;, appends a &lquot;?&rquot;, and
sends the resulting message to the given object.  In fact, RSpec will do the same for <ic>be_a_</ic> or <ic>be_an_</ic> to support some
predicates where the example reads better with an article, such as <ic>should be_an_instance_of</ic> to call
<method>instance_of?</method> or <ic>should be_a_kind_of</ic> which will call <method>kind_of?</method>.</p>
<p>Let’s watch how this example fails by calling <ic>rake spec</ic> again after editing the
<filename>spec/models/course_spec.rb</filename> to include our new example:</p>
<code language="session">
................F...........

Failures:

  1) Course should not be valid if it has no title
     Failure/Error: c.should_not be_valid
       expected valid? to return false, got true
     # ./spec/models/course_spec.rb:11:in `block (2 levels) in <top (required)>'

Finished in 0.41685 seconds
28 examples, 1 failure
</code>
<p>RSpec tells us that we’re checking on the results of <ic>valid?</ic> when we call the <ic>be_valid</ic> Rspec method.
RSpec has a lot of helpful <firstuse>matchers</firstuse> which are special methods that provide more specific
output for verifying specific behavior.</p>
<p>We could have written our example like <ic>c.valid?.should == false</ic>, however that is a little weird to read with the
question mark followed by a dot, and, more importantly, by using more specific RSpec syntax we get a more specific error
when our test fails. If we call <ic>.should</ic> on the result of <ic>c.valid?</ic> then all RSpec knows is that we
expected <keyword>true</keyword> to be <keyword>false</keyword>. When we use more specific matchers, RSpec can tell us better information about the failure.</p>
<sect2>
<title>Adding Tests to Our Existing Person Model</title>
<p>Now that we understand how to use RSpec, we want to go back and add tests for our <class>Person</class> model. It’s
okay to write exploratory code without test-driving it – sometimes we need to do that to really understand what’s
possible; however, to keep our code maintainable and make sure the code matches our requirements we want to put some
specs in place.</p>
<p>To get started, we can generate a spec file:</p>
<code language="session">
$ rails g rspec:model person
      create  spec/models/person_spec.rb
</code>
<p>Edit the file <filename>spec/models/person_spec.rb</filename> so that it has the following contents:  </p>
<code file="code/class_app_new/01d_active_record/spec/models/person_spec.rb"/> 
<p>
We can focus on this one new spec by passing the filename as an option to <ic>rake spec</ic>:</p>

<code language="session">
$ rake spec SPEC="spec/models/person_spec.rb"
..

Finished in 0.04756 seconds
2 examples, 0 failures
</code>

<p>Even though the spec passes, it doesn’t give us confidence since we never saw it fail. In the strictest application
of TDD, we should delete our whole model class and migration, but for now, let’s focus on the additional model code
we’re learning to write. Let’s find our Person model
comment out the validator and see at least one example fail. We can find the source code for our model in
<filename>app/models/person.rb</filename> and comment out the validator:</p>
<code file="code/class_app_new/01e_active_record/app/models/person.rb"/> 
<p>Then when we run the spec, we can see that we get the error we expected:</p>
<code language="session">
$ rake spec SPEC="spec/models/person_spec.rb"
.F

Failures:

  1) Person should not save a record without a name
     Failure/Error: p.should_not be_valid
       expected valid? to return false, got true
     # ./spec/models/person_spec.rb:13:in `block (2 levels) in <top (required)>'

Finished in 0.04394 seconds
2 examples, 1 failure
</code>
<p>Now we can uncomment our validation in the Person model class to make the spec pass. The Rails reference documentation for
validations<footnote><p>http://ar.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html</p></footnote> is
quite good and worth reading to be familiar with the built-in validators.</p>
<p>Rails has a concise, declarative syntax that appears like configuration for validators, but with our knowledge of Ruby
we can see that these are just class method calls. Some people call this the Rails DSL, a <emph>Domain Specific
Language</emph> written in Ruby. Of course, that's just a fancy name for a library of classes with methods that are so
well-named and elegantly structured that they feel like a new language. </p>
</sect2>
</sect1>
<sect1>
<title>Creating Custom Model Behavior</title>
<p> We can add
any behavior that we want to our model class by adding class or instance methods with custom behavior.  Remember
that when we are developing a Rails application, we are writing Ruby code. All of the capabilities of the Ruby language
are available to us within our Rails application. Rails gives us a lot of built-in functionality common to web
applications, but we can use it in powerful and flexible ways because of Ruby.    Your model is just a Ruby class which may be extended in standard ways to have its own methods. It is considered a best practice to add logic to the model when possible, so that you can keep your views and controllers small.  </p><p>
Suppose we commonly refer to people with their full name
  (concatenating given and surname). We want this available elsewhere in the code, we can add a
  <method>full_name</method> method to our model just like we did with our plain old Ruby class when we were learning
  about Ruby. This may seem like a very simple example, but simple, useful methods added to our models can be very
  powerful in keeping our view code clean. Later if we decided to add a middle name, we could just change this one
  method in our model, rather than everywhere in our code. Let’s add this example to the spec for the <ic>Person</ic>
  model by editing spec/models/person_spec.rb:  </p>
<code file="code/class_app_new/01f_active_record/spec/models/person_spec.rb" part="fullname"/>
<p>Then run <ic>rake spec</ic> to see the following error.</p>
<code language="session">
1)
NoMethodError in 'Person should construct a full name'
undefined method `full_name' for #<Person:0x1036ff5f0>
.../lib/active_record/attribute_methods.rb:264:in `method_missing'
./spec/models/person_spec.rb:12:
</code>
<p>You can see that Ruby reports a <ic>NoMethodError</ic>, since we are sending a full_name message to
the person object “p” where there is no method definition (or corresponding table column for ActiveRecord to dynamically evaluate).  To make this example pass, we can simply define a method:</p>
<code file="code/class_app_new/01f_active_record/app/models/person.rb" part="method"/>


<p>
We’ve written specs for validations and a custom model method, only verifying the custom behavior we’ve added to our
model. We can rely on the tests of ActiveRecord in
Rails itself to ensure that the built-in functionality  works.  In our
spec, we focus on what is special in our own app. As much as we can, we want to put behavior in the model, since it is
easiest to isolate the model’s behavior and test it effectively, rather than testing that behavior as it ripple out to
various parts of the application. Understanding
the basics of models, the <emph>M</emph> in the MVC pattern, gives us a firm foundation as we continue to explore Rails.</p>
</sect1>
</chapter>
