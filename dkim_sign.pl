#!/usr/bin/env perl

use Env;
use Mail::DKIM::Signer;
use Mail::DKIM::TextWrap;
use Mail::Internet;
use Mail::Address;
use strict;

my ($dkim_list) = @ARGV;

if (not defined $dkim_list) {
	die 'Need DKIM list';
}

my @lines = <STDIN>;
my @copy = @lines;
my $msg = Mail::Internet->new(\@lines);
my $from = $msg->head()->get('From');
my @from_addr = Mail::Address->parse($from);
my $domain;

# Get the domain from the from adress.
if (scalar @from_addr == 1) {
	$domain = $from_addr[0]->host();
} else {
	die 'Invalid From address.';
}

sub sign {
	my ($domain, $selector, $algorithm, $method, $keyfile, $lines) = @_;
	my $dkim = Mail::DKIM::Signer->new(
		Algorithm => $algorithm,
		Method => $method,
		Domain => $domain,
		Selector => $selector,
		KeyFile => $keyfile
	);
	my @lines = @{ $lines };
	foreach (@lines) {
		chomp;
		s/\015$//;
		$dkim->PRINT("$_\015\012");
	}
	$dkim->CLOSE;
	return $dkim->signature->as_string()
}

open(dkim_domains, '<', $dkim_list) or die $!;

while (<dkim_domains>) {
	my ($dkim_domain, $selector, $algorithm, $method, $keyfile) = split ' ', $_;

	if (not defined $keyfile) {
		next;
	}

	if ($domain eq $dkim_domain) {
		my $signature = sign($domain, $selector, $algorithm, $method, $keyfile, \@copy);
		unshift @copy, $signature."\n";
		foreach (@copy) {
			print("$_");
		}
		exit 0;
	}
}
printf("%s not found in DKIM list.\n", $domain);
exit 1;
