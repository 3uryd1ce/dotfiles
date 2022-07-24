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

# Decode JSON and manipulate it with Perl.
use JSON::MaybeXS;

# Make API requests.
use HTTP::Tiny;

# Get the basename of the program we're running.
use File::Basename;


sub make_github_api_url {
	my ($username, $repository) = @_;

	$username or die '$username is undefined';
	$repository or die '$repository is undefined';

	return "https://api.github.com/repos/$username/$repository/releases/latest";
}

sub make_federation_api_url {
	my $server_name = shift;
	$server_name or die '$server_name is undefined';
	return "https://federationtester.matrix.org/api/report?server_name=$server_name";
}


my $program_name = fileparse $0;
my $matrix_server = shift or die "$program_name needs a domain name to check.\n";

system 'command -v notify-send >/dev/null 2>&1';
die "notify-send is not installed.\n" if $?;

my $http = HTTP::Tiny->new(
	verify_SSL => 1,
);
die "TLS is unsupported!\n" unless $http->can_ssl;


my $github_api_response = $http->get(make_github_api_url('matrix-org', 'synapse'));
$github_api_response->{success}
	or die "$github_api_response->{status} $github_api_response->{reason}\n";

my $decoded_github_api_response = decode_json $github_api_response->{content};
chomp(my $remote_synapse_version = ${$decoded_github_api_response}{'name'});

# Exclude release candidates and catch unknown release schemes.
$remote_synapse_version =~ /\A v \d+\. \d+\. \d+ \z/ax
	or die "Release version did not match expected release scheme.\n";


my $federation_api_response = $http->get(make_federation_api_url($matrix_server));
$federation_api_response->{success}
	or die "$federation_api_response->{status} $federation_api_response->{reason}\n";

my $decoded_federation_api_response = decode_json $federation_api_response->{content};
chomp(my $current_synapse_version =
	'v' . ${$decoded_federation_api_response}{'Version'}{'version'});


if ($remote_synapse_version gt $current_synapse_version) {
	exec 'notify-send', "Time to upgrade to synapse $remote_synapse_version";
}
