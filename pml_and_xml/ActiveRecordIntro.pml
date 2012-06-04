<?xml version="1.0" encoding="UTF-8"?>  <!-- -*- xml -*- -->
<!DOCTYPE chapter SYSTEM "local/xml/markup.dtd">
<chapter id="ch.activerecord">
<title>Exploring ActiveRecord</title>
<p>Remember how we created a <ic>person</ic> object with the <ic>generate scaffold</ic> command, in <ref
linkend="ch.firstapp"/>?  Our scaffold generated a <class>Person</class> class. The <class>Person</class> class and its
corresponding <ic>people</ic> table is our model. The model represents a single row in the database table.</p>

<p>ActiveRecord, the <emph>model</emph> in the Rails Model-View-Controller pattern, lets us easily create, retrieve,
update and destroy database records with minimal effort. We skip writing mundane SQL statements, and if we follow
standard naming conventions, we can avoid configuration as well. We can focus on solving our application’s specific needs
rather than writing boilerplate code.</p>

<p>ActiveRecord uses naming conventions to map rows in our database tables to Ruby objects. 
In any language, we call these kinds of libraries &lquot;Object-Relational-Mappers&rquot; or ORMs, and we use them because they
let us write natural code in one language to create a corresponding effect in another.  In our case, we manipulate Ruby
objects to effect change in a SQL database.</p>
<p>With ActiveRecord we can: </p>
<ul>
  <li><p>work with Ruby Objects, instead of database tables and records</p></li>
  <li><p>write very concise code to fetch and store data</p></li>
  <li><p>easily write and maintain database independent code</p></li>
</ul>
<p>We’ll pick up just where we left off at the end of the last chapter.  We spent a whole chapter creating a web app,
but it was really just seven commands. Here they are all at once:</p>
<code language="session">
$ rails new class_app -T
$ cd class_app
# edit Gemfile to include rspec-rails
$ bundle
$ rails generate rspec:install
$ rails generate scaffold person given_name:string surname:string 
$ rake db:migrate
$ rails server
</code>
<p>In the terminal we can see the log output for our running app. We can interact with the default HTML user interface for viewing and
modifying our <ic>person</ic> objects at <url>http://localhost:3000/people</url>.</p>
<p>We can find the code for the person model that our scaffold generated in app/models/person.rb. Our model is a subclass of <class>ActiveRecord::Base</class> and does not declare the specific attributes that
are in its associated <ic>people</ic> table:  </p>
<code file="code/class_app_new/00_person_scaffold/app/models/person.rb"/>
<p>The class is declared but there isn’t any code in it. We were able to create
people records by entering names into our application’s web interface. How did we get a functional
web app with no code in the <class>Person</class> class?</p>
<p>ActiveRecord constructs attributes for us without any coding on our part.
Our <class>Person</class> class inherits behavior from <class>ActiveRecord::Base</class> that
dynamically determines what attributes it has by looking at the database structure at runtime. Later we’ll dive into how that database structure was created.  For now, let’s experiment with model objects and get a feel for how they work.</p>

<p>The Rails console is the perfect tool to begin our exploration of how ActiveRecord works. In this chapter, we'll access <class>Active
Record::Base</class> methods interactively through our <class>Person</class> class. Once we understand ActiveRecord,
we’ll learn to test-drive our model development in the next chapter.  With a firm foundation in the core ActiveRecord
APIs, we will have the confidence to test-drive our code’s unique behavior and not worry about
the built-in functionality, which is already tested by Rails itself.</p>

<sect1 id="sec.explore-active-record">
<title>Interacting with ActiveRecord in the Rails Console</title>
<p>The <commandname>rails console</commandname> command runs irb, which we explored while learning Ruby, and it also
loads our Rails application environment.  We will have access to the
same classes that are available in our Rails application code. In the last chapter, we used
<commandname>dbconsole</commandname> to evaluate
SQL and talk to the database directly.  The Rails console is a completely different command-line tool, which lets us interact with our database only indirectly by evaluating Ruby.  </p>
<p>Let’s launch the console by executing the following command inside the <ic>class app</ic> application main directory:  </p>
<code language="session">
$ rails console
</code>
<p>As a shortcut we can instead type:</p>
<code language="session">
$ rails c
</code>
<p>Our model class is available in the console without having to <ic>require</ic> the file. Here we can see that Rails
is Ruby and we can create a Person object, just like any Ruby class:</p>
<code language="irb">
> p = Person.new
=> #<Person id: nil, given_name: nil, surname: nil, created_at: nil,
updated_at: nil> 
</code>
<p>Let's take a look at the return value of <ic>Person.new</ic>.  It displays the attributes of our newly created person (id, given_name, surname, created_at, updated_at).  If we think back to when we were making new <class>Person</class> objects in <ref linkend="ch.ruby-intro"/>, We will remember that the return of <ic>Person.new</ic> did not include the object's attributes. So what changed?  The answer is that the Rails ActiveRecord::Base class
overrides the built-in <method>inspect</method> method to give us extra data about its attributes.</p>

<p>Now that we have an instance of our <class>Person</class> class to play with, we can see how ActiveRecord provides methods that write directly to the database without our needing to write any SQL:</p>
<code language="irb">
ruby-1.9.2-p0 > p = Person.new(:given_name => "Adele", :surname => "Goldstein")
 => #<Person id: nil, given_name: "Adele", surname: "Goldstein", created_at: 
 nil, updated_at: nil> 
ruby-1.9.2-p0 > p.save
</code>
<p>After calling <method>save</method> on our new <class>Person</class> object, we have
actually written data to our SQL database. We can browse to <url>http://localhost:3000/people</url> and see Adele Goldstein
in our list of people.</p>
<sect2>
<title>Understanding SQL Called by ActiveRecord</title>
</sect2>
<p>To better understand how ActiveRecord works and which methods talk to the database directly using SQL, we can look at
SQL queries as they are logged by Rails.  </p>
<p>
We’ll use built-in Rails logging as a diagnostic tool to allow us to see the SQL commands from the log interleaved
interactively with our Ruby code. This technique is very helpful when
  first getting a feel for how ActiveRecord works and sometimes for debugging. </p>
<p>If any part of
ActiveRecord has already been accessed this won’t work. We must do this at the very beginning of a <commandname>rails console</commandname> session. </p>
<code language="session">
$ rails c
Loading development environment (Rails 3.0.1)
>> ActiveRecord::Base.logger = Logger.new(STDOUT)
</code>
<p>
The ActiveRecord class <ic>logger</ic> attribute references another class for logging debug
info, errors and warnings.  The <class>Logger</class> class is part of Rails and when Rails starts up, by
default, it will create a logger and pass it a file named for the environment we’re running in the
<dir>log</dir> directory.  Since we’re running in development mode by default, you would normally look at the
log file with the command <ic>tail -f log/development.log</ic>; however, we’re going to use STDOUT which is a Ruby
constant referencing an output stream for the console or terminal where we are running Ruby.  This will echo all of
the log output right where we can see it.</p>
<p>Let’s start by creating another instance of the <class>Person</class> class:</p>
<code language="irb">
>> bret = Person.new
</code>
<p>This is just an in-memory representation of a <class>Person</class> object.
  All of the columns in the people database table are available as attributes of the instance, which is just shorthand
  for saying that there is a getter and a setter for each column in the database:</p>
<code language="irb">
>> bret.given_name = "Bret"
>> bret.surname = "Smith"
>> bret
=> #<Person id: nil, given_name: "Bret", surname: "Smith", present: nil, 
created_at: nil, updated_at: nil> 
</code>
<p>
If we try to access an attribute that is not defined in the people table, Ruby will raise a NoMethodError:</p>
<code language="irb">
>> bret.xxx
NoMethodError: undefined method `xxx' for #<Person:0x0000010290a5d0>
	from .../attribute_methods.rb:364:in `method_missing'
</code>
<p>We commonly use the Ruby hash syntax which we learned about in <ref linkend="ch.rspec-intro"/>. The
<class>ActiveRecord</class>
constructor allows us to supplying a hash of name-value pairs for each attribute
that we want to set:</p>
<code language="irb">
>> may = Person.new(:given_name => "May", :surname => "Fong") 
 => #<Person id: nil, given_name: "May", surname: "Fong", present: nil, 
created_at: nil, updated_at: nil> 
</code>
<p></p>
<p> We can see that
the id is <ic>nil</ic>, indicating an unsaved record for the object that we created. Setting attributes on the Ruby object doesn’t commit them to the database. We have just created objects that exist only in-memory. We can also call:</p>
<code language="irb">
>> may.new_record?
=> true
</code>
<p>
<class>ActiveRecord</class> keeps track of whether a model just exists in memory or has been committed to the
database. Let’s save the model now, but this time we are logging to <ic>STDOUT</ic> so we will see the SQL commands too:
</p>
<code language="irb">
>> may.save
  SQL (0.3ms)   SELECT name
 FROM sqlite_master
 WHERE type = 'table' AND NOT name = 'sqlite_sequence'

  SQL (11.9ms)  INSERT INTO "people" ("created_at", "given_name", "surname", 
  "present", "updated_at") VALUES ('2010-09-06 07:09:18.238744', 'May',
  'Fong', NULL, '2010-09-06 07:09:18.238744')
 => true 
bret.save
</code>

<p><class>ActiveRecord</class> makes the conceptually simple save operation, syntactically simple as well. <class>ActiveRecord</class> generates the
appropriate SQL <ic>INSERT</ic> statement for us.  The <method>save</method> method returns true if the record is successfully saved and false
if there is an error. Now we can see that <method>new_record?</method>  will return false and
  that our <ic>may</ic> object now has values for id, created_at, and updated_at, which were automatically assigned when
  the record was saved.  Of course, the <ic>bret</ic> record can also be saved.  Whether we create an instance of the <class>Person</class> class with attributes passed to the constructor or set them later, the instance will save the current value of that attribute.</p>
<code language="irb">
>> may.new_record?
=> false
>> may
=> #<Person id: 1, given_name: "May", surname: "Fong", present: nil, 
created_at: "2010-09-06 07:09:18", updated_at: "2010-09-06 07:09:18"> 
</code>
<p>
  ActiveRecord also tracks whether any attributes have been modified, so that if we call save again, it won’t actually
  call the database if we haven't modified anything. Since we’re logging to the console, we can see
  that nothing happens when we call save again without setting any attributes:</p>
<code language="irb">
>> may.save
 => true 
</code>

<p>
  We can look at individual attributes to see which ones have changed:</p>
<code language="irb">
>> may.surname 
 => "Fong" 
>> may.surname_changed?
 => false 
>> may.surname = "Woo"
 => "Woo" 
>> may.surname_changed?
 => true 
>> may.changed?
 => true 
>> may.save
  SQL (40.4ms)  UPDATE "people" SET "surname" = 'Woo', 
  "updated_at" = '2010-09-06 07:14:08.497625' WHERE ("people"."id" = 1)
 => true 
</code>

<p>
   When we modify attributes on an existing record and we save our record, <method>save</method> will call the database with an <ic>UPDATE</ic> instead of the <ic>INSERT</ic> that was triggered when we initially saved the new record.</p>
<p>In Rails, there is a shortcut that does both new and save in a single operation:</p>

<code language="irb">
>>john = Person.create(:given_name => "John", :surname => "Woo")
  SQL (0.4ms)  INSERT INTO "people" ("created_at", "given_name", "surname",
  "present", "updated_at") VALUES ('2010-09-06 20:46:13.660208', 'John', 
  'Woo', NULL, '2010-09-06 20:46:13.660208')
 => #<Person id: 3, given_name: "John", surname: "Woo", present: nil,
 created_at: "2010-09-06 20:46:13", updated_at: "2010-09-06 20:46:13"> 
</code>
<p>We can use the <method>create</method> method to set attributes and save the record in one step. Like
  <method>new</method>, it is a method on the class, rather than the instance.</p>

<sect2>
<title>Finding Information in the Database</title>
<p>As with creating, updating, and saving records, if we use the built-in
ActiveRecord methods for finding records, our code will be database independent. We can find records by id, and also
quickly find first, last or all records.  Each of these methods trigger a database SELECT every time they are called. </p>
<dl>
<dt>Person.all</dt>
<dd><p>SELECT * FROM people</p></dd>
<dt>Person.first</dt>
<dd><p>SELECT * FROM people limit 1</p></dd>
<dt>Person.last</dt>
<dd><p>SELECT * FROM ORDER BY id DESC limit 1</p></dd>
</dl>
<p>To get an array of <class>Person</class> objects for all of the data in the database we can call
<ic>Person.all</ic>, but the output in the rails console is a little hard to read:</p>
<code language="session">
>> Person.all
 => [#<Person id: 1, given_name: "May", surname: "Woo", created_at: 
 "2011-01-18 05:25:15", updated_at: "2011-01-18 05:25:15">, #<Person 
 id: 2, given_name: "Bret", surname: "Smith", created_at: 
 "2011-01-18 05:25:29", updated_at: "2011-01-18 05:25:29">, #<Person 
 id: 3, given_name: "John", surname: "Woo", created_at: 
 "2011-01-18 05:25:39", updated_at: "2011-01-18 05:25:39">] 
</code>
<p>To make the output easier to read, we can display it in YAML format by using the handy  <ic>y</ic>
command and passing it the array of <class>Person</class> objects resulting from the ActiveRecord call.  This not
only shows attributes that are generated from the database columns, but also other data for each object, such as the set
of <ic>changed_attributes</ic> and various flags for understanding the state of the object relative to the database:</p>

<code language="session">
>> y Person.all
--- 
- !ruby/object:Person 
  attributes: 
    id: 1
    given_name: May
    surname: Woo
    created_at: 2011-01-18 05:25:15.378022
    updated_at: 2011-01-18 05:25:15.378022
  attributes_cache: {}

  changed_attributes: {}

  destroyed: false
  marked_for_destruction: false
  new_record: false
  previously_changed: {}

  readonly: false
- !ruby/object:Person 
  attributes: 
    id: 2
    …
</code>
<p>Seeing objects as YAML gives all the data for them, which can be very useful for debugging.</p>
</sect2>
<sect2>
<title>Finding Something Specific</title>
<p> The simplest way to find something specific in the database is to call <ic>where</ic> with a hash of attributes to
match:</p>
<code language="session">
>> Person.where(:given_name => "Bret")
  SQL (0.4ms)   SELECT name
 FROM sqlite_master
 WHERE type = 'table' AND NOT name = 'sqlite_sequence'
  Person Load (0.2ms)  SELECT "people".* FROM "people" 
  WHERE ("people"."given_name" = 'Bret')
 => [#<Person id: 2, given_name: "Bret", surname: 
 "Smith", created_at: "2011-01-18 05:25:29", updated_at: 
 "2011-01-18 05:25:29">] 
</code>
<p>Check out what happens when we look for something with a single quote in it:</p>
<code language="session">
>> Person.where(:surname => "O'Henry")
  Person Load (0.2ms)  SELECT "people".* FROM "people" WHERE
  ("people"."surname" = 'O''Henry')
 => [] 
</code>
<p>Rails automatically applies the appropriate escape characters so that the single quote doesn't cause a SQL
error.</p>
</sect2>
<sect2><title>Beware of SQL Injection Attacks</title>
<p>Improperly escaped user input can cause much more damage than a one-time SQL error: it could potentially wipe out our database. A SQL injection attack is when a malicious person enters text that could evaulate as SQL
commands. Here's an example that shows how the built-in escapting in Rails
protects us:</p>
<code language="session">
>> Person.where(:given_name => "Bret'; DROP TABLE PEOPLE; --")
  Person Load (0.2ms)  SELECT "people".* FROM "people" 
  WHERE ("people"."given_name" = 'Bret''; DROP TABLE PEOPLE; --')
 => []   
</code>
<p>When we specify two name-value pairs in the hash, this is interpreted as an AND operation because that is the most
common.</p>

<code language="session">
>> Person.where(:given_name => 'May', :surname => 'Woo')
  Person Load (0.3ms)  SELECT "people".* FROM "people"
  WHERE ("people"."given_name" = 'May') AND ("people"."surname" = 'Woo')
 => [#<Person id: 1, given_name: "May", surname: "Woo",
created_at: "2011-01-18 05:25:15", updated_at: "2011-01-18 05:25:15">] 
</code>
<p>If we need to do other kinds of operations we need to write a snippet of SQL that will be passed in as the
<ic>WHERE</ic> class of the <ic>SELECT</ic> statements. When writing SQL in our code, it is just as important to escape text
that may have come from an end user. To make our
code invulnerable from a SQL injection attack, we can include a &lquot;?&rquot; anywhere in the string, then pass the
variables to escape and insert as additional parameters:</p>
<code language="irb">
>> first = "May"
 => "May" 
>> last = "Woo"
 => "Woo" 
>> Person.where("given_name = ? AND surname = ?", first, last)
  Person Load (0.2ms)  SELECT "people".* FROM "people" 
  WHERE (given_name = 'May' AND surname = 'Woo')
 => [#<Person id: 1, given_name: "May", surname: "Woo", created_at: 
 "2011-01-18 05:25:15", updated_at: "2011-01-18 05:25:15">] 
</code>
<p>Also, when writing raw SQL, we need to be careful to avoid
database-specific SQL commands or be aware that we are introducing a dependency on our specific database. Most of the
time, we can just use the hash syntax and let Rails worry about the details of the database implementation.</p>
</sect2>
<sect2>
<title>Chaining Methods to Create Complex Queries</title>
<p>We’ve been looking at the results of <method>where</method> right away, but ActiveRecord allows us to defer
executing SQL, so we can build complex queries with multiple Ruby method calls. The
<method>where</method> method along with other modifiers (such as
order, limit, etc.) returns an <class>ActiveRecord::Relation</class>
object.  The SQL query is not actually performed until the result is required – typically when an enumerable method,
such as <method>each</method> is called on the result or when looking as a specific record in irb or by calling
<method>first</method>, <method>last</method>, and <method>all</method>. </p>
<p>For example, we could find everyone with the surname “Woo” and sort the records by “given_name.” Even though these
are two method calls, there will be only one SQL query:</p>
<code language="session">
  Person.where(:surname => "Woo").order(:given_name)
</code>
<p>In the next example we select just one record. A single SQL query which returns a single record from the database: </p>
<code language="session">
  Person.where(:surname => "Woo").order(:given_name).limit(1)
</code>
<p>Order may be called with a string or a symbol for the same result:</p>
<code language="session">
  Person.order("given_name")
</code>
<p>We may optionally specify ASC or DESC when calling order:</p>
<code language="session">
  Person.order("surname DESC").limit(2)
</code>
<p>The ActiveRecord query methods may be called in any sequence:</p>
<code language="session">
  Person.order("given_name").where(:surname => "Woo")
</code>
 
 <p>For more on detail on ActiveRecord queries, you should read the very good Rails
 Guide<footnote><p>http://guides.rubyonrails.org/active_record_querying.html</p></footnote>.</p>

<joeasks id="sb.sidebar.irb_queries">
<title>How can I experiment with combining SQL Queries in irb?</title>
<p>
The ActiveRecord query language returns an ActiveRecord::Relation object, but when we set the ActiveRecord
logger to STDOUT we can see that the query is executed in irb.</p>
<code language="irb">
>> result = Person.where(:given_name => "May")
  Person Load (0.3ms)  SELECT "people".* FROM "people" 
  WHERE ("people"."given_name" = 'May')
 => [#<Person id: 1, given_name: "May", surname: "Woo", present: nil, 
 created_at: "2010-09-06 07:09:18", updated_at: "2010-09-06 07:14:08">] 
</code>
<p>Irb always calls the <method>inspect</method> method on whatever is returned and then prints that to the console.  Inspect will trigger ActiveRelation to execute its SQL query so that it can report the results.  To see this, let’s try:</p>
<code language="irb">
>> result = Person.where(:given_name => "May"); nil
 => nil 
>> result.class
 => ActiveRecord::Relation 
>> result.limit(1)
  Person Load (0.3ms)  SELECT "people".* FROM "people" WHERE 
  ("people"."given_name" = 'May')
 => [#<Person id: 1, given_name: "May", surname: "Woo", present: nil, 
 created_at: "2010-09-06 07:09:18", updated_at: "2010-09-06 07:14:08">] 
</code>
<p>By adding <ic>; nil</ic> to the end of a line in irb, we avoid causing irb to call the <ic>inspect</ic> method on the
result. This keeps the <class>ActiveRecord::Relation</class> object from calling the database, and allows us to
call <method>limit</method> on the object before evaluating it, and therefore, causing a SQL command to be sent
to the database.</p>
</joeasks>
</sect2>
</sect1>


<sect1>
<title>Using ActiveRecord in Our Web App</title>
<p>
  Now that we have a better understanding of ActiveRecord, let’s look at our application again in the browser.  Start the web app:</p>
<code language="session">
$ rails server
</code>
<p>When we browse to <url>http://localhost:3000/people</url> we see a page like <ref linkend="fig.people_index_with_3_records" /></p>

<figure id="fig.people_index_with_3_records">
  <title>People Index Page</title>
  <imagedata fileref="images/class_app/people_index_with_3_records.png" />
</figure>


<p>
  All of the changes that we made in the database appear in the web application, whether we made changes in Rails console by calling methods on ActiveRecord using interactive Ruby or if we made changes using SQL in dbconsole.  These are just three different ways of looking at and interacting with the same database.</p><p>
  We can click &lquot;New Person&rquot;, not fill in anything, click &lquot;Create Person&rquot; and this default Rails
  application will happily create a completely blank record. However, we typically want to set up some checks to make
  sure people add good data.  Since this is such a common part of web applications, Rails makes this easy.</p>
</sect1>
<sect1 id="sec.validations">  
<title>Validations</title>
<p>ActiveRecord has a lot of built-in behavior around making sure data is what we want it to be. After all, this class
is all about data. Its sole purpose is to create a <emph>model</emph> in code that represents one single row in our
database. ActiveRecord includes a whole swath of validation methods solely devoted to making sure our data is what we want it to
be.</p>
<p>
  For example, we may want to make sure that the given name is provided and allow the surname to be optional.  To do
  this, we can make a simple change to the model.  Let’s open <filename>app/models/person.rb</filename>.  We see that
  the implementation is a simple subclass of <class>ActiveRecord::Base</class>.  All of the behavior that we’ve seen so
  far is built into ActiveRecord.  As we’ve seen the attributes are dynamically discovered from the structure of the
  corresponding database table.  If we want to require specific attributes to be present or in a specific format before
  saving, we add a validation to the model:</p>
<code file="code/class_app_new/01a_active_record/app/models/person.rb"/>
<p>With this change, if we attempt to save a blank record, it fails to save and the error will be reported in the web
interface, with a page like <ref linkend="fig.given_name_cant_be_blank" />.</p>
<figure id="fig.given_name_cant_be_blank">
  <title>Validation Error</title>
  <imagedata fileref="images/class_app/given_name_cant_be_blank.png"  />
</figure>

<p>
  Rails provides a lot of behavior in just one line of code.  To understand exactly what is going on, let’s go back to
  the console. Unlike when we are running Rails as a server, in the console our code doesn’t automatically
  reload.  If you had left the console open in another window, you’ll need to restart the console or use the
  <commandname>reload!</commandname> command to reload the Rails app.</p>
<code language="irb">
>> person = Person.new
 => #<Person id: nil, given_name: nil, surname: nil, present: nil, 
 created_at: nil, updated_at: nil> 
>> person.save
 => false 
</code>
<p>
  The <method>save</method> method now returns false.  We can inspect what failed by looking at the errors on the person object. </p>
<code language="irb">
>> person.errors
=>{:given_name=>["can't be blank"]}
</code>
   <p>We can also test for validation errors without attempting to save.  Calling <ic>valid?</ic> will also set errors if one or more validations fail.</p>
<code language="irb">
>> person.valid?
=> false 
</code>
 <p>
  If a validation fails, the <method>save</method> or <method>create</method> methods will return false.  To save the person object and throw an  exception if
  there is an error, we can call the alternate methods: <method> save!</method> or
  <method>create!</method>. An exclamation point, which most people call “bang,” as the last character of a
  method name is a convention in Rails where the method will raise an exception if it fails.</p>
<code language="irb">
> person.save!
ActiveRecord::RecordInvalid: Validation failed: given name can't be blank
...stack trace follows...
</code>
<p>We can see that the bang version of <method>save!</method> raised an error.</p>
</sect1>
<sect1>
<title>Conquering Our Data</title>
<p>We just learned how to create data, give it a home, and find it when we need it.  We now know about SQL injection and how to keep our data safe.  Validations have given us the tools we need to ensure that we are saving well formed data.</p> 

<p>Now that we have a solid base of ActiveRecord skills, we are ready to begin creating ActiveRecord models test first.</p>
</sect1>
</chapter>
