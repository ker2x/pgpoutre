#
# Configuration file for PgPoutre
#


use strict;
use warning;

# Parser configuration
$PGPConfig::STOPWORD = "regexp";
$PGPConfig::COMMAND_FILTER = "SELECT|DISCARD";

# Thread configuration
$PGPConfig::WORKERS = 1;
$PGPConfig::POOL_SIZE = 2;
$PGPConfig::CHECKPOINT = 1000;

# Default database configuration
$PGPConfig::DB_HOST = "localhost";
$PGPConfig::DB_PORT = 5432;
$PGPConfig::DB_USER = "foo";
$PGPConfig::DB_PASS = "bar";


#################################
# DO NOT CHANGE BELOW THAT LINE #
# Unless you really know what   #
# you're doing  :)              #
#################################

sub CheckPGPConfig {
	
	my $pause = 0;

	print "Checking configuration file ...\n";
	print "-------------------------------\n";
	
	#STOPWORD
	die "Eek ! STOPWORD not defined !\n" unless defined($PGPConfig::STOPWORD);
	print "STOPWORD : $PGPConfig::STOPWORD\n";

	#COMMAND_FILTER
	die "Eek ! COMMAND_FILTER not defined !\n" unless defined($PGPConfig::COMMAND_FILTER);
	print "COMMAND_FILTER : $PGPConfig::COMMAND_FILTER\n";

	#WORKERS
	die "Eek ! WORKERS not defined !\n" unless defined($PGPConfig::WORKERS);
	die "WORKERS must be > 0\n" unless ($PGPConfig::WORKERS > 0);
	print "WORKERS : $PGPConfig::WORKERS\n";

	#POOL_SIZE
	die "Eek ! POOL_SIZE not defined !\n" unless defined($PGPConfig::POOL_SIZE);
	die "POOL_SIZE must be > 0\n" unless ($PGPConfig::POOL_SIZE > 0);
	print "POOL_SIZE : $PGPConfig::POOL_SIZE\n";

	#POOL_SIZE > WORKERS
	if ($PGPConfig::POOL_SIZE < $PGPConfig::WORKERS)
	{
		print "WARNING : POOL_SIZE($PGPConfig::POOL_SIZE) should be superior to WORKERS($PGPConfig::WORKERS) !\n";
		$pause++;
	}

	#CHECKPOINT
	die "Eek ! CHECKPOINT not defined !\n" unless defined($PGPConfig::CHECKPOINT);
	if($PGPConfig::CHECKPOINT < 0)
	{
		print "NOTICE : CHECKPOINT = $PGPConfig::CHECKPOINT ... disabled\n";
		$pause++;
	} else {
		print "CHECKPOINT : $PGPConfig::CHECKPOINT\n";
	}

	#DB_HOST
	die "Eek ! DB_HOST not defined !\n" unless defined($PGPConfig::DB_HOST);

	#DB_PORT
	die "Eek ! DB_PORT not defined !\n" unless defined($PGPConfig::DB_PORT);
	die "DB_PORT must be > 0\n" unless ($PGPConfig::DB_PORT > 0);
	die "DB_PORT must be < 65536\n" unless ($PGPConfig::DB_PORT < 65536);

	#DB_USER
	die "Eek ! DB_USER not defined !\n" unless defined($PGPConfig::DB_USER);

	#DB_PASS
	die "Eek ! DB_PASS not defined !\n" unless defined($PGPConfig::DB_PASS);



}

1;
