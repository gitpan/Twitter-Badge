# Makefile for Twitter::Badge

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Twitter::Badge',
    AUTHOR            => 'Arul John <arul@cpan.org>',
    VERSION           => '0.02',
    PREREQ_PM         => {
        'LWP::UserAgent' => 0,
    },
    'EXE_FILES' => [],
    'PL_FILES' => {}
);
