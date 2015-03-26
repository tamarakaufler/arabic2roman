#!/usr/bin/perl 
#===============================================================================
#
#         FILE: arabic2roman.pl
#
#        USAGE: perl arabic2roman.pl  
#
#  DESCRIPTION: converts an Arabic number into Roman numerals
#               works for any number
#       AUTHOR: Tamara Kaufler (), 
#      CREATED: 25/03/15
#===============================================================================

use strict;
use warnings;
use utf8;
use v5.018;

use List::MoreUtils qw(any);
#use Data::Dumper    qw(Dumper);

# ------------- INITIAL SETUP ----------------

my %setup   = (
                leader      => 5,
                oddballs    => [4, 9],
);

## 'leader' and 'number' ... different for different decimal positions
## 'number' is appended/prepended to the 'leader'
##      first key  ... associated with the position of difits in a number to convert
##      second key ... corresponds to the above oddballs array indexes
##                     0: for digits up to 5
##                     1: for digits after 5
my %romans  = (
                0 => {  
                        number => 'I',
                        0  =>   {
                                   leader => 'V',
                                },
                },
                1 => {  
                        number => 'X',
                        0  =>   {
                                   leader => 'L',
                                },
                },
                2 => {  
                        number => 'C',
                        0  =>   {
                                   leader => 'D',
                                },
                },
                3 => {  
                        number => 'M',
                },
);

$romans{0}{1}{leader} = $romans{1}{number};
$romans{1}{1}{leader} = $romans{2}{number};
$romans{2}{1}{leader} = $romans{3}{number};
## for numbers >= 4000 
$romans{3}{0}{leader} = $romans{0}{0}{leader};
$romans{3}{1}{leader} = $romans{0}{0}{leader};

# ------------- INPUT ----------------

    say STDIN "Give me a number to convert to Roman numerals, please:";
    my $number = <STDIN>;
    chomp $number;

    say transform2roman($number);

# ---------- SUBROUTINES --------------

sub transform2roman {
    my ($number) = @_;

    ## reversing so that the array index conveniently matches the setup info
    my @digits = reverse split '', $number;

    ## Roman numerals are pushed onto the arrays, then (reversed) concatenated
    my @numeral_parts = ();

    my @oddballs = @{$setup{oddballs}};
    my $leader   = $setup{leader};

	my $i=0;

    ## process each digit
    ##      push result onto an array
    ##      join to produce the result
	for my $digit (@digits) {

        ## skipping zero, nothing to do
        ## will be handled one level up
        do { $i++; next; } unless $digit;

        my $is_beyond = '';
        my $j = $i;

        ## for numbers > 4000
        ## is_beyond ... to mimics a bar shown about the high Roman number when number > 4000
        ##               represents multiplication by 1000
        if ($i >= 3 && $digit >= 4) {
            my $plunge   = int($i/3);
            $j           = $i - $plunge * 3;
            $is_beyond   = ($plunge % 2) ? '*' : '|';
            $is_beyond   = $is_beyond x $plunge;
        }

        ## the digit is 5
        if ($digit == $leader ) {
            push @numeral_parts,
                 ($is_beyond, 
                  $romans{$j}{0}{leader},
                  $is_beyond);
        ## the digit is 4 or 9
        } elsif (any { $_ == $digit } @oddballs) {
            my $idx = ($digit == $oddballs[0]) ? 0 : 1;
            push @numeral_parts, 
                ($is_beyond, 
                 $romans{$j}{$idx}{leader}, $romans{$j}{number}, 
                 $is_beyond);
        } else {
            ## the digit is greater than 5
            if ($digit > $leader) {
                push @numeral_parts, $is_beyond;
                map { push @numeral_parts, $romans{$j}{number} } 1 .. $digit-$leader;
                push @numeral_parts, $romans{$j}{0}{leader};
                push @numeral_parts, $is_beyond;
            ## the digit up to 5
            } else {
                push @numeral_parts, $is_beyond;
                map { push @numeral_parts, $romans{$j}{number} } 1 .. $digit;
                push @numeral_parts, $is_beyond;
            }
        }
	    $i++; 
	}

    join '', reverse @numeral_parts;
}
