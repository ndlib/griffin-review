#!/shared/perl/current/bin/perl

use XML::Simple;
use LWP::UserAgent;
use Data::Dumper;
use strict;

my $sys_id = $ARGV[0];

my $ua = LWP::UserAgent->new(
	agent	=> "Hesburgh Libraries REST Client",
	timeout	=> 180	
);
my $response = $ua->get("http://alephprod.library.nd.edu:1891/rest-dlf/record/NDU01${sys_id}?view=full");

if ($response->is_success) {
	my $xml = $response->content . "\n";
	my $xs = XML::Simple->new();
	my $parsed_xml = $xs->XMLin($xml, ForceArray => ['datafield', 'subfield'], ForceContent => 0);
	# print Dumper($parsed_xml);
	my $record = $parsed_xml->{record};
	my $tech_info;
	my $format;
	my $desc;
	foreach my $datafield (@{$record->{datafield}}) {
		if ($datafield->{tag} eq '100') {
			foreach my $subfield (@{$datafield->{subfield}}) {
				if ($subfield->{code} eq 'a') {
					my $author = $subfield->{content};
					$author =~ s/,$//;
					print "Author: $author\n";
				}
			}
		}
		if ($datafield->{tag} eq '245') {
			foreach my $subfield (@{$datafield->{subfield}}) {
				if ($subfield->{code} eq 'a') {
					my $title = $subfield->{content};
					$title =~ s/,$//;
					print "Title: $title\n";
				}
			}
		}
		if ($datafield->{tag} eq '260') {
			my $imprint;
			foreach my $subfield (@{$datafield->{subfield}}) {
				$imprint .= $subfield->{content} . ' ';	
			}
			print "Imprint: " . $imprint . "\n";
		}
		if ($datafield->{tag} eq '300') {
			unless ($tech_info) {
				foreach my $subfield (@{$datafield->{subfield}}) {
					$tech_info .= $subfield->{content} . ' ';	
				}
				print "Technical Specifications: " . $tech_info . "\n";
			}
		}
		if ($datafield->{tag} eq '538') {
			unless ($format) {
				foreach my $subfield (@{$datafield->{subfield}}) {
					$format .= $subfield->{content} . ' ';	
				}
				print "Format: " . $format . "\n";
			}
		}
		if ($datafield->{tag} eq '520') {
			foreach my $subfield (@{$datafield->{subfield}}) {
				$desc .= $subfield->{content} . ' ';	
			}
		}
	}
	print "Description: " . $desc . "\n";
	# print $record->{datafield}->[0]->{tag} . "\n";
	# my $fields_020 = $record->{datafield}->{'020'};
	# print Dumper($fields_020);
	
} else {
	die $response->status_line;
}
 
