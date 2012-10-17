use 5.8.0;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Twitter::Badge',
    license             => 'perl',
    dist_author         => q{Arul John <arul@cpan.org>},
    dist_version_from   => 'lib/Twitter/Badge.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => '5.8.0',
	'LWP::UserAgent' => '5.8',
    },
    add_to_cleanup      => [ 'Twitter-Badge-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
