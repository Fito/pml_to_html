<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.intro">
<title>Why Test? And How We Test First</title>
 
  <p>Ever wanted to rip out an old feature and replace it with the next big thing? Well-tested code gives us the power
  of worry-free refactoring and code reuse.    <ed>what if the "ever" sentence was first, and then you followed it up with 
  "well tested code gives us the power of worry-free refactoring and code reuse." and then dropped "well tested code makes us..."?</ed>
  <author>Sarah: great suggestion. done.</author>
  Tests give us the confidence to reinvent our code to our heart's content.  Where our human brains fail at remembering
  all the details of our code's behavior, tests succeed. We can ship sooner and more often, giving us huge competitive
  advantage.<ed>Can you shorten this? There are a lot of adverbs (-ly) here that make
   this a little hard to read. I'd lose "in the world of web apps" and just say "This special power leads to better
   applications that ship sooner and have more frequent updates, giving us a huge competitive
   advantage"</ed><author>Sarah: even shorter is better, I think</author></p>
  <p>In a language, like Ruby, without a compiler, changing code can be particularly dangerous. If we change a method or class name,
  and we don’t modify every piece of code that calls it, there’s no compiler to catch the error. <ed>is that clear why? Is it because it's a 
  dynamic language? or is it because it's an interpreted language and not compiled?</ed><author>Sarah: agree that
  dynamic language stuff is less common use case, focusing on compiler is easier to explain</author>This can lead to a
  deceptive feeling of safety with languages like Java or C++.
  Testing allow us to catch logic errors that a compiler would never recognize, in addition to flagging places where we
  changed an interface without adjusting the calling code. With testing we
can enjoy the flexibility of a language like Ruby with a safety net.<ed>the logic errors part feels out
of place in this paragraph. It might be better off as it's own and slightly expanded upon.</ed><author>Sarah: is that
better?</author>
  </p>
  <figure id="fig.tdd-productivity">
  <title>Test Driven Development vs. Traditional Velocity by Alex Chaffee</title>
  <imagedata fileref="images/TDD-productivity-graph.png" align="center" />
</figure>
<p>We can visualize how test-driven development increases our productivity by thinking about how much time it takes to develop
each feature, as shown in <ref linkend="fig.tdd-productivity" />. <ed>do you have permission to use this? do you need a
signed release to reproduce this? You do unless it's public domain.</ed><author>I will get a signed release.</author>
With the first few features, traditional development
may be faster, because we aren’t typing test code in addition to implementing a feature. However, as features
accumulate, the tests allow us to quickly see how the addition of a new feature impacts existing features. Refactoring,
which we’ll learn about later in this chapter when we describe the test first development cycle in detail,
is key to keeping the effort per feature consistent. With an executable specification, plus well-factored tests and
implementation code, we can maintain development velocity as a codebase matures. </p>
 <sect1>
 <title>Testing Helps Us Create Great Software</title>
 <p>Writing code test first isn’t just about creating tests and verifying that our code lacks defects, it’s a software development process that causes us to write
 better code with fewer bugs.</p>
  <sect2>
  
  <title>Effective Design</title>
  <p>First and foremost, test first development is about design. Before we write any code, we test
  our design. In our tests we develop against APIs that don’t exist yet. We see how the code will flow and what the
  behavior would be if that code existed. We are free to change APIs and modify how methods work together without having
  to rewrite any implementation code. </p>
  <p>This design process caused the creators of RSpec and other so-called test frameworks to rename the process
  <emph>behavior driven development</emph> (BDD). When we write our code test first, we are actually writing a
  <firstuse>specification</firstuse> of our code. We are
  specifying our code by example with each test case part of an <emph>executable specification</emph>.</p>
  <p>As with paper specifications, we can see the API in action; however, unlike paper specs, once all of the tests pass, 
  we know that the APIs work together to create the desired result and the test ensures that the API is used consistently across the whole specification.</p>
  <p>Verifying our design before we write our code translates into development velocity. It may take us longer to type
  the code the very first time, but the code has fewer bugs and we are more likely to develop the right solution. We
  develop production code significantly faster than traditional test last or wild west methodologies.</p>
  </sect2>
  <sect2>
<title>Easier Collaboration</title>
  <p>A test first approach has a few different effects in the way we work that make it easier to collaborate in a team.
  The nature of an executable specification improves interaction between developers and whoever is setting the
  requirements. Also, the tests themselves and the incremental nature of development improves collaboration betwen
  developers on the team.</p>
  <p>Historically we’ll have a product manager who sets requirements and engineers who write specifications on paper. Sometimes
  the line between setting requirements and figuring out the technical solution can get a little blurry. By writing our
  specifications in code, we clearly separate the definition of requirements from the
  specification process. With test-driven development, requirements are still defined in words, but specifications are written with code (even if it is code that sounds a bit like English). Having two different activities for each phase helps separate the steps in
  the process.</p>
  <p>When we sit down to write a spec or test, it forces us to consider whether we are missing some
  information. We need to clearly understand pre- and post-conditions for the code we are about to define. Do we need to ask some questions to refine the requirements? Do we need to learn more about the
  technologies we’re using before we dive into implementation? Test first development can help improve this process and
  allow developers to work with a product manager or product owner more effectively, and also ensure that developers
  know what they are doing when they sit down to write production code.</p>
<p>In addition to helping with the product definition workflow, test first development fosters collaboration between
developers. Tests serve as documentation for other developers on the team.  If a developer comes across unfamiliar code, it is easy to go check out the spec to see the code in action.</p>   
  <p>Writing tests first encourages small, frequent commits, contributing to effective collaboration.  Once our failing test passes, we know that we are done coding a particular requirement.  A test first approach allows
  us to chunk our requirements into little bite sized pieces that can be committed to source control separately.  All the developers on our project can then commit and pull multiple times per day and the code stays synched up.</p>
</sect2>
<sect2>
<title>More Maintainable Code</title>
<p>Less code is more easily maintained. A test first approach keeps us focused so that we only
  write necessary code. We write tests just for the new behavior we want to build, and it helps us not write redundant
  tests for the built in behavior of the underlying system.</p>
  <p>When we test drive development, we also tend to write smaller methods and write components with better separation
  of concerns. This kind of code is more flexible and easier to modify.</p>
</sect2>
<sect2>
<title>Shorter Bug Find-Fix Cycle</title>
  <p>Test driving our code turns us into a different kind of programmer.  We focus on getting things correct from all
  angles. Once we test drive some new behavior, we run our whole test suite so we can discover if our code had some
  unintended effect or the new behavior interacted with an old feature in an unexpected way. By finding bugs quickly,
  before the code ever goes to QA or to production, we dramatically speed up the process by shortening the bug find-fix
  cycle.</p>
</sect2>
<sect2>
<title>The Creation of Tests</title>
<p>Lastly, we end up with a test suite! Writing the tests first guarantees that. If we always write tests first, we’ll
have 100% code coverage. Of course, that doesn’t mean that every condition is tested or that the code does the right
thing, but it is certainly a great statrt.</p>
<p>We still sometimes release our code with bugs, but once a bug is found, we can write a test that exposes it by
failing. Then once the test passes, that bug will never bother us again.  We get into a rhythm of writing the test,
making it pass.  It becomes second nature.  It forces us to really know what we are doing.  It makes our brain grow and
our code solid.</p>
</sect2>
  </sect1>


<sect1>
<title>Red, Green, Refactor</title>
<figure id="fig.tdd">
  <title>Test Driven Development Cycle</title>
  <imagedata fileref="images/tdd.svg" align="center" />
</figure>
<p>Test first development is more than just writing the test first. The test first development cycle include series of
steps that are essential to capturing the benefits of a test first approach. We call the cycle "Red, Green, Refactor" because when we first write our test, it fails and the output is colored red.  Then once our code passes, the output is green.  Finally, we go back and <firstuse>refactor</firstuse> our code, meaning that we make it more readable and maintainable without changing its behavior.</p>
<p>We learn to embrace failure. Every test we write starts with a failure and we check that it fails properly before we
start writing our application code.  Why would we be such sticklers about failing?  Because sometimes the behavior of
our application surprises us and it passes without any new code, or we discover that the test wasn’t written correctly
and it passes or fails because of an error in the test. This test-driven development cycle is illustrated in <ref
linkend="fig.tdd" />. We always want to start by watching our test fail to ensure that it fails the way we expect it to fail.</p>
<p>Next we write just enough code to satisfy the error that we saw. We try to write <emph>simplest code that could
possibly work</emph> even if it means hard-coding some value that we’ll flesh out later as we write further tests. This
ensures that we don’t write extra code that we will have to maintain without test coverage and that might not even be
necessary for the current product requirements. </p>
<p>We continue the cycle of writing a little code and running our test again until we’ve written enough code to make our test pass.  Then we’ll go back and rework code that we want to improve for maintainability, readability or performance. We’ll also add tests to flesh out behavior so that we don’t leave hard-coded values in our final implementation.</p>


</sect1>

<sect1>
<title>Defining Our Application</title>
<figure id="fig.mock_home_page">
  <title>Mock Home Page</title>
  <imagedata fileref="images/intro/mock_home_page.png" />
</figure>
<p>Test first development dramatically changes how we define our application. Creating a specification using
tests rather than with words lets us put a stake in the ground early with the flexibility to shift our implementation as
requirements change.</p>
<p>Innovation in business
development is leading toward new processes where paper prototypes lead to working
software that implements a small fraction of the planned product. Feedback from prospective or real customers can
influence changes in direction that ultimately lead to product improvements and a better market fit. We’ll be learning
how to do test driven development, but we’ll be building an application with the goal of learning, rather than iterating
on a specific business need.</p>
<p>Throughout this book, we’ll work on a simple application that will provide many
opportunities to explore how Rails works. As we gain experience with each feature of Rails, we’ll use our knowledge to
write tests to specify new behavior and drive more development.

<ed>The first paragraph in this section isn't working for me at all. It follows "defining the application" section heading with "it doesn't". It just doesn't feel like it belongs here. The second paragraph doesn't really add much either because it somewhat undermines the process a bit - you're saying that what you're going to show us isn't how we will do things 
on a real project. I don't know if you need to say that. You have two goals here. First, you want
 to get people to know enough about Rails to build something, but you want them to learn Rails through exploration and testing, rather than simply following along and banging out some code. So you may want to just come out and say that. "Throughout this book, we'll be working on a simple application that will give us many opportunities to explore how Rails works. As we gain more experience with Rails, we'll use our knowledge to write tests which we then use to drive more development." or something. </ed>
 <author>Sarah:reworked the introduction to this section</author>
 </p>
<p>We’ll be developing an application to manage a creative writing class. <ed>I think this should come before the previous
para</ed><author>Sarah: good idea. done.</author>Each course has a set of assignments and students are expected to submit
their writing assignments through the website. Each student has a page so that everyone in the class can read everyone
else’s work to support class discussions and peer critiques. In <ref linkend="fig.mock_student_page"/>, we can see how
it might look for each student to have a page, where students can see which assignments are
completed, can review old assignments or complete a new one.</p>
<figure id="fig.mock_student_page">
  <title>Mock Student Page</title>
  <imagedata fileref="images/intro/mock_student_page.png" />
</figure>
<p>The application we’re building will have key elements which are part of almost every web application, so that you can take
what you learn in this book and build your own app.</p>
<p>Most web applications have a home page, we’ll make a simple one that links to the different parts of the application.
A mockup of the one we’ll build  is shown in <ref linkend="fig.mock_home_page"/><footnote><p>Screens were sketched using
Balsamiq Mockups: a great tool for getting a feel for the data you want to display and defining the initial interaction design.</p></footnote>. Most production web applications will
have fancier home pages. By the end of the book, we’ll have learned how to put additional dynamic data on a page, but we
won’t dive into additional HTML, CSS, and JavaScript that could be added to create a more effective user experience.</p> 

<p><ed>"By the time we're done, we'll..."?</ed><author>sarah: done</author>By the time we’re done, we’ll make it so that people can log in and only students can write or edit their own
assignments and only the teacher can add courses and make create new assignments for a course.</p>
<p>The data for our application will be stored in a relational
database. We’ll have information about <ed>a data? do you mean table? And should you have a diagram of your
tables?</ed><author>Sarah: the a was out of place, moved to more general english-y term “information”</author> students, lists of assignments and a way to keep track of the different course she has
offered in the past as well as the current one. </p>
<p>If we look at
the volume of code that it takes to build a web application, the majority of it will be common between web applications.
This a key strength of Rails. The framework implements the common behaviors, allowing us to focus on the parts
that are unique to what we want people to be able to do with our application.</p>
<p>We’ll begin with Ruby.</p>

</sect1>
</chapter>
