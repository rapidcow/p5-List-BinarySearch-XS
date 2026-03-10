#!perl
#
# GitHub issue #3:
# https://github.com/daoswald/List-BinarySearch-XS/issues/3
#
use strict;
use warnings;
use List::BinarySearch::XS qw(binsearch binsearch_pos);
use Test::More tests => 4;

# Null coalescence -- to suppress the warning that
# would been emitted when comparing an undef element.
# Avoid '//' for Perls older than 5.10.  Code derived
# from <https://stackoverflow.com/a/3795099/19411800>
sub _coal {
	my $var = shift;
	defined $var ? $var : shift;
}

{
	my @array;
	$array[1] = 'A';
	my $index = binsearch { _coal($a, '') cmp _coal($b, '') } 'B', @array;
	is $index, undef,     "binsearch found no match";
	# The original array should not be altered, as we
	# pass lval=0 to Perl_av_fetch.
	ok !exists $array[0], "binsearch did not store undef into array[0]";
}

{
	my @array;
	$array[1] = 'A';
	my $index = binsearch_pos { _coal($a, '') cmp _coal($b, '') } 'B', @array;
	cmp_ok $index, '==', 2, "binsearch_pos points to one index past end";
	ok !exists $array[0], "binsearch_pos did not store undef into array[0]";
}
