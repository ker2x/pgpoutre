#!/usr/bin/perl

use strict;
use Getopt::Long;
use DBI;
use Thread::Pool;


my $regcommand = "SELECT|DISCARD";
my $stopword = "/.*replication.*/";
my $sqlline;
my $sqlcommand;

sub usage()
{
	print "--help, -?   : print this help\n";
	print "--file, -f   : file to parse\n";
	print "--user, -u   : postgresql user\n";
	print "--port, -p   : postgresql port (default : 5432)\n";
	print "--host, -h   : postgresql host\n";
	print "--pass, -P   : postgresql password\n";
	print "--db,   -d   : postgresql database\n";
	print "--verbose,-v : enable verbose mode\n";
	exit();
}

my $file;
my $user;
my $port;
my $db;
my $verbose;
my $host;
my $password;

GetOptions(	"help|?" => sub { usage() }, 
		"file|f=s" => \$file,
		"user|u=s" => \$user,
		"port|p:i" => \$port,
		"host|h=s" => \$host,
		"pass|P:s" => \$password,
		"db|D=s" => \$db,
		"verbose|v" => \$verbose
		) or usage();

my $dbsource = "dbi:Pg:dbname=$db;host=$host;port=$port";
my $rcounter = 1;
my $logcounter = 0;
my $request = "";
my $sth;
my @result;
my $dbh;

#OPENING FILE
print "Opening $file ...\n";
open(DBFILE,$file) or die "can't open : $file\n";
print "$file opened \\o/\n";


my $pool = Thread::Pool->new(
	{
	workers => 16,
	do => \&do,
	pre => \&pre,
	post => \&post,
	maxjobs => 1000,
	}
);

my $start_time = time();
print time() . "\n";
sleep(1);
$/ = "LOG:  statement:";

while(<DBFILE>)
{
	while($pool->todo > 10000) { sleep(1) }
	chomp $_;
	s/\n+/ /g; s/\t+/ /g;

	next if(m/$stopword/i);
	$sqlline = $_;
	$sqlline =~ m/(\w+)\s*/;
	$sqlcommand = $1;
	if($sqlcommand =~ m/$regcommand/i) { 
		$pool->job($1."\n");
		$rcounter++;
	
		if ($rcounter % 1000 == 0) 
		{ 
			print "requete/s = " . $rcounter / (time() - $start_time) . "\n";
			print "pool size : ". $pool->todo ."; compteur : $rcounter \n"; 
		}
	}
}
print "$rcounter\n";

#la fin
close(DBFILE);



sub do
{
	my $boulot = shift;
	$sth = $dbh->prepare($boulot.";");
	$sth->execute;
	#$sth->do($boulot.";");
}

sub pre
{
	#CONNECTING TO DB
	print "Connecting to : $dbsource;user=$user ...\n";
	$dbh = DBI->connect($dbsource,$user,$password) or die "Impossible de se connecter a la base\n";
	print "Connected \\o/\n";
}

sub post
{
	$dbh->disconnect();
}

