table domain_backprojection
"Back projection of protein domain information back to genomic coordinates"
    (
    string chrom;      "Reference sequence chromosome or scaffold"
    uint   chromStart; "Start position in chromosome"
    uint   chromEnd;   "End position in chromosome"
    string name;       "Short Name of item"
    uint   score;      "Score from 0-1000"
    char[1] strand;    "+ or -"
    string accession;   "Accession for this record"
    string interpro;  "InterPro accession"
    )
