#!/usr/bin/env perl

use strict;
use warnings;
use Text::CSV;

my $file = 'ucsc_annotations.csv';
my $output_bed_file = 'ucsc_annotations.bed';
my $output_bigbed_file = 'ucsc_annotations.bb';
my $output_autosql_file = 'ucsc_annotations.as';
my $output_genome_sizes_file = 'genome_sizes.txt';
my $genome_location_name = 'MN908947.3';

my $csv = Text::CSV->new({sep_char=> ","});
my @bed_rows;

{
  open my $fh, "<:encoding(utf8)", $file or die "Cannot open ${file}: $!";

  # Skip 1st 2 lines
  my $line_one = <$fh>;
  my $line_two = <$fh>;
  $csv->header($fh);
  my @tmp_bed_rows;
  while (my $row = $csv->getline($fh)) {
    # Incoming format is
    # start (0),end (1),label (2),category (3),long descriptive text (4), URL (5)
    my $index = 0;
    push(@tmp_bed_rows, [
      $genome_location_name,  # chrom
      ($row->[0] - 1),        # start into interbase coords
      $row->[1],              # end
      $row->[2],              # name
      '0',                    # score
      '+',                    # strand
      $row->[3],              # category
      $row->[5],              # URL
      $row->[4],              # description
    ]);
  }
  close $fh;

  @bed_rows = sort { $a->[1] <=> $b->[1] or $a->[2] <=> $b->[2] } @tmp_bed_rows; #sort according to start/end
}

my $bed_type = 'bed6+3';
my $autosql = <<EOF;
table communityAnnotationSARSCoV2
"Community annotation provided via the UCSC Google sheet at https://docs.google.com/spreadsheets/d/1l38ypTcQH2AP2hlBmQ7kIXz1G4e33RPX-iFH1vu-utU"
    (
    string chrom;      "Reference sequence chromosome or scaffold"
    uint   chromStart; "Start position in chromosome"
    uint   chromEnd;   "End position in chromosome"
    string name;       "Short Name of item"
    uint   score;      "Score from 0-1000"
    char[1] strand;    "+ or -"
    string category;   "Catagory of the annotation type e.g. CRISPR, genes, proteins, primers, evolution, antibodies, RNA"
    string paperlink;  "URL to the manuscript of this annotation"
    lstring description; "Long description of annotation"
    )
EOF

my $genome_sizes = <<EOF;
$genome_location_name 29903
EOF

{
  my $bed_output_writer = Text::CSV->new({ sep_char => "\t", quote_char => undef });
  open(my $fh, '>', $output_bed_file) or die "Cannot open ${$output_bed_file} for writing: $!";
  foreach my $bed_ref (@bed_rows) {
    $bed_output_writer->say($fh, $bed_ref);
  }
}

{
  # write autosql
  open my $fh, '>', $output_autosql_file or die "Cannot open ${output_autosql_file}: $!";
  print $fh $autosql;
  close $fh;
}

{
  # write genome sizes
  open my $fh, '>', $output_genome_sizes_file or die "Cannot open ${output_genome_sizes_file}: $!";
  print $fh $genome_sizes;
  close $fh;
}

# Index and create the bigbed
system('bedToBigBed', "-tab", "-type=${bed_type}", "-as=${output_autosql_file}", $output_bed_file, $output_genome_sizes_file, $output_bigbed_file);
