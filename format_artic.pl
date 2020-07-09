#!/usr/bin/env perl

use strict;
use warnings;
use File::Spec;
use File::Basename;

my $dirname = dirname(__FILE__);
my $bed_type = 'bed9';
my $output_genome_sizes_file = File::Spec->catfile($dirname, 'annotations', 'genome.sizes');

my ($input) = File::Spec->catfile($dirname, qw/annotations originals ARTIC_V1V2V3.bed/);

open my $fh_in, '<'. $input or die "Cannot open ${input} for reading: $!";
my %beds;
my @order;
my $name;
while(my $line = <$fh_in>) {
  chomp($line);
  if($line =~ /^track/) {
    # We found a trackline
    ($name) = $line =~ /name="(.+?)"/;
    push(@order, $name);
    $beds{$name} = [];
    next;
  }
  if($line =~ /^MN/) {
    push(@{$beds{$name}}, $line);
  }
}
close($fh_in);

# use Data::Dumper; warn Dumper(\%beds);

foreach my $name (@order) {
  my $bed_lines = $beds{$name};
  my $output_bed_file = File::Spec->catfile($dirname, qw/annotations reformatted/, "${name}.bed");
  open my $fh, '>', $output_bed_file or die "Cannot open $output_bed_file for writing: $!";
  foreach my $line (@{$bed_lines}) {
    print $fh $line;
    print $fh  "\n";
  }
  close($fh);
  my $output_bigbed_file = File::Spec->catfile($dirname, qw/annotations bb/, "${name}.bb");
  # Index and create the bigbed
  system('bedToBigBed', "-tab", "-type=${bed_type}", $output_bed_file, $output_genome_sizes_file, $output_bigbed_file);
}

