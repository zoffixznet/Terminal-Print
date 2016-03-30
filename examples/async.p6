use v6;

use lib './lib';
use Terminal::Print;

my $t = Terminal::Print.new;   # TODO: take named parameter for grid name of default grid

$t.initialize-screen;

my @indices = $t.grid-indices;

# Other attempts that do not work very well
#await do for ^$t.max-rows -> $x {
#await do for ^10 -> $x {

my @alphabet = 'j'..'z';

my $rotor := (^$t.max-rows).rotor(10, :partial)>>.Array;
my $thread = 0;

await do for $rotor -> @ys {
    my $char := @alphabet.pick;
    my $p = start {
        my @xs = ^3 %% 2 ?? (^$t.max-columns).reverse !! ^$t.max-columns;
        my @ys-rev = @ys.reverse;
        for @xs -> $x {
            my @yss := $thread %% 2 ?? @ys-rev !! @ys;
            for @yss -> $y {
                $t.print-cell($x,$y,$char);
            }
        }
    }
    $p
}

$t.shutdown-screen;
