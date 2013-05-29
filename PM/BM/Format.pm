package Format;

use strict;
use Moose;

use Term::ReadKey;

my $clear_cmd = $^O eq 'MSWin32' ? 'cls' : 'clear';

sub clear_screen {

	system "$clear_cmd";
}

sub resize_screen {
	
	@ENV{ 'LINES' , 'COLUMNS' } = ( 300, 300 );
}

format MYFORMAT =

===================================

Here is the text I want to display.

===================================

.

no Moose;
__PACKAGE__->meta->make_immutable;