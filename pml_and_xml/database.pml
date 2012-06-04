<appendix>
<title>Database Primer</title>
<p>We rarely write SQL directly in our Rails code, but to understand what our app is really doing in the
database, we’ll want to occasionally look at the SQL called by our app.</p>
<sect1 id="sec.sql">
<title>Understanding SQL</title>
<p> If you don’t already know SQL, refer to <ref
linkend="fig.database-commands" /> for a quick cheat sheet of the basic commands.</p>
<figure id="fig.database-commands">
  <title>Database Commands</title>
  <imagedata fileref="images/database-commands.png" />
</figure>
</sect1>
<sect1 id="sec.dbconsole">
<title>The <commandname>dbconsole</commandname> command</title>
<p>One of the Rails commands <ic>rails dbconsole</ic> invokes our database console. Every database comes with a command
line tool which has a unique command to invoke it and sometimes different names for command line options to specify the user, password and database name. The dbconsole command simply calls the appropriate database console app. So for SQLite, rails dbconsole is the same as:</p>
<code language="session">
$ SQLite3 <my_development_database>
</code>
<p>and for MySql, it is the same as:</p>
<code language="session">
$mysql –u<name> –p<password> <my_development_database> 
</code>
<p>The <commandname>dbconsole</commandname> is a very useful tool for inspecting the contents of the database when we
are debugging or want to take a quick look at what tables and schema exist for our app.</p>
</sect1>
<sect1>
<title>Using a Different Database</title>
<p>If you want to use Rails with a different database, there are shortcuts for creating different configuration files for the most commonly used databases. For example, to generate a Rails application with a default configuration for MySql, you would use the following command:</p>
<code language="session">
$ rails new –d mysql app_name
</code>
<p>The contents of the <filename>database.yml</filename> file is the only difference in the generated app when calling “rails new” with the –d option. </p>

<p>The following databases are supported:</p>
<table style="outerlines">
  <thead>
    <col><p>Database</p></col>
    <col><p>Configuration Option</p></col>
  </thead>
  <row> <col><p>SQLite</p></col><col><p>default</p></col> </row>
  <row> <col><p>MySQL</p></col><col><p>-d mysql</p></col> </row>
  <row> <col><p>PostgreSQL</p></col><col><p>-d postgresql</p></col> </row>
  <row> <col><p>Oracle</p></col><col><p>-d oracle</p></col> </row>
  <row> <col><p>DB2</p></col><col><p>-d ibm_db</p></col> </row>
  <row> <col><p>Frontbase</p></col><col><p>-d frontbase</p></col> </row>
  <row> <col><p>SQL Server</p></col><col><p>manual configuration required</p></col> </row>
  <row> <col><p>Sybase</p></col><col><p>manual configuration required</p></col> </row>
</table>

<p>When we use a different database, we need to install the database-specific driver so that our Ruby code can talk to
the database. Each of the supported databases requires a separate gem to connect to that database from Ruby.</p>
</sect1>
</appendix>
