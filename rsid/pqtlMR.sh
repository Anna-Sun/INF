#/usr/bin/bash

function ins()
(
# rsid prot Allele1 Allele2 Freq1 Effect StdErr log.P. cis.trans
  echo SNP Phenotype effect_allele other_allele eaf beta se pval
  cut -f2,3,6,7,8-11,21 work/INF1.METAL | \
  awk 'NR>1 && /cis/ {print $1,$2,toupper($3),toupper($4),$5,$6,$7,$8}'
) > INF1.ins

module load gcc/6
export prefix=INF1

R --no-save <<END
  prefix <- Sys.getenv("prefix")
  ivs <- within(read.table(paste0(prefix,".ins"),as.is=TRUE,header=TRUE),{pval=10^pval})
  ids <- scan("mrbase-id.txt",what="")
  pQTLtools::pqtlMR(ivs,ids)
END

cut -f1,2,5,6 --complement ${prefix}.mr.txt | \
awk -vFS="\t" 'NR==1||$5<0.05'| \
xsel -i
