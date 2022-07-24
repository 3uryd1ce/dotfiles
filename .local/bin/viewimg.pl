#!/usr/bin/env perl
# Copyright (c) 2022 Ashlen <eurydice@riseup.net>

# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.

# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use strict;
use warnings;

use File::Basename;
use File::Temp;
use HTTP::Tiny;
use URI;
use v5.10; # say

my $program_name = fileparse $0;

sub usage {
	die <<EOF;
$program_name [URL]
EOF
}


my $uri = URI->new(shift) or die "$program_name needs a URL.\n";
$uri->scheme eq 'https' or die "$program_name only supports the 'https' scheme.\n";

system 'command -v sxiv >/dev/null 2>&1';
die "sxiv is not installed.\n" if $?;

die "$program_name needs a graphical environment!\n" unless $ENV{'DISPLAY'};


my $tmpfile = File::Temp->new();
my $http = HTTP::Tiny->new(
	verify_SSL => 1,
);
die "No TLS support: $!\n" unless $http->can_ssl;


my $response = $http->get($uri);
$response->{success} or die "$response->{status} $response->{reason}\n";


open my $tmp_fh, '>', $tmpfile or die "$tmpfile could not be opened for writing: $!\n";
say $tmp_fh $response->{content};
close $tmp_fh;

# Cannot be exec, since the temporary file needs to be cleaned up.
system 'sxiv', '--', $tmpfile;