#
# Configuration file for PgPoutre
#


use strict;
use warning;

# Parser configuration
$PGPConfig::STOPWORD = "regexp";
$PGPConfig::COMMAND_FILTER = "SELECT|DISCARD";

# Thread configuration
$PGPConfig::WORKERS = 16;
$PGPConfig::MAX_JOBS = 1000;
$PGPConfig::CHECKPOINT = 1000;

# Default database configuration
$PGPConfig::DB_HOST = "localhost";
$PGPConfig::DB_PORT = 5432;
$PGPConfig::DB_USER = "foo";
$PGPConfig::DB_PASS = "bar";

1;
