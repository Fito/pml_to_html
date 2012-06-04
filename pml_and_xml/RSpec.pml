<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.rspec-intro">
  <title>Test First Ruby</title>
<p>We've explored enough Ruby that we are ready to learn RSpec, our key to unlocking the power of testing our code. Of course, there is always more Ruby to learn and we will also learn some more advanced Ruby concepts including attr_accessor methods, hashes, and string interpolation.</p>
<p>By the end of <ref linkend="ch.ruby-intro"/> we had a simple <class>Person</class> class that could store a name.  We’ll continue to work on the <class>Person</class> class, but now we’ll be building it test first with RSpec.  We will use RSpec <firstuse>specs</firstuse> (RSpec lingo for tests) to suss out what our API should look like, and how we want to use our code. Each spec will verify one example of how we expect our code to work. We will end up with a suite of specs that describe a well thought out and detailed technical design of our <class>Person</class> objects.</p>
<sect1>
<title>Writing an Executable Specification</title>
     
     <p>Our <class>Person</class> class already has a <method>full_name</method> method.  Now we need a  <method>given_name</method> method and a <method>surname</method> method that we will concatenate together in our <method>full_name</method> method. We will design our <class>Person</class> class so that <method>given_name</method> and <method>surname</method> will be set when we create the object.  We will  also be able to change them or access them at any time. </p>
     <sect2> 
<title>Creating an RSpec File</title>
<p>By convention, RSpec files are named with a suffix of _spec.rb. A single RSpec file doesn’t need to be named in any
special way, but when we have developed a lot of specs in our Rails applications, we’ll be able to run a whole directory
full of them if we follow this naming style. In Rails, RSpec will use this suffix to know which files to run. Besides it’s just a good idea to be able to look at a
filename and know what’s in it.  So let’s make a spec to test the code we wrote in
<filename>person.rb</filename> by creating a file named <filename>person_spec.rb</filename>.  
</p>
<p>Like Rails, RSpec is its own domain-specific language. We introduced
the idea of a DSL in <ref linkend="side.dsl"/>. The RSpec files we write are Ruby code. RSpec defines a number of methods which when used together make it feel like its own language.  The way RSpec names methods is important.  Method names such as <method>describe</method>, <method>it</method> and <method>should</method> are designed to lead us toward thinking of our application as a set of behaviors rather than as chunks of code. </p>
</sect2>
<sect2>
<title>Describing our Person Class</title> 
<p>
  RSpec's <method>describe</method> method sets the stage for specifying part of our code.  We use it to separate
  different concepts and keep our specs organized. The <method>describe</method> method accepts either a class name or a
  string as a parameter.  Whatever parameter we pass in to the describe block is shown to us when a test fails, so it
  pays off to be thoughtful about what we pass in.  We’ll start our spec, with a <commandname>describe</commandname>
  block telling RSpec that this is a specification for a <class>Person</class> class. 
</p>
     <code file="code/person_spec/00/person_spec.rb"/>
<p>Nested inside of our first describe block are two describe blocks that specify different aspects of the
<class>Person</class> class’s behavior. Even though we aren't testing anything yet, let’s run our spec to see how
<method>describe</method> works. We run specs using the rspec gem.  The rspec gem installs a command-line tool that has the same name as the gem. The <commandname>rspec</commandname> command will load our spec file and call
the gem. Here's how we run it:</p>
     <code language="session">
$ rspec person_spec.rb
/lib/rspec/core/backward_compatibility.rb:20:in `const_missing': 
  uninitialized constant Object::Person (NameError)
	from /code/person_spec/person_spec.rb:2:in `<top (required)>'
	from /rspec-core-2.5.1/lib/rspec/core/configuration.rb:386:in `load'
	from /rspec-core-2.5.1/lib/rspec/core/configuration.rb:386:in `block in 
  load_spec_files'
	from /rspec-core-2.5.1/lib/rspec/core/configuration.rb:386:in `map'
	from /rspec-core-2.5.1/lib/rspec/core/configuration.rb:386:in 
  `load_spec_files'
	from /rspec-core-2.5.1/lib/rspec/core/command_line.rb:18:in `run'
	from /rspec-core-2.5.1/lib/rspec/core/runner.rb:55:in `run_in_process'
	from /rspec-core-2.5.1/lib/rspec/core/runner.rb:46:in `run'
	from /rspec-core-2.5.1/lib/rspec/core/runner.rb:10:in `block in autorun'     
     </code>
     <p>What’s all this? Did we do something wrong? Nope. In test-driven development, we always start with a failing test since we haven't written any code yet. </p>
     <p>This first failure is complaining about a <ic>NameError</ic> for an “uninitialized constant”. We've seen a <ic>NameError</ic> before, right? During our <commandname>irb</commandname> experimentation in the last chapter we got a <ic>NameError</ic> because we hadn't yet defined our <class>Person</class> class (remember classes in Ruby are constants).  Our describe block is describing our <class>Person</class> class which causes RSpec to go look for that class. </p>
     <p> Whenever we pass a class name to a describe block, the class must exist in order for our tests to pass. When we pass a string into a describe block as we did with <ic>describe "name"</ic>, RSpec doesn't care what characters we put in the string. On the other hand, <emph>we do care</emph> about the contents of the string since it serves as documentation for our code and it will be the output we see when we run our spec.

</p>
     <p> What can we do to move past the <ic>NameError</ic>?  We already wrote the code for the class, so the only thing we need to do is tell RSpec where to find it.  We've already learned one way to include the contents of a file.  Remember how we loaded our person file into irb?  We typed in <ic>load 'person.rb'</ic>.  When we call <ic>load</ic>, Ruby will always load the file, no matter how many times we call it. This behavior is what we want in irb when we are experimenting and loading the file again and again. On the other hand, when we have finished with experimenting, it would be better if our file was included just once.  We can achieve this behavior by calling <ic>require</ic> instead of <ic>load</ic>.  Here is how we use <ic>require</ic> to bring our <class>Person</class> class into our spec:
</p>
     <code file="code/person_spec/01/person_spec.rb" part="require"/>
     <p>Ruby expects that the file extension is “.rb” so we can leave it off. As usual,
     Ruby lets us type less and keep our code uncluttered with information that is almost always the same.
     When we write <ic>require './person'</ic>, we are
     telling Ruby that we want to look for a file called <filename>person.rb</filename> in the current directory.</p>
     <p>Now we can run the spec without an error:</p>
<code language="session">
$ rspec person_spec.rb
No examples were matched. Perhaps {:if=>#<Proc:0x00000100bb7e10@/…
/gems/rspec-core-2.5.1/lib/rspec/core/configuration.rb:50 (lambda)>, 
:unless=>#<Proc:0x00000100bb7de8@/…/gems/rspec-core-2.5.1/lib/rspec/
core/configuration.rb:51 (lambda)>} is excluding everything?

Finished in 0.00003 seconds
0 examples, 0 failures
</code>
<p>RSpec tells us <ic>No examples were matched</ic>, which means we haven't written any tests yet.  RSpec is also trying
to be helpful by providing a solution message, but we can ignore it because it doesn’t apply to us. We haven’t written
any examples yet, so we expect that RSpec won't find any.  The next thing to do is begin writing examples of how we
expect our code to behave.</p>
     </sect2>
     <sect2>
     <title>Specifying by Example</title>
     <p>RSpec uses the word <emph>example</emph> to mean individual test case.  There is a good reason to call them examples: it reminds us that we are specifying our code by writing examples of our APIs in action.</p>
         <p>
     We'll start our RSpec example with the <method>it</method> method, which refers to the context from the enclosing
     <method>describe</method>. The <method>it</method> method must be called inside of a describe
     block, otherwise RSpec will
     raise an error. Ideally, each <method>it</method> block will verify just one aspect of our code.   
     </p>
     
     <p>Let’s write our first example for our <class>Person</class> class as we defined it in <ref linkend="ch.ruby-intro"/>: </p>
     <code file="code/person_spec/02/person_spec.rb" part="example1"/>
     <p>We are using the RSpec <method>should</method> method to assert what we expect to happen in our
       code. The syntax is designed to read a bit like English.</p>
<p>Let's take a quick tour of this code.  On line <cref linkend="code.person.new"/> we made a new <class>Person</class> object with an argument of "Hiawatha". We know that this argument will be passed into the <method>initialize</method> method and that our <ic>@name</ic> instance variable will be set to "Hiawatha".  With this knowledge, on line <cref linkend="code.p.full_name.should"/> we say that we expect the <method>full_name</method> method to return the same string that we passed to <ic>Person.new</ic>. We are calling the <method>should</method> method on a <class>String</class> object returned by <method>full_name</method>, but RSpec is designed so that when we are in a spec file we can call the <method>should</method> method on any object.</p>
     <p>This is actually a <emph>test last</emph> approach because we have already written the code for this example.
     Testing our code last is okay on occasion when we’re exploring how our code will work, but we always want to see our test fail first.
     We can ensure that our test fails before it passes by commenting out the implementation of the full_name method like this: </p>
     <code file="code/person_spec/02/person.rb" part="full_name_method_comment"/>
     <p>In Ruby, a comment starts with a <ic>#</ic> which can start anywhere on a line. </p>
<p>Before we run the spec, we think about what will
happen. Remember from <ref linkend="ch.ruby-intro"/> what a method returns when it has no contents? Here's a refresher:</p>
<code language="irb">
$ rspec person_spec.rb 
F

Failures:

  1) Person name must be set on creation
     Failure/Error: p.full_name.should == "Hiawatha" 
       expected: "Hiawatha"
            got: nil (using ==)
     # ./person_spec.rb:11:in `block (3 levels) in <top (required)>'

Finished in 0.00051 seconds
1 example, 1 failure
</code>
  <p>Our answer is that an empty method returns <ic>nil</ic>.  The spec fails as we expect; when we called <ic>p.full_name</ic>, it returned <ic>nil</ic> because we commented out
    the implementation. Let’s look closer at the rest of what RSpec tells us. See the “F”
  on the very first line of the output? RSpec outputs one “F” per failed example (and one “.” per passing example). In this case, “F” stands for failure. This
  seems like a very small indicator now, but for a whole app concise feedback is really helpful. We’ll
  have dozens and eventually hundreds of examples.  If one of our specs fails, RSpec will output more helpful feedback to help us correct the error.</p>
  <p>Now we can uncomment the code in our <method>full_name</method> method and watch it pass:</p>
<code language="session">
$ rspec person_spec.rb
.
Finished in 0.00051 seconds
1 example, 0 failures
</code>
<p>We can see that the initial feedback for a passing test is just one dot.</p>
</sect2>
</sect1>
     <sect1 id="getter_and_setter_methods">
     <title>Creating Getter and Setter Methods</title>
     <p>We’ve developed a <class>Person</class> class that is given a name when it is created.  What
     if we want to change the name after we have already instantiated a <class>person</class> object?  That is a job for a setter method.  If we simply want to get the value of the name, we can write a getter method.  We’ve already written a <method>full_name</method> getter method, but our plan for that method is to compose a full name out of a person's given name and surname. Let's make a method that can get just persons given name.</p>
<sect2>
	<title>Test Driven Getter Method</title>
	    <p>We are about to write a method test first!  Let’s start by specifying that our class will have a <method>given_name</method> getter method:</p>
	     <code file="code/person_spec/02/person_spec.rb" part="example2"/>
	    <p>This spec is very similar to our last one.  We are simply telling RSpec that we expect our <method>given_name</method> method to return the argument we pass in to <method>new</method>. </p>
	<code language="session">    
	$ rspec person_spec.rb
	.F
	  1) Person name can be accessed
	     Failure/Error: p.given_name.should == "Hiawatha"
	     NoMethodError:
	       undefined method `given_name' for #<Person:0x000001008b0730 @name="Hiawatha">
	     # ./person_spec.rb:18:in `block (3 levels) in <top (required)>'

	Finished in 0.00051 seconds
	2 examples, 1 failure
	</code>
	<p>As expected, we see <ic>NoMethodError: undefined method given_name</ic>, so we create a <method>given_name</method> method:</p>
	     <code file="code/person_spec/02/person.rb" part="name_method_only"/>
	     <p>We always want to write as little code as possible to fix the error.  We know that our spec will fail again because it is empty and will return nil rather than "Hiawatha", but we want to be sure that it is failing for the right reason.  This technique of fixing only the error at hand becomes increasingly important as code becomes more complex, so it is a good habit to get into.  Let's run the spec again:</p>
	<code language="session">    
	$ rspec person_spec.rb
	.F
	  1) Person name can be accessed
	     Failure/Error: p.given_name.should == "Hiawatha"
	       expected: "Hiawatha"
	            got: nil (using ==)
	     # ./person_spec.rb:18:in `block (3 levels) in <top (required)>'

	Finished in 0.00051 seconds
	2 examples, 1 failure
	</code>
	<p>We progressed a little bit as we are no longer getting a <ic>NoMethodError</ic> Our empty method is  returning <ic>nil</ic> instead of the <variable>@name</variable>.  Let's go ahead and make it pass in the same way we did for <method>full_name</method>.</p>
	<code file="code/person_spec/02/person.rb" part="name_getter"/>
	<p>Let's run our test again:</p>
	<code language="session">    
		$ rspec person_spec.rb 
		..

		Finished in 0.0005 seconds
		2 examples, 0 failures
	</code>
	<p>Zero failures!  Congratulations, we just completed our first test driven method.</p>
</sect2>

<sect2>
<title>Red, Green, Refactor</title>
<p> Now that we have some passing tests, let's work on making them readable, concise and maintainable.   Refactoring is the word we use when we rewrite our code with readability and maintainability in mind, without changing what it actually does.  It is a kind thing to do for ourselves and our coworkers.  Refactoring is a key term in test-driven development (TDD): we often hear about the “red, green, refactor” workflow. In the first step, “red” describes our failing test. We write the test first and watch it fail. The second step, “green,” represents the stage when we’ve written our code and it works, so the test passes. But we don’t stop there. After the test passes, we have the opportunity to <emph>refactor</emph> the code to make it more concise and maintainable. When we refactor we are changing the code, but not the behavior of the code. </p>
<p>Let's put what we just learned into practice and refactor our spec file.</p>
</sect2>

<sect2>
	<title>Refactoring Our Spec To Use A Before Block</title>
	<p>Before we move on to writing a setter, lets clean up our spec a
little. Both of our examples create <class>Person</class> objects.  We
can remove this repetition by moving the instantiation of our objects
into RSpec's <method>before</method> method.  The <method>before</method>
method allows us to keep all the test setup code in one place.  We can
use instance variables in our specs to store our object across all of our
examples.  Let's take a look:</p>
	     <code file="code/person_spec/03/person_spec.rb" part="before"/>
	<p>The <method>before</method> block runs before each of our
<method>it</method> blocks.  RSpec is using some advanced Ruby features to
	make the <method>it</method> method run whatever code we put into the
<method>before</method> block before the example code is run.</p>
<p>Be sure to run the spec again to make sure it still works.  We are ready to write our setter method.</p>
</sect2>

<sect2>
<title>Test Driven Setter Method</title>
    <p>We’ll put our setter example inside the <ic>describe "name"</ic> so that we can use
    the same person object from the <ic>before</ic> block.</p>
     <code file="code/person_spec/03/person_spec.rb" part="set"/>
    <p>We’re setting <ic>given_name</ic>, getting its value, and then verifying that it retains the value we set. Let’s run it:</p>
<code language="session">
$ rspec person_spec.rb
..F

Failures:

  1) Person name can be set
     Failure/Error: @person.given_name = "Jean"
     NoMethodError:
       undefined method `given_name=' for #<Person:0x000001008b9d30>
     # ./person_spec.rb:18:in `block (3 levels) in <top (required)>'

Finished in 0.00067 seconds
3 examples, 1 failure
</code>
<p>The spec failure tells us that when we write <ic>p.given_name = "Jean"</ic>, Ruby expects that the object has a
<method>given_name=</method> method. We often refer to this as a <firstuse>setter</firstuse>, but its just a
special case of operators as methods in Ruby. Writing <ic>p.given_name = "Jean"</ic>, is just different syntax for
calling the <method>given_name=</method> method in the usual way: <ic>p.given_name=("Jean")</ic>. The Ruby
language parser let’s us put space around the operator, but in other respects, it is just a plain old method call.</p>


    <p>To fix our <ic>NoMethodError</ic>, we define the <ic>given_name=</ic> method:</p>
     <code file="code/person_spec/02/person.rb" part="name_setter_only"/>
    <p>We still haven’t fully implemented the method, but we want to run the spec and see the new failure:</p>
<code language="session">
$ rspec person_spec.rb
.F

Failures:

  1) Person name can be set
     Failure/Error: p.given_name = "Jean"
     ArgumentError:
       wrong number of arguments (1 for 0)
     # ./person.rb:13:in `given_name='
     # ./person_spec.rb:18:in `block (3 levels) in <top (required)>'

Finished in 0.00056 seconds
2 examples, 1 
</code>
<p>Our example now fails because of an <ic>ArgumentError</ic>. When we write <ic>p.given_name = "Jean"</ic>, the string
“Jean” is interpreted by Ruby as an argument to the <ic>given_name=</ic> method. To fix this failure, we declare an
argument:</p>
     <code file="code/person_spec/02/person.rb" part="name_setter_sig"/>
<p>and then run the spec:</p>
<code language="session">
$ rspec person_spec.rb
.F

Failures:

  1) Person name can be set
     Failure/Error: p.given_name.should == "Jean"
       expected: "Jean"
            got: "Hiawatha" (using ==)
     # ./person_spec.rb:19:in `block (3 levels) in <top (required)>'

Finished in 0.00103 seconds
2 examples, 1 failure
</code>
<p>Whew, we’re onto the next line! Now we know our method is defined with the correct name and arguments, and we’re
seeing our example fail because we’re missing internal logic.</p>		
      <p>Our setter method is working just fine except that it doesn't actually set a variable, which is the purpose of
      setter methods.  Setter methods don't set just any variable either.  They set a variable that has a scope of our
      whole object.  As we learned in <ref linkend="ch.ruby-intro"/>, variables within the scope of the object are
      called <emph>instance variables</emph> and start with an <ic>@</ic> symbol. In order for the <method>given_name=</method> method to set an instance variable to a value, it will need to use the argument as the value we give to our instance variable. It will look something like this: </p>
<code file="code/person_spec/02/person.rb" part="name_setter"/>
<p>This is where the importance of instance variables shines.  We set the instance variable in the setter method,
    then it is available throughout our entire object, including inside of our getter method.  Let's go back to irb and
    try out our getter and setter methods working together:</p>
<code language="irb">
$ irb
ruby-1.9.2-p0 > load 'person.rb'
 => true 
> p1 = Person.new("Spock")
 => #<Person:0x00000100a89ea8> 
> p1.given_name
 => "Spock" 
> p1.given_name = "Sarek"
 => "Sarek" 
> p1.given_name
 => "Sarek" 
</code>
		<p>Works like a charm! </p>
</sect2>
</sect1>

<sect1 id="attr_accessor">
		<title>Getting and Setting Instance Variables</title>
    <p> You could name a method anything and return any instance variable from it,
    but we get some benefits if we name getter and setter methods with the same name as the instance variable they allow us to access. For example, for our <method>given_name</method> getter and <method>given_name=</method> setter, we would want an instance variable named <variable>@given_name</variable>.  When we name our code with this convention and need conventional behavior, Ruby offers us the <method>attr_accessor</method> shortcut which we will make use of soon.  First we need to refactor our code to abide by this convention. Let's change the <variable>@name</variable> variable to <variable>@given_name</variable> so that it has the same name as our getter and setter methods:</p>
    <code file="code/person_spec/03/person.rb"/>
    
    
		<p>Our getter and setter methods are currently written out the long way.  Now it is time to learn the shortcut.  Ruby gives us three methods that reduce our getter and setter methods down to one line: <method>attr_reader</method>, <method>attr_writer</method> and <method>attr_accessor</method>.  If we only need the getter method, we use <method>attr_reader</method>.  If we only need the setter method, we use <method>attr_writer</method>.  If we want to create both a getter method and a setter method, we use <method>attr_accessor</method>.</p>
		
		<p>In our case, we can condense our two methods to just one line:</p>
		<code file="code/person_spec/04/person.rb" part="complete"/>
		<p><ic>attr_accessor :given_name</ic> creates both of these methods for us, all in one line:</p>
		<code file="code/person_spec/03/person.rb" part="getter_setter"/>
		
    <p>We run our spec again which verifies that the new code has the same behavior as our initial implementation:</p>
<code language="session">
$ rspec person_spec.rb 
..
Finished in 0.00055 seconds
2 examples, 0 failures
</code>
		<p>Just one more reason to love Ruby!  We condensed six lines into one, and our tests gave us comfort that nothing got broken in the process of cleaning up our code.  Not too shabby.  </p> 
	<p>Luckily, we can get used to shortcuts like this.  Ruby has many of them and Rails makes ample use of them, as well as adding many more.</p>
		
</sect1>


		<sect1>
    <title>Implementing Surname with Attribute Accessor</title>
    <p>So far our <method>full_name</method> method returns the same thing as our <method>given_name</method> getter method.  Our goal is for <method>full_name</method> to return the person's given name and surname together, assuming they have a surname.  If they don't have a surname, then <method>full_name</method> should just return the given name.  Let's test drive implementing the <method>surname</method> method. Our first test will be an example of what happens if the person doesn't have a surname:</p>
			<code file="code/person_spec/04/person_spec.rb" part="surname1"/>
<p>We make a new object on line
<cref linkend="code.person.new.jean"/> and then we tell RSpec on line <cref linkend="code.p.surname"/> that we
expect <ic>surname</ic> to be an empty string. We call this kind of example, the <emph>null test</emph>.</p>
    
    <p>Since we haven’t written any code in our class to support a <ic>surname</ic> attribute, we expect it to fail:</p>

<code language="session">
$ rspec person_spec.rb
..F

Failures:

  1) Person surname is empty if it hasn't been set
     Failure/Error: p.surname.should == ""
     NoMethodError:
       undefined method `surname' for #<Person:0x00000100869088 @name="">
     # ./person_spec.rb:20:in `block (3 levels) in <top (required)>'

Finished in 0.00079 seconds
3 examples, 1 failures
</code>

    <p>If we want to fix just this one failure, let's use the <method>attr_reader</method> short cut for just creating a getter method:</p>

<code file="code/person_spec/04/person.rb" part="attr_reader"/>

<p>We know the return value of an empty method by now (nil), but what about an instance variable that hasn't been set?  When we run this example, the return value of our new <method>surname</method> method (generated by <ic>attr_reader :surname</ic>) will be the value of <variable>@surname</variable>.  We haven't written any code yet to set <variable>@surname</variable>, so let's take this opportunity to learn what an instance variable returns before we set it.</p>
<code language="session">
$ rspec person_spec.rb
..F

Failures:

  1) Person surname is empty if it hasn't been set
     Failure/Error: p.surname.should == ""
       expected: ""
            got: nil (using ==)
     # ./person_spec.rb:20:in `block (3 levels) in <top (required)>'

Finished in 0.00078 seconds
3 examples, 1 failure
</code>
<p>Just like an empty method, instance variables evaluate to <ic>nil</ic>. We don’t get a <ic>NameError</ic> like we do
with local variables if we use them before they are set.</p>
<p>We decided when we wrote the example in our spec that the initial value of <ic>surname</ic> should be an empty string. Let's set <variable>@surname</variable> for every object that is created from our class. We can do that in the initialize method:</p>
<code file="code/person_spec/04/person.rb" part="init"/>
<p>Now let's write a spec that tests that <ic>@surname</ic> is settable:</p>
<code file="code/person_spec/04/person_spec.rb" part="surname2"/>
<p>We expect this spec to fail because we haven't written a <method>surname=</method> method yet.  Let's watch the spec fail as we expect:</p>
<code language="session">
$ rspec person_spec.rb 
...F

Failures:

  1) Person surname can be set
     Failure/Error: p.surname = "Bartik"
     NoMethodError:
       undefined method `surname=' for #<Person:0x0000010085ef48…
     # ./person_spec.rb:26:in `block (3 levels) in <top (required)>'

Finished in 0.0007 seconds
4 examples, 1 failure
</code>
<p>Now we can make our spec pass by adding <ic>:surname</ic> to be accessible:</p>
<code file="code/person_spec/04/person.rb" part="attr"/>

<p>So far we have made a <method>surname</method> getter method using <ic>attr_reader</ic>.  Then we revised our code so that <ic>attr_accessor</ic> created <method>surname</method> and <method>surname=</method>.  We haven't had a situation yet where we only needed a setter method.  If we ever want a variable to only be writable and not readable, we can use <ic>attr_writer</ic>. In our case, we want <variable>@surname</variable> to be readable and writable just like <variable>@given_name</variable>. Now our spec passes with a complete implementation of <method>surname</method> and <method>given_name</method>, but our <method>full_name</method> is still only returning <ic>@given_name</ic>, rather than <ic>@given_name + " " + @surname</ic>.  Let's fix that next.</p>
</sect1>

		<sect1 id="hash_arguments">
			<title>Using Hash Arguments to Initialize an Object</title>
			<p>We now have all the pieces we need to complete our <method>full_name</method> method.  Let's change it so it returns a string with <method>given_name</method> and <method>surname</method> separated by a space.  Both <method>given_name</method> and <method>surname</method> contain strings, which makes this task pretty easy.  In order to do this we will need to understand a little more about strings.  Just like integers, strings can be added together using the <method>+</method> method.  We can use <commandname>irb</commandname> to demonstrate this:</p>
      
<code language="irb">
> load 'person.rb'
> p.given_name + " " + p.surname
=> "Jean Bartik"
</code>
			
		  <p>Let’s write a spec that tests <method>full_name</method>.</p>
			<code file="code/person_spec/05/person_spec.rb" part="full_name1"/>
      <p>We wrote that example using our existing APIs, but it seems a little wordy. It’s awkward to set Jean’s
      first name when calling <method>new</method> and then set her surname on the next line. Here’s one way to approach it:</p>      
			<code file="code/person_spec/05/person_spec.rb" part="full_name2"/>
      <p>We've cut our code down to two lines instead of three, while maintaining the same functionality.  Now what would we expect to happen when we run our spec? We've added a second argument to the <method>new</method> method, which will get passed in to the <method>initialize</method> method.  We might hypothesize that an ArgumentError is in our future.  Let's run our spec to find out if we are right:</p>
<code language='session'>
$rspec person_spec.rb 
...F

Failures:

  1) Person full_name it concatenates given_name and surname
     Failure/Error: p = Person.new("Jean", "Bartik")
     ArgumentError:
       wrong number of arguments (2 for 1)
     # ./person.rb:4:in `initialize'
     # ./person_spec.rb:6:in `new'
     # ./person_spec.rb:6:in `block (3 levels) in <top (required)>'

Finished in 0.00033 seconds
4 examples, 1 failure        
</code>
      <p>
        Just as we suspected, an ArgumentError.  We'll need to allow our <method>initialize</method> method to accept an additional argument for <variable>surname</variable>.  In addition, we'll need to set our <variable>@surname</variable> variable equal to our second argument.  Our code should look like this:
      </p>
      <code file="code/person_spec/05/person.rb" part="two_args"/>
			<p>Now when we run our spec, we have a passing test:</p>
<code language='session'>
$ rspec person_spec.rb 
....

Finished in 0.0003 seconds
4 examples, 0 failure
</code>
      <p> Our <method>full_name</method> method is looking great!  Of course, there is more than one way to write this code.  In our case, we might want to consider changing a few things.  For instance, when we call <ic>Person.new("Gregory", "Frank")</ic>, it isn't clear whether the given_name is the first or second argument.  Then when we call our <method>full_name</method> method, we aren't sure whether this person is named "Gregory Frank" or "Frank Gregory." In this case we would need to look at the source or the docs to determine that his name is actually “Gregory Frank”. It is a good practice to design self-documenting APIs.  We can make this API more self documenting by using Ruby <class>Hash</class> syntax:</p>
			<code file="code/person_spec/05/person_spec.rb" part="full_name3"/>
<p>Now our API is clear and easy to understand. This type of argument list is often called an <emph>options
Hash</emph> and is used a lot in Rails.</p>
<p>Writing code test first is part of our design process. We have the opportunity to get a feel for how our APIs behave
before we implement them. Now that we are happy with our API, let’s move on to the implementation by running our spec and watching it fail:</p>
<code language="session">			
  1) Person full_name it concatenates given_name and surname
     Failure/Error: p = Person.new(:given_name => "Gregory", :surname => "Frank")
     ArgumentError:
       wrong number of arguments (1 for 2)
     # ./person.rb:7:in `initialize'
     # ./person_spec.rb:47:in `new'
     # ./person_spec.rb:47:in `block (3 levels) in <top (required)>'
</code>   
<p>The failure tells us <ic> wrong number of arguments (1 for 2)</ic>, but we’re passing both a given name and a surname. Why does RSpec expect a single argument?</p>
<p>RSpec is cluing us in to another bit of Ruby's syntactic sugar.  In fact, we are only passing in one argument, a hash.  Ruby allows us to drop the curly braces around a hash when we pass it into a method.  This special syntax allows us to write <ic>Person.new({:given_name => "Gregory", :surname => "Frank"})</ic> as <ic>Person.new(:given_name => "Gregory", :surname => "Frank")</ic>.  In this case, we’re using it for the initialize method, but this syntax would work for any method.</p>
<code file="code/person_spec/05/person.rb" part="init"/>
<p>When we accept the argument, we give it a default value by setting it in the argument list. Then we can set the given_name and surname to the values in the Hash. If a value isn’t given for one key or the other, the value will be nil and we can then provide the default value of an empty string.</p>
<p>We can see that works for initialize when we run our spec:</p>
<code language="session">			
$ rspec person_spec.rb
....F

Failures:

  1) Person full_name it concatenates given_name and surname
     Failure/Error: p.full_name.should == "Gregory Frank"
       expected: "Gregory Frank"
            got: "Gregory" (using ==)
     # ./person_spec.rb:31:in `block (3 levels) in <top (required)>'

Finished in 0.00089 sec
</code>   
<p>but it still fails because we haven't finished implementing our <method>full_name</method> to use instance variables. Let’s fix that:</p>
<code file="code/person_spec/06/person.rb" part="full_name"/>
<p>Now when we run our spec:</p>
<code language="session">			
$ rspec person_spec.rb
.....

Finished in 0.00096 seconds
5 examples, 0 failures
</code>   
<p>All of the examples pass. Hooray! We have a complete implementation.</p>
<sidebar>
<title>Variations on the Hash Argument</title>
<p>Let's dig a little deeper into hash arguments.  First off, here is something we can't do: </p>
<code language="irb">
> greg = Person.new {:given_name => "Gregory", :surname => "Frank"}
SyntaxError: (irb):4: syntax error, unexpected tASSOC, expecting '}'
greg = Person.new {:given_name => "Gregory", :surname => "Frank"}
                                  ^
(irb):4: syntax error, unexpected ',', expecting '}'
greg = Person.new {:given_name => "Gregory", :surname => "Frank"}
</code>
<p>Ruby gets confused about precedence when we omit the parentheses. However, we can just provide a list the hash key-value pairs without curly braces:</p>
<code language="irb">			
> greg = Person.new :given_name => "Gregory", :surname => "Frank"
 => #<Person:0x00000100a750c0 @name="Gregory", @surname="Frank"> 
</code>
<p>We can only omit the curly braces when a method has a single Hash argument or the last argument is a Hash. Rails likes to use this kind of syntax a lot.</p>
</sidebar>
</sect1>
		<sect1>
				<title>Using String Interpolation</title>
				<p>Our code is looking pretty good, but suppose we’re experimenting with it and we see a problem:</p>
<code language="irb">			
> p = Person.new
=> #<Person:0xb7786a38>
> p.given_name = nil
=> nil 
> p.full_name
NoMethodError: undefined method `+' for nil:NilClass
</code>
<p>Suppose we want to make sure that full_name always returns a String no matter what we set for given_name and surname. What should we do? Should we look at the <method>full_name</method> implementation to see where the bug is? Not yet. Let’s first write a failing test. We use test-driven development for fixing bugs as well as when we develop new code.</p>
<code file="code/person_spec/06/person_spec.rb" part="empty"/>
<p>We’ll see the same error when we run the spec.</p>
				<p>Our <method>full_name</method> method doesn't work unless <method>given_name</method> and
        <method>surname</method> are set.  If they are not set, the <method>+</method> method throws
        an error because it is being called on nil instead of on a string.  For this reason, we usually use string interpolation instead of <ic>+</ic> to concatenate strings.</p>
<sect2>
<title>String Interpolation</title>
<p>Ruby has concise syntax for evaluating some Ruby code and inserting the result into the string. Let’s see how it
works in irb:</p>
<code language="irb">				
> name = "Gracie"
=> "Gracie" 
> "Goodnight #{name}"
=> "Goodnight Gracie" 
> name = nil
=> nil 
> "Goodnight #{name}"
=> "Goodnight " 
</code>
<p>Using this special syntax, Ruby will always call <method>to_s</method> after evaluating the expression before
concatenating it with the rest of the string. <ic>nil.to_s</ic> results in the empty string, so we never get
<ic>undefined method `+' for nil:NilClass</ic> when we’re using string interpolation. String interpolation only works for strings surrounded by double quotes. Single quotes will interpret the characters literally:</p>

<code language="irb">				
 > name = "Gracie"
 => "Gracie" 
 > puts 'Goodnight #{name}'
Goodnight #{name}
 => nil 
 > puts "Goodnight #{name}"
Goodnight Gracie
 => nil 
</code>
<p>Most of the time single and double quotes act the same, but some characters have special meaning in a double-quoted
string. In addition to string interpolation, the “\” character is used to indicate certain non-ascii characters like
“\n” for newline and 
“\t” for tab and “\u” followed by a hexadecimal number for a unicode character. </p>
</sect2>          

<p>To make our example pass, we can use interpolation. We should also use the <method>strip</method> method to remove the extra space that will be left if either <method>given_name</method> or <method>surname</method> is nil or blank.</p>
<code file="code/person_spec/06/person.rb" part="full_name2"/>
<p>By test-driving our bug fixes, we know that we will never have to fix a bug twice. Our specs also serve as documentation for our fellow developers about the expected behavior of our APIs and what kind of data is supported.</p>
		</sect1>

		
		<sect1>
    <title>What We've Learned</title>
    <p> We've worked hard in this chapter to understand RSpec's syntax and the basic concepts behind writing specs.  We saw how important it is to understand Ruby's error messages when we are test driving our code. <ic>NameError</ic>, <ic>NoMethodError</ic> and <ic>ArgumentError</ic> are becoming familiar and we are starting to know what to do when we run into one of them.</p> 
    
    <p>We are also getting a feel for making improvements to our code so that it is more readable and understandable.  We used an argument hash to clear up any confusion about which argument is the given name vs surname.  We also used string interpolation to ensure that our <method>full_name</method> method always returns a string.  We learned about Ruby's built in <method>attr_accessor</method> and used it to shorten our getter and setter methods from six lines down to one.</p>

      <p>We are still at the beginning of our exploration of Ruby and test-driven development with RSpec. We will continue to learn more about RSpec and Ruby as we move into our study of Rails. Next we'll return to exploratory development and learn about some of the Rails command line tools as we create our web application.
      </p>


 
		</sect1>
</chapter>

