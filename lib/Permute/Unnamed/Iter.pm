package Permute::Unnamed::Iter;

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(
                    permute_unnamed_iter
            );

sub permute_unnamed_iter {
    my @args = @_;
    die "Please supply a non-empty list of arrayrefs" unless @args;

    my $state = [(0) x @args];
    my $state2 = 0; # 0,1,2
    my $iter = sub {
        if (!$state2) { # starting the first time, don't increment state yet
            $state2 = 1;
            goto L2;
        } elsif ($state2 == 2) { # all permutation exhausted
            return undef;
        }
        my $i = $#{$state};
      L1:
        while ($i >= 0) {
            if ($state->[$i] >= $#{$args[$i]}) {
                if ($i == 0) {
                    $state2 = 2;
                    return undef;
                }
                $state->[$i] = 0;
                my $j = $i-1;
                while ($j >= 0) {
                    if ($state->[$j] >= $#{$args[$j]}) {
                        if ($j == 0) { # all permutation exhausted
                            $state2 = 2;
                            return undef;
                        }
                        $state->[$j] = 0;
                        $j--;
                    } else {
                        $state->[$j]++;
                        last L1;
                    }
                }
                $i--;
            } else {
                $state->[$i]++;
                last;
            }
        }
      L2:
        return [ map { $args[$_][ $state->[$_] ] } 0..$#{$state} ];
    };
    $iter;
}

1;
# ABSTRACT: Permute multiple-valued lists

=head1 SYNOPSIS

 use Permute::Unnamed::Iter qw(permute_unnamed_iter);

 my $iter = permute_unnamed_iter([ 0, 1 ], [qw(foo bar baz)]);
 while (my $ary = $iter->()) {
     # ...
 }


=head1 DESCRIPTION

This module is like L<Permute::Unnamed>, except that it offers an iterator
interface.


=head1 FUNCTIONS

=head2 permute_unnamed_iter(@list) => CODE


=head1 SEE ALSO

L<Permute::Unnamed>.

L<Set::CrossProduct>, L<Set::Product>, et al (see the POD of Set::Product for
more similar modules) and CLI L<cross>.

=cut
