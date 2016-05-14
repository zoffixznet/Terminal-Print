use fatal;

use lib './lib';
use Terminal::Print;

my $b = Terminal::Print.new(move-cursor-profile => 'debug');   # TODO: take named parameter for grid name of default grid

$b.initialize-screen;

my sub is-odd( $i ) { not $i %% 2 };

# using underscore for Int's which I plan to use as indexes
# to see how appealing that might be as a personal style guideline.

my sub zig-zag( Int $start_y? ) {
    my $cur_y = $start_y // 0;
    for 1..$b.max-columns -> $x {
        $cur_y++ and next if $cur_y <  0;
        if $cur_y >= $b.max-rows {
            ( $b[$x-1][$cur_y-1] = ' ' and $b.print-cell($x-1,$cur_y-1) )
                        unless so $x-1|$cur_y-1 < 0 or $x > $b.max-columns
                            or $cur_y > $b.max-rows;
            last;
        }

        if is-odd($x) {
            $b[$x][$cur_y] = '_';
            $b.print-cell($x,$cur_y);
            $b[$x-1][$cur_y] = ' ';
            $b.print-cell($x-1,$cur_y);
            $cur_y++;
        } else {
            $b[$x][$cur_y] = '|';
            $b[$x-1][$cur_y-1] = ' ';
            $b.print-cell($x-1,$cur_y-1);
            $b[$x-2][$cur_y-1] = ' ';
            $b.print-cell($x-2,$cur_y-1);
        }
        sleep (^0.9).roll;
    }
}


# ASYNC WORKS
# but this looks stupid.
# TODO: Make this a better example
# await do for ^12 { start { sleep ( 0.1 .. 0.5 ).roll; is-odd($_) ?? zig-zag($_*3) !! zig-zag((-$_)*3) } }

await do for 0...7 { start { is-odd($_) ?? zig-zag($_*3) !! zig-zag(-$_*10) } }
