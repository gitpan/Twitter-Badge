# Makefile for Twitter::Badge

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Twitter::Badge',
    AUTHOR            => 'Arul John <arul@cpan.org>',
    VERSION_FROM      => 'lib/Twitter/Badge.pm',
    PREREQ_PM         => {
        'LWP::UserAgent' => 0,
    },
    'EXE_FILES' => [],
    'PL_FILES' => {}
);
