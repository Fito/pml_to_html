<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.ruby-rspec-basics">
  <title>Ruby and Rspec Basics</title>

  <sect1 id="sec.ruby.lang.intro">
    <title>Ruby Language Introduction...and Why Ruby is Rad</title>
    <p>
    Every excellent Rails programmer has a thorough understanding of Ruby  - after all, Rails is written in Ruby.  Trying to write a Rails program without knowing Ruby is like trying to write a limerick in English without knowing English – you could do it with the help of a translator, but it would be much easier with fluency in the language.  Before we dig deeply into Rails let's get a solid grounding in Ruby.  
    </p>
    <p>
    There are many reasons to love Ruby.  For one, it is a concise language: forget about semi-colons and curly braces – we won’t need them in this book.   We also won’t need to wrap our arguments in parentheses if we don’t want to.  Check this out:
    </p>

    <code language="ruby">
      def combo thing1, thing2
        thing1 + " and " + thing2
      end
    </code>

    <code language="irb">
      > combo "peanut butter", "jelly"
      => "peanut butter and jelly" 
      > combo "pork chops", "applesauce"
      => "pork chops and applesauce"  
    </code>

    <p>
    We defined the <method>combo</method> method without parentheses around our parameters and we called <method>combo</method> without parentheses around the arguments.  This is totally legal in Ruby and is called &lquot;poetry syntax&rquot;.  Of course, Ruby allows us to put in parentheses if we prefer.
    </p>

    <p>
      One of my favorite things about Ruby is that the quality of our code is determined in large part by the quality of our tests.  Rubyists have developed sophisticated tools for testing Ruby code like Rspec, Cucumber and Capybara to name a few.  Abundant test coverage gives us confidence when changing old code or adding new code.  It empowers programmers with flexibility and speeds up development over the long-term life of a project.  Test driven development (TDD) is a popular testing technique among Rubyists where a test is written before the code. Lets get started playing with Ruby!
    </p>
    <sect2 id="ruby.lang.intro.irb">
       <title>Interactive Ruby (irb)</title>    
       <p>
       Ruby comes equipped with irb, which stands for &lquot;Interactive RuBy&rquot;. It allows us to see how Ruby will interpret our code and is one of the most valuable tools in our programmer toolbox.  To access irb, we type &lquot;irb&rquot; into our command line.  We should see a prompt with an angle bracket &lquot;>&rquot; where we can type in Ruby code.  Here’s an example:
       </p>
       <code language="session">
         $ irb
         > 1 + 1
       </code>
       <p>
         Now when we click enter, Ruby will evaluate 1 + 1 and show us what it returns:
       </p>
       <code language="session">
         => 2
       </code>
    </sect2>





    <sect2 id="ruby.lang.intro.evaluation">
       <title>Everything Evaluates to Something</title>
    <p>
     In Ruby every expression evaluates to (returns) something.  That means that every time we ask Ruby to evaluate an expression, it will tell us the result of the evaluation.  Irb will help us get a better handle on return values.  When we asked Ruby to evaluate <ic>1 + 1</ic> above, it returned 2 (<ic>=> 2</ic> appears after we hit the enter key).  We can evaluate addition of integers like 1 + 1 above, or we can evaluate strings:
    </p>

    <code language="session">
      > "like a string of pearls, but with characters"
       => "like a string of pearls, but with characters"
    </code>
    <p>
      A string consists of quotation marks with any number of characters in between.  Strings are used for any textual information that a program needs.  
    </p>
    <p>
      Ruby can add strings as well as integers.  When we add strings, we call it &lquot;concatenation&rquot;.  Check out this example of concatenating strings:
    </p>
    <code language="session">
      > "knock, knock." + " whose there?" +
      >   " interrupting cow." + " interrupting cow wh..." + " Moooo"
       => "knock, knock. whose there? interrupting cow. interrupting cow wh... Moooo"
    </code>

     <p>
        Ruby evaluates the concatenation of the five strings making up this cheesy knock knock joke and returns them all together as one string.
     </p>
   </sect2>
   
   <sect2 id="ruby.lang.intro.objects">
    <title>Everything Is an Object</title>
    <p>
      Yep, it’s true.  Everything in Ruby is an object, unlike many other languages.   The fact that strings and numbers are objects means that Ruby can define methods on them.  We can change a string from lowercase to uppercase as follows:
    </p>

    <code language="irb">
    > "too big for my britches".upcase
     => "TOO BIG FOR MY BRITCHES"
    </code>
   
    <p>
       The string &lquot;too big for my britches&rquot; is an instance of the <class>String</class> class where the <method>upcase</method> method is defined.  Ruby has many classes of its own such as<class>String</class>, <class>Hash</class>, <class>Array</class>, etc.   A class is like a blueprint from which we can make as many houses as we want.  We can also define our own classes and create objects from them.  That’s what we will do next.
     </p>
    </sect2>
  </sect1> 
  <sect1 id="sec.ruby.tdd.pre">
    <title>Test Driven Development Prerequisits</title>
    <p>
      RSpec and other testing frameworks are fantastic tools that make programmers’ lives easier and speed up the process of adding features and fixing bugs.  But what if they didn’t exist?
    </p>

    <p>
      To gain insight into the value of test frameworks, let’s suspend our disbelief and pretend testing frameworks haven’t been invented yet.  We can improvise a primitive test framework of our own by running our code in irb and understanding the error messages.  We can try out different permutations of our code to see what works and what doesn’t based on the same error messages we will be seeing once we start using RSpec.
    </p>
    <p>
        We need a simple example to start with.  Let's write a <method>welcome_message</method> method for the <class>Course</class> class.  We will continue to use our Course class throughout this book and the <method>welcome_message</method> method we are about to write will eventually be added to our Rails application.  A requirement of the <method>welcome_message</method> method is that it should change the greeting depending on the time of day.  It should say &lquot;Good Morning! Office hours are currently closed.&rquot; in the morning, &lquot;Good Afternoon! Office hours are currently open.&rquot; in the afternoon and &lquot;Good Evening! Office hours are currently closed.&rquot; in the evening. We are going to walk through this example in baby steps, but so you know what we are working towards, our end result will look like this: 
    </p>
    <code language='ruby'>
      class Course
        def welcome_message
          time = Time.now
          if ("01:00" < time.strftime('%R')) && (time.strftime('%R') < "11:59")
            message = "Good Morning! Office hours are currenlty closed."
          elsif ("12:00" < time.strftime('%R')) && (time.strftime('%R') < "16:59")
           message = "Good Afternoon! Office hours are currently open."
          elsif ("17:00" < time.strftime('%R')) && (time.strftime('%R') < "24:59")
           message = "Good Evening. Office hours are currently closed."
          end
        end
      end
    </code>
    
    <p>
      First we’ll need a file.  Ruby files end with a &lquot;.rb&rquot; extension.  By convention we name files after the class we plan to write, but it could be called <filename>super_welcome_message_maker.rb</filename> and it would still work.  Let’s follow the Ruby convention and make a file called <filename>course.rb</filename> since we plan to make our <method>welcome_message</method> method in the <class>Course</class> class.
    </p>
    
    <p>
      Before we load our Course class into irb, let's look at what happens if we try to use the Course class:
    </p>

    <code language="irb">
    $ irb
    > Course
    NameError: uninitialized constant Course
      from (irb):2
    </code>

    <p>
      In Ruby, classes are constants.  When typing in <ic>Course</ic> above, Ruby knows that there isn’t currently a <class>Course</class> class, so it throws a <constant>NameError</constant> telling us that the <class>Course</class> constant doesn’t exist.  (Note: constants in Ruby always start with a capital letter and by convention are all caps.  Classes are an exception to the convention.  For classes, the first letter of each word is capitalized and spaces are omitted.)   Ruby’s descriptive Error messages are crucial in helping us debug programs.  The <constant>NameError</constant> above describes exactly what is wrong with our program.  We are going over this in detail because a key to mastering TDD is learning to read error messages.
    </p>
    
    <p>
      Let’s try again after loading in <filename>course.rb</filename>.  We will see what happens if we just create the file without any contents and load it in irb:
    </p>
    <code language="irb">
    > load 'course.rb'
     => true 
    > Course
    NameError: uninitialized constant Course
      from (irb):2
    </code>

    <p>
      Loading <filename>course.rb</filename> reports true since it was able to successfully load the file and evaluate the (empty) contents of the file as Ruby code, but <class>Course</class> is still not defined.  Loading the file simply evaluates the text inside it as Ruby code.  
    </p>
    
    <p>
      Next we can add the class declaration to the file:
    </p>

    <p><filename>course.rb</filename></p>
    <code language="ruby">
      class Course
      end
    </code>
    
    <p>
       Our code can now create Course objects.  We create a new object with the <method>new</method> method:
    </p>
    <code language="irb">
      c = Course.new
       => #<Course:0x10044c6a8>
    </code>
    
     <p>
       Our new Course object’s return value shows the class of the object (<class>Course</class>) and an encoded version of the object’s id (0x10044c6a8).  If we make more objects of the <class>Course</class> class, each one will have a unique object id.  We haven’t defined any methods in our <class>Course</class> class, yet look at our output when we ask our <class>Course</class> object for its methods:
     </p>
     <code language="irb">
     
     c.methods
      => ["inspect", "tap", "clone", "public_methods", "object_id", "__send__", "instance_variable_defined?", "equal?", "freeze", "extend", "send", "methods", "hash", "dup", "to_enum", "instance_variables", "eql?", "instance_eval", "id", "singleton_methods", "taint", "frozen?", "instance_variable_get", "enum_for", "instance_of?", "display", "to_a", "method", "type", "instance_exec", "protected_methods", "==", "===", "instance_variable_set", "kind_of?", "respond_to?", "to_s", "class", "__id__", "tainted?", "=~", "private_methods", "untaint", "nil?", "is_a?"]
      
    </code>
    <author>Liah: the above code seems to be causing an issue...?</author>
    <p>
       Ruby gives many useful methods for free to any class we create.  This is because every class in Ruby is a descendent of the <class>Object</class> class where all these methods are defined.  We can prove this to our selves like this:
    </p>
    <code language="irb">
     > c.class
      => Course
     > c.class.superclass
      => Object 
     </code>

     <p>
       Our <class>Course</class> object is an instance of the <class>Course</class> class and the superclass of the <class>Course</class> class is the <class>Object</class> class.
     </p>
     
     <p>
       We’ll need to add our <method>welcome_message</method> method to our <class>Course</class> class in order for its objects to have useful functionality outside of its inherited methods.  Before we change our code, we should check out what happens when we call the <method>welcome_message</method> method on our <class>Course</class> object:
     </p>

     <code language="irb">
     > c.welcome_message
     NoMethodError: undefined method `welcome_message` for #<Course:0x10045f0a0>
       from (irb):19
     </code>

     <p>
       This time our error message is a <constant>NoMethodError</constant>.  It tells us that currently the <method>welcome_message</method> method is not defined, as we would expect.  Now we can edit <filename>course.rb</filename> so that the <method>welcome_message</method> method is defined and we give it a return value of &lquot;Good Morning! Office hours are closed.&rquot;.
     </p>
     <code language="ruby">
     class Course
       def welcome_message
          "Good Morning! Office hours are closed"
       end
     end
     </code>
     
     <p>
       When we reload <filename>course.rb</filename> and call the <method>welcome_message</method> method, the string &lquot;Good Morning! Office hours are open.&rquot; is returned.
     </p>
     
     <code language="irb">
     > c.welcome_message
      => "Good Morning! Office hours are open."
     </code>
  </sect1>
</chapter>
