# Reformating and indexing files

The files in [`/annotations/originals`](/annotations/originals) where reformated as follows. The following scripts assume you are running this in the annotations directory and have `bedToBigBed` on your path.

```bash
for type in cdd gene3d hamap panther pfam pirsf smart superfamily; do
  echo "Working on type $type"
  cat originals/sarscov2_${type}.bed | \
  perl -ple '$_ =~ s/Accession\s+:\s([0-9a-zA-Z._]+)\s;\sInterPro\saccession\s:\s(.+)/$1\t$2/' | \
  perl -ple '$_ =~ s/Accession\s+:\s([0-9a-zA-Z._]+)/$1\t-/' | \
  cut -f 1,2,3,4,5,6,14,15 | \
  perl -ple ' @v = split("\t", $_); $v[4] = int($v[4]); $_ = join("\t", @v)' > reformatted/sarscov2_${type}.bed
  bedToBigBed -tab -type=bed6+2 -as=as/domain_backprojection.as reformatted/sarscov2_${type}.bed genome.sizes bb/sarscov2_${type}.bb
  echo "Done"
done
```

```bash
for type in mobidblite ncoils seg signalp tmhelices; do
  echo "Working on type $type"
  cat originals/sarscov2_${type}.bed | \
  cut -f 1,2,3,4,5,6,14,15 | \
  perl -ple ' @v = split("\t", $_); $v[4] = int($v[4]); $_ = join("\t", @v)' > reformatted/sarscov2_${type}.bed
  bedToBigBed -tab -type=bed6 reformatted/sarscov2_${type}.bed genome.sizes bb/sarscov2_${type}.bb
  echo "Done"
done
```

## VCF

VCF was done by downloading the raw file from https://github.com/W-L/ProblematicSites_SARS-CoV2, compressed with `bgzip` and indexed with `tabix` using `csi` and `tbi` indexes.
