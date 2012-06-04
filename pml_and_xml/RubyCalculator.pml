<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.ruby_calculator">
  <title>Ruby Calculator</title>
    <sect1 id="sec.ruby.lang.intro">
      <title>Ruby Language Introduction</title>
      <p>
      You might wonder why a book about Rails starts off with an   introduction to the Ruby programming language.  The reason is that every excellent Rails programmer has a thorough understanding of Ruby  - after all, Rails is written in Ruby.  Trying to write a Rails program without knowing Ruby is like trying to write a limerick in English without knowing English – you could do it with the help of a translator, but it would be much easier with fluency in the language.  
      </p>
      <p>
      YAAAAAAAYYYYYYYYAAAAYYAYAYAYAYAY
      </p>
      <p>
      There are many reasons to love Ruby.  For one, it is a concise language: forget about semi-colons and curly braces – you won’t need them in this book.   You also won’t need to wrap your arguments in parentheses if you don’t want to.  Check this out:
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
      I <emph>defined</emph> the <method>combo</method> method without parentheses around my parameters and I <emph>called</emph> <method>combo</method> without parentheses around the arguments.  This is totally legal in Ruby and is called &lquot;poetry syntax&rquot;.  Of course, Ruby allows you to put in parentheses if you prefer.
      </p>

      <p>
        One of my favorite things about Ruby is that the quality of your code is determined in large part by the quality of your tests.  Rubyists have developed sophisticated tools for testing Ruby code like Rspec, Cucumber and Capybara to name a few.  Abundant test coverage gives you confidence when changing old code or adding new code.  It empowers programmers with flexibility and speeds up development over the long-term life of a project.  Test driven development (TDD) is a popular testing technique among Rubyists where a test is written before the code.  Learning effective TDD can be difficult which is why we are writing this book.  Lets get started playing with Ruby!
      </p>
      <sect2 id="ruby.lang.intro.irb">
         <title>Interactive Ruby (irb)</title>    
         <p>
         Ruby comes equipped with irb, which stands for &lquot;Interactive RuBy&rquot;. It allows you to see how Ruby will interpret your code and is one of the most valuable tools in your programmer toolbox.  To access irb, simply type &lquot;irb&rquot; into your command line.  You should see a prompt with an angle bracket &lquot;>&rquot; where you can type in Ruby code.  Here’s an example:
         </p>
         <code language="session">
           $ irb
           > 1 + 1
         </code>
         <p>
           Now when you click enter, Ruby will evaluate 1 + 1 and show you what it returns:
         </p>
         <code language="session">
           => 2
         </code>
      </sect2>





      <sect2 id="ruby.lang.intro.evaluation">
         <title>Everything Evaluates to Something</title>
      <p>
       In Ruby every expression evaluates to (returns) something.  That means that every time we ask Ruby to evaluate an expression, it will tell us the result of the evaluation.  Irb will help us get a better handle on return values.  When we asked Ruby to evaluate <ic>1 + 1</ic> above, it returned 2.  The <ic>=> 2</ic> on the line that appears below our expression after we hit the enter key is what Ruby returns from the expression.  We can evaluate addition on integers like 1 + 1 above, or we can evaluate strings:
      </p>

      <code language="session">
        > "like a string of pearls, but with characters"
         => "like a string of pearls, but with characters"
      </code>
      <p>
        A string consists of quotation marks with any number of characters in between.  Strings are used for any textual information that a program needs.  Ruby can add strings as well as integers.  When we add strings, we call it &lquot;concatenation&rquot;.  Check out this example of concatenating to strings:
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

    </sect1>




  </chapter>
