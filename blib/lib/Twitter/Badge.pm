# $Id$

package Twitter::Badge;

use strict;
use warnings;
use Carp;
use LWP::UserAgent;

use version; our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %args = @_;
    $args{screen_name} = undef unless defined $args{screen_name};
    $args{id} = undef unless defined $args{id};
    $args{ua} = 'Mozilla/4.0' unless defined $args{ua};
    $args{name} = undef;
    $args{text} = undef;
    $args{profile_image_url} = undef;
    $args{followers_count} = undef;
    $args{created_at} = undef;
    return bless {%args}, $class;
}

sub get_id_from_screen_name {
    my $self = shift;
    my $screen_name = shift;
    $self->{screen_name} = $screen_name;
    my $ua = LWP::UserAgent->new(agent => $self->{ua});
    my $response = $ua->get('http://twitter.com/'.$self->{screen_name});
    if ($response->is_success) {
        my $html = $response->content;
        if ($html =~ m!<link rel="alternate".+?href="http://twitter.com/statuses/user_timeline/(\d+)\.rss" />!){
            $self->{id} = $1;
        } else {
            undef $self->{id};
        }
    } else {
        undef $self->{id};
    }
    return $self->{id};
}

sub fetch {
    my $self = shift;
    if (!defined($self->{id})) {
        return $self if not defined $self->{screen_name};
        $self->{id} = $self->get_id_from_screen_name($self->{screen_name});
        print "fetch() - screen name is : ".$self->{screen_name}."\n"; # DEBUG
        print "fetch() - ID is : ".$self->{id}."\n"; # DEBUG
        return if not defined $self->{id};
    }
    my $ua = LWP::UserAgent->new(agent => $self->{ua});
    my $response = $ua->get('http://twitter.com/statuses/user_timeline/'.$self->{id}.'.xml?count=1');
    if ($response->is_success) {
        my $xml = $response->content;
        ($self->{name}) = ($xml =~ m!<name>(.*)</name>!);
        ($self->{screen_name}) = ($xml =~ m!<screen_name>(.*)</screen_name>!);
        ($self->{text}) = ($xml =~ m!<text>(.*)</text>!);
        ($self->{profile_image_url}) = ($xml =~ m!<profile_image_url>(.*)</profile_image_url>!);
        ($self->{followers_count}) = ($xml =~ m!<followers_count>(.*)</followers_count>!);
        ($self->{created_at}) = ($xml =~ m!<created_at>(.*)</created_at>!);
    } else {
        croak $response->status_line;
    }
    return $self;
}

sub screen_name {
    my $self = shift;
    if (@_) {
        $self->{screen_name} = shift;
        $self->{id} = $self->get_id_from_screen_name($self->{screen_name});
    }
    return $self->{screen_name};
}

sub id {
    my $self = shift;
    if (@_) { $self->{id} = shift; }
    return $self->{id};
}

sub ua {
    my $self = shift;
    if (@_) { $self->{ua} = shift; }
    return $self->{ua};
}

sub name {
    my $self = shift;
    return $self->{name};
}

sub text {
    my $self = shift;
    return $self->{text};
}

sub profile_image_url {
    my $self = shift;
    return $self->{profile_image_url};
}

sub followers_count {
    my $self = shift;
    return $self->{followers_count};
}

sub created_at {
    my $self = shift;
    return $self->{created_at};
}

1;
__END__

=head1 NAME

Twitter::Badge - Perl module that displays the current Twitter information of a user

=head1 SYNOPSIS

  use Twitter::Badge;

  # If you know the Twitter ID
  my $id = 14512139;                            # define the Twitter ID
  my $twitter = Twitter::Badge->new(id => $id); # create the object for that ID
  $twitter->fetch();                            # get information for this ID

  # Display status
  print $twitter->name.' says - '.$twitter->text."\n"; # display status
  print $twitter->name.' has '.$twitter->followers_count." followers\n"; # display followers
  # .. and so on

=head1 DESCRIPTION

Twitter::Badge is a class that retrieves the Twitter information for the user's ID or screen name.

=head1 METHODS

=head2 new(%args)

The method C<new(%args)> creates and returns a new C<Twitter::Badge> object.
It takes either zero parameters or a hash containing at least one of the following:

    KEY                  DEFAULT VALUE
    ===========          =============
    id                   undef
    screen_name          undef
    ua                   Mozilla/4.0

=head3 Summary of parameters

=over 4

=item * id

[OPTIONAL] This parameter is the Twitter ID, a number that is associated with the Twitter screen name.

=item * screen_name

[OPTIONAL] This parameter is the Twitter screen name.

=item * ua

[OPTIONAL] This parameter is the User-Agent string that is included in the request to Twitter.
You can find a list of user-agent strings at L<http://aruljohn.com/ua/>

=back

=head2 fetch()

The method C<fetch()> fetches the following information from the user's corresponding Twitter account:

=over 4

=item * id

=item * name

=item * text

=item * profile_image_url

=item * followers_count

=item * created_at

=back

=head2 screen_name()

The method C<screen_name()> returns the screen_name value. If a parameter is passed into it, screen_name is set to that value.

This print the current Twitter screen name.
  print $twitter->screen_name

This will set the current Twitter screen name to 'aruljohn'.
  $twitter->screen_name('aruljohn');

=head2 ua()

The method C<ua()> returns the User-Agent string value. If a parameter is passed into it, ua is set to that value.
You can find a list of User-Agent strings at L<http://aruljohn.com/ua/>

=head2 name()

The method C<name()> returns the C<name> value retrieved from the account specified by the Twitter ID.

=head2 text()

The method C<text()> returns the C<text> value retrieved from the account specified by the Twitter ID.

=head2 profile_image_url()

The method C<profile_image_url()> returns the C<profile_image_url> value retrieved from the account specified by the Twitter ID

=head2 followers_count()

The method C<followers_count()> returns the C<followers_count> value retrieved from the account specified by the Twitter ID.

=head2 created_at()

The method C<created_at()> returns the C<created_at> value - the time the user updated his/her Twitter status.

=head1 EXAMPLES

=head3 Creating badge with no parameters

  use Twitter::Badge;

  my $twitter = Twitter::Badge->new(); # create an empty Twitter::Badge object

  # Setting Twitter ID
  $twitter->id(14512139);              # setting ID to 14512139
  $twitter->fetch();                   # fetch Twitter info [with that Twitter ID]
  print $twitter->name.' says: '.$twitter->text."\n";
  print $twitter->name.' posted on '.$twitter->created_at."\n"; 

=head3 Creating badge with screen name as parameter

  use Twitter::Badge;

  # Create object with screen name
  $twitter = Twitter::Badge->new(screen_name => 'Guz_'); # create the object
  $twitter->fetch();
  print $twitter->name.' says: '.$twitter->text."\n";
  print $twitter->name.' posted on '.$twitter->created_at."\n"; 

=head3 Creating badge with User-Agent as parameter

  use Twitter::Badge;

  # Create object with User-Agent
  $twitter = Twitter::Badge->new(ua => 'Mozilla/6.0 (Twitterbot)'); # create the object
  $twitter->id(14512139);
  $twitter->fetch();
  print $twitter->name.' says: '.$twitter->text."\n";
  print $twitter->name.' posted on '.$twitter->created_at."\n\n"; 

  # Change screen name
  $twitter->screen_name('justjul');
  $twitter->fetch();
  print $twitter->name.' says: '.$twitter->text."\n";
  print $twitter->name.' has '.$twitter->followers_count." followers\n\n"; 

You can use the Data::Dumper module to check the contents of C<$twitter> at any time.

  use Data::Dumper;

  # other code comes here

  print Dumper($twitter);

=head1 BUGS

There are no known bugs as of now.

But since the Twitter::Badge module is built on the XML file that Twitter generates - and this is bound to change over a period of time - some methods may stop working. When that happens, I will update this module. I will also update the module if Twitter includes more useful content in its XML file, and on user requests. My email address for contact is E<lt>arul@cpan.orgE<gt>

=head1 SEE ALSO

Twitter API Documentation - L<http://groups.google.com/group/twitter-development-talk/web/api-documentation>

=head1 AUTHOR

Arul John - L<http://aruljohn.com>

=head1 COPYRIGHT AND LICENCE

Copyright (C) 2008 by Arul John

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.6.0 or,
at your option, any later version of Perl you may have available.

