# Testing the Twitter::Badge class

use Test;
BEGIN { plan tests => 1 };
use Twitter::Badge;
ok(1); # If we made it this far, we're ok.

#################################
# Arul's Tests for Twitter::Badge
#################################

use Data::Dumper;

my $twitter = Twitter::Badge->new(); # create an empty Twitter::Badge object

# Setting Twitter ID
$twitter->id(14512139);              # setting ID to 14512139
$twitter->fetch();                   # fetch Twitter info [with that Twitter ID]
print $twitter->name.' says: '.$twitter->text."\n";
print $twitter->name.' posted on '.$twitter->created_at."\n"; 

# Setting Twitter screen name
$twitter->screen_name('aruljohn');   # setting screen name to 'aruljohn' [it updates the Twitter ID]
$twitter->fetch();                   # fetch Twitter info [with that Twitter screen name]
print $twitter->name.' says: '.$twitter->text."\n" if defined $twitter->text;
print $twitter->name.' posted on '.$twitter->created_at."\n" if defined $twitter->created_at; 

# Create object with screen name
$twitter = Twitter::Badge->new(screen_name => 'justjul'); # create the object
$twitter->fetch();
print $twitter->name.' says: '.$twitter->text."\n" if defined $twitter->text;
print $twitter->name.' posted on '.$twitter->created_at."\n" if defined $twitter->created_at; 
print $twitter->name.' has '.$twitter->followers_count." followers\n\n" if defined $twitter->followers_count;

print Dumper($twitter);
