#!/usr/bin/env perl

use YAML qw(LoadFile);
use Mail::DKIM::Signer;
use Mail::DKIM::TextWrap;
use strict;

my ($dkim_config) = @ARGV;

if (not defined $dkim_config) {
	die 'Need DKIM config';
}

my $policyfn = sub {
	my $dkim = shift;
	my ($configs) = LoadFile($dkim_config);
	my @configs = @{ $configs };
	my $domain = $dkim->message_originator->host;
	foreach (@configs) {
		my %config = %$_;
		if ($config{'domain'} eq $domain) {
			my $algorithm = $config{'algorithm'};
			$algorithm = 'rsa-sha1' if not defined $algorithm;

			my $method = $config{'method'};
			$method = 'relaxed' if not defined $method;

			my $selector = $config{'selector'};
			$selector = 'dkim' if not defined $selector;

			my $keyfile = $config{'keyfile'};

			$dkim->algorithm($algorithm);
			$dkim->method($method);
			$dkim->domain($domain);
			$dkim->selector($selector);
			$dkim->key_file($keyfile);
			return 1;
		}
	}

	return 0;
};


my $dkim = Mail::DKIM::Signer->new(
	Policy => $policyfn,
);

my @output = ();
while (<STDIN>) {
	push @output, $_;
	chomp;
	s/\015$//;
	$dkim->PRINT("$_\015\012");

}

$dkim->CLOSE;
if (defined $dkim->signature) {
	unshift @output, $dkim->signature->as_string()."\n";
	foreach (@output) {
		print($_);
	}
}

exit 1;
