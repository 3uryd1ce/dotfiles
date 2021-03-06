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

my $program_name = fileparse $0;


sub usage {
	die <<EOT;
$program_name [file_to_sort] ...

$program_name will append '.bak' to the original file name.
$program_name removes redundant entries.
EOT
}


sub uniq {
	my %seen;
	return grep {! $seen{$_}++} @_;
}


@ARGV or usage;

for (@ARGV) {
	open my $unsorted_file_fh, '<', $_ or die "Could not open $_ for reading: $!\n";
	my @lines;

	while (my $line = <$unsorted_file_fh>) {
		chomp $line;
		push @lines, $line;
	}

	close $unsorted_file_fh;

	rename $_, "$_.bak" or die "Could not rename $_ to $_.bak: $!\n";


	open my $sorted_file_fh, '>', $_ or die "Could not open $_ for writing: $!\n";

	my @unique_lines = uniq @lines;
	say $sorted_file_fh join("\n", sort @unique_lines);

	close $sorted_file_fh;
}
