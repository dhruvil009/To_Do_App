use strict;
use warnings FATAL => 'all';
use DBI;
#print("Hello World");

my $name = "Satya";
#print($name);


# Creating the dData BAse connection
my $driver = "SQLite";
my $database = "ToDos";
my $dsn      = "dbi:$driver:database=$database";
my $user     = "satya";
my $password = "";
my $dbh = DBI->connect($dsn, $user, $password, {
    PrintError       => 0,
    RaiseError       => 1,
    AutoCommit       => 1,
    FetchHashKeyName => 'NAME_lc',
});

## Create Table in Perl

my $query_table = qq(CREATE TABLE TODOS( ID INT PRIMARY KEY NOT NULL,
TITLE TEXT NOT NULL,
DESC TEXT,
COMPLETED CHAR(1) DEFAULT 'N' CHECK(COMPLETED = 'Y' OR  COMPLETED = 'N'),
DEADLINE DATE
));

#my $run_query = $dbh->do($query_table);

#if($run_query >= 0){
#    print("Table Succesfully Created");
#}


## Insert into the Database

#my $query_insert = qq(INSERT INTO TODOS(ID, TITLE, DESC) VALUES (6, 'Call Papa', '-'));
#my $run_query = $dbh->do($query_insert) or die $DBI::errstr;
#print($run_query);




## Update Operation

my $query_update = qq(UPDATE TODOS SET TITLE = 'Call Mom' where id = 5;);
#my $run_query = $dbh->do($query_update);

## Delete Operation In Perl

my $query_delete = qq(DELETE FROM TODOS WHERE ID = 5);
#my $run_query = $dbh->do($query_delete);


## Select Query
#my $query_select = qq(SELECT TITLE, DESC FROM TODOS);
#my $prepare = $dbh->prepare($query_select);
#my $execute = $prepare->execute();

#while(my @row = $prepare->fetchrow_array()){
 #   print("Title: ". $row[0]."\n");
#}

#print("Enter 1: To Fetch All Tasks:");
#print("Enter 2: To Insert a New Task:");
#print("Enter 3: To Delete a Task:");
#print("Enter 4: To Update a Task:");
#print("Enter 5: To Mark a Task as Complete:");
#print("Enter 6: To UnMark a Task as Complete:");
#print("Enter 7: To Fetch all Remaining Tasks:");
#print("Enter 8: To Fetch all Completed Tasks:");
#print("Enter 9: To Fetch all Reminders:");

my $action = <STDIN>;
if($action == 1){
    printf("Fetching all Tasks\n");
    my $query_select = qq(SELECT * FROM TODOS);
    my $prepare = $dbh->prepare($query_select);
    my $execute = $prepare->execute();

    while(my @row = $prepare->fetchrow_array()){
       print("ID: ". $row[0]."\n");
        print("Title: ". $row[1]."");
        print("Desc: ". $row[2]."");
        print("Task Completed: ". $row[3]."\n");
        print("DeadLine: ". $row[4].".\n");
        print("------------------------\n");
    }
}elsif($action == 2){
    printf("Inserting a new task\n");
    my $query_insert = $dbh->prepare('INSERT INTO TODOS VALUES (?, ?, ?, ?, ?)');
    my $id = time(); #Time in Milliseconds
    my $title = <STDIN>;
    #$title = chmod($title);
    my $desc = <STDIN>;
    #$desc = chmod($desc);
    my $completed = 'N';
    my $deadline = <STDIN>;
    chomp $deadline;
    $query_insert->execute($id, $title, $desc, $completed, $deadline) or die $DBI::errstr;
}elsif($action == 3){
    my $id = <STDIN>;
    chomp $id;
    printf("Deleting a task with ID = ".$id. "\n");
    my $query_delete = qq(DELETE FROM TODOS WHERE ID = ?);
    my $prepare = $dbh->prepare($query_delete);
    my $execute = $prepare->execute($id);
}elsif($action == 4){
    my $id = <STDIN>;
    chomp $id;
    my $title = <STDIN>;
    my $desc = <STDIN>;
    my $deadline = <STDIN>;
    chomp $deadline;
    printf("Updating a task with ID = ".$id. "\n");
    my $query_delete = qq(UPDATE TODOS SET TITLE = ?, DESC = ?, DEADLINE = ? WHERE ID = ?);
    my $prepare = $dbh->prepare($query_delete);
    my $execute = $prepare->execute($title, $desc, $deadline, $id);
}elsif($action == 5){
    my $id = <STDIN>;
    chomp $id;
    printf("Task Completed with ID = ".$id. "\n");
    my $query_select = qq(UPDATE TODOS SET COMPLETED = 'Y' WHERE ID = ?);
    my $prepare = $dbh->prepare($query_select);
    my $execute = $prepare->execute($id);
}elsif($action == 6){
    my $id = <STDIN>;
    chomp $id;
    printf("Task Remaining with ID = ".$id."\n");
    my $query_select = qq(UPDATE TODOS SET COMPLETED = 'N' WHERE ID = ?);
    my $prepare = $dbh->prepare($query_select);
    my $execute = $prepare->execute($id);
}elsif($action == 7){
    printf("Fetching all Remaining Tasks\n");
    my $query_select = qq(SELECT * FROM TODOS WHERE COMPLETED = 'N');
    my $prepare = $dbh->prepare($query_select);
    my $execute = $prepare->execute();

    while(my @row = $prepare->fetchrow_array()){
        print("ID: ". $row[0]."\n");
        print("Title: ". $row[1]."");
        print("Desc: ". $row[2]."");
        print("Task Completed: ". $row[3]."\n");
        print("DeadLine: ". $row[4].".\n");
        print("------------------------");
    }
}elsif($action == 8){
    printf("Fetching all Completed Tasks\n");
    my $query_select = qq(SELECT * FROM TODOS WHERE COMPLETED = 'Y');
    my $prepare = $dbh->prepare($query_select);
    my $execute = $prepare->execute();

    while(my @row = $prepare->fetchrow_array()){
        print("ID: ". $row[0]."\n");
        print("Title: ". $row[1]."");
        print("Desc: ". $row[2]."");
        print("Task Completed: ". $row[3]."\n");
        print("DeadLine: ". $row[4].".\n");
        print("------------------------\n");
    }
}elsif($action == 9){
    printf("Fetching all Tasks");
    my $query_select = qq(SELECT * FROM TODOS WHERE DEADLINE < (?) AND COMPLETED = 'N');
    my $prepare = $dbh->prepare($query_select);
    my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
    $year = $year + 1900; # Year count since 1900
    print(" having Deadline Before: $mday-$months[$mon]-$year\n");
    my $execute = $prepare->execute("$mday-$months[$mon]-$year");

    while(my @row = $prepare->fetchrow_array()){
        print("ID: ". $row[0]."\n");
        print("Title: ". $row[1]."");
        print("Desc: ". $row[2]."");
        print("Task Completed: ". $row[3]."\n");
        print("DeadLine: ". $row[4].".\n");
        print("------------------------\n");
    }
}
