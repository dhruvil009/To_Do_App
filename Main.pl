use strict;
use warnings FATAL => 'all';
use DBI;
#print("Hello World");

my $name = "Satya";
#print($name);


# Creating the dData BAse connection
my $run_query;
my $driver = "SQLite";
my $database = "ToDos";
my $dsn      = "dbi:$driver:database=$database";
my $user     = "satya";
my $password = "";
my $id = 2;
my $dbh = DBI->connect($dsn, $user, $password, {
    PrintError       => 0,
    RaiseError       => 1,
    AutoCommit       => 1,
    FetchHashKeyName => 'NAME_lc',
});

## Create Table in Perl

my $query_table = qq(CREATE TABLE TODOS( ID INT PRIMARY KEY NOT NULL,
TITLE TEXT NOT NULL,
DESC TEXT NOT NULL
));

#my $run_query = $dbh->do($query_table);
#if($run_query >= 0){
   		#print("Table Succesfully Created");
#}

	
print "Your Action Please : ";
my $act = <STDIN>;


## Insert into the Database

if($act == 0){
	print "Tittle : ";
	my $tittle = <STDIN>;
	chomp $tittle;
	print "Description : ";
	my $desc = <STDIN>;
	chomp $desc;
	print($tittle);
	print($desc);
	#my $query_insert = qq(INSERT INTO TODOS(ID, TITLE, DESC) VALUES ($id, $tittle, $desc));
	#$run_query = $dbh->do($query_insert) or die $DBI::errstr;
	my $sth = $dbh->prepare('INSERT INTO TODOS VALUES (?, ?, ?)');
	$sth->execute($id, $tittle, $desc);
	$id+=1;
	print($id);
	#print($run_query);
}



## Update Operation

if($act == 1){
	print "Tittle : ";
	my $tittle = <STDIN>;
	print "Id : ";
	my $change = <STDIN>;
	my $query_update = qq(UPDATE TODOS SET TITLE = $tittle where id = $change;);
	$run_query = $dbh->do($query_update);
}

## Delete Operation In Perl

if($act == 2){
	print "Id : ";
	my $change = <STDIN>;
	my $query_delete = qq(DELETE FROM TODOS WHERE ID = $change);
	$run_query = $dbh->do($query_delete);
}


## Select Query
my $query_select = qq(SELECT TITLE, DESC FROM TODOS);
my $prepare = $dbh->prepare($query_select);
my $execute = $prepare->execute();

while(my @row = $prepare->fetchrow_array()){
    print("Title: ". $row[0]."Description: ". $row[1]."\n");
}