#!/usr/bin/env perl
use strict; 
use warnings;
use Test::More;

sub email_validation {
    my $testing_email = shift;
    return 1 if $testing_email =~ m/
                                    (   
                                        (
                                            ^([a-z0-9]+)|
                                            ^(\"(?!\s)([a-z0-9\s]+)\")|
                                            ^([a-z0-9]+\+[a-z0-9]+)
                                        )
                                        \@[a-z0-9-]+?\.[a-z]+$
                                    )
                                    |
                                    (
                                        (
                                            ^([a-z]+)|
                                            ^(\"[a-z]+\s[a-z]+\")
                                        )
                                        \s+\<
                                        (
                                            (
                                                ([a-z0-9]+)|
                                                (\"(?!\s)([a-z0-9\s]+)\")|
                                                ([a-z0-9]+\+[a-z0-9]+)
                                            )
                                            \@[a-z0-9-]+?\.[a-z]+
                                        )
                                        \>$
                                    )
    /ix;
    return 0;
}
my @valid_emails   = ('mail@example.com',        'Name <mail@example.com>',        '"Another Name" <mail@example.com>',
                      'mail+ext@example.com',    'Name <mail+ext@example.com>',    '"Another Name" <mail+ext@example.com>',
                      '"l o g i n"@example.com', 'Name <"l o g i n"@example.com>', '"Another Name" <"l o g i n"@example.com>',
                      '"login"@example.com',     'Name <"login"@example.com>',     '"Another Name" <"login"@example.com>');

my @invalid_emails = ('ma il@example.com',                  'mail @example.com', 
                      'mail@ example.com',                  'mail@exa mple.com', 
                      'mail@example .com',                  'mail@example.co/m',
                      'Name<mail@example.com>',             'Name mail@example.com>', 
                      'Name <mail@example.com',             'Name mail@example.com',
                      '"Ano ther Name" <mail@example.com>', '"Another Name"<mail@example.com>',
                      '"Another Name <mail@example.com>',   'Another Name" <mail@example.com>',
                      'Another Name <mail@example.com>',    '"Another "Name" <mail@example.com>',
                      'ma+il+ext@example.com',
                      'l o g i n"@example.com',             '"l o g i n@example.com', 
                      '"l o "g i n"@example.com',           'l o g i n@example.com',
                      'login"@example.com',                 '"login@example.com',
                      '"log"in"@example.com',               '"login@example.com"');                    

print "valid emails check\n";
for my $test_email (@valid_emails) {
    is(email_validation($test_email), 1, $test_email);
}

print "invalid emails check\n";
for my $test_email (@invalid_emails) {
    is(email_validation($test_email), 0, $test_email);
}

done_testing(scalar @valid_emails + scalar @invalid_emails);