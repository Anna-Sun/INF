# 29-3-2019 JHZ

(NR==1 || (($9>=1e-6 && $14>0.4) && (N>2500 || ($8 > 0.1 && 1-$8 < 1 - 0.1))))
{
  $9="";
  print
}

# gunzip -c /data/niceri/Stability_INF1/STABILITY_Q13541_4EBP1_chr1.txt.gz | head -1 | sed 's/ /\n/g' | awk '{print "#" NR, $1}'

#1 SNPID
#2 CHR
#3 POS
#4 STRAND
#5 N
#6 EFFECT_ALLELE
#7 REFERENCE_ALLELE
#8 CODE_ALL_FQ
#9 HWE_PVAL
#10 BETA
#11 SE
#12 PVAL
#13 RSQ
#14 RSQ_IMP
#15 IMP

# sort -r -n -k3,3 -t, doc/stability_inf_n_nmissing.csv | awk -vFS="," '(NR>66){print $2,$3}'

