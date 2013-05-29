package DB;

use Moose;

use DBI;
use namespace::autoclean;

has	'Database'			=> (
								is			=>	'rw',
								isa			=>	'Str',
								default		=>	'TestDB',
							);
					
has	'DBH'				=>	(
								is			=>	'rw',
								isa			=>	'Object',
								builder		=>	'_build_DBH',
								lazy		=>	1,
							);
							
has	'LoginCredentials'	=>	(
								is			=>	'ro',
								isa			=>	'Hashref',
								builder		=>	'_build_LoginCredentials',
								lazy		=>	1,
							);
							
							
sub	insert_record {
	
	my ( $self, $table, $values ) = @_; 
	my @fields = keys %$values;

	my $sth = $self->DBH->prepare( "INSERT INTO $table (". join(", ", @fields) .") VALUES (". join(", ", ("?")x@fields) .")" );	
	$sth->execute( @{ $values }{ @fields }  );
}


sub	update_record {
	
	my ( $self, $table, $values, $where ) = @_; 
	my @fields = keys %$values;

	my $sth = $self->DBH->prepare( "UPDATE $table SET ". join(", ", map { "$_ = '" . $values->{ $_ } . "'" } @fields) 
									." WHERE ". join(" AND ", map { "$_ = '". $where->{ $_ } . "'" } keys %$where) );
	$sth->execute();
}


sub select_record {

	my ( $self, $table, $values, $where ) = @_;
	my $sth = $self->DBH->prepare( "SELECT ". join(", ", @$values) . " FROM $table " 
									." WHERE ". join(" AND ", map { "$_ = '". $where->{ $_ } . "'" } keys %$where) );
	
	$sth->execute();
	return $sth;
}


sub	delete_record {
	
	my ( $self, $table, $where ) = @_; 

	my $sth = $self->DBH->prepare( "DELETE FROM $table WHERE ". join(" AND ", map { "$_ = '". $where->{ $_ } . "'" } keys %$where) );	
	$sth->execute();
}
			

			
##################################################
#												 
#			Private Methods						 
#												 
##################################################



sub _build_DBH {
	
	my $self = shift;
	return DBI->connect("DBI:SQLite:dbname=TestDB.sqlite", "", "");

}

sub _build_LoginCredentials {


	return	{
				'TestDB'		=>	{
										'User'	=>	'user123',
										'Pass'	=>	'pass123',
									},
			};
}

no Moose;
__PACKAGE__->meta->make_immutable;