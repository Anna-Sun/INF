# 27-10-2018 JHZ

## build the lists
if [ ! -d METAL ]; then mkdir METAL; fi
rm -f METAL/METAL.tmp
touch METAL/METAL.tmp
for dir in EGCUT_INF INTERVAL NSPHS_INF ORCADES STABILITY STANLEY VIS
do
   ls sumstats/$dir | \
   awk -vdir=$dir '{
      s=$1
      gsub(dir,"",s)
      gsub(/EGCUT|NSPHS/,"",s)
      gsub(/\_autosomal|\_X_female|\_X_male|\_lah1-|\_swe6-|.gz|@/,"",s)
      gsub(/^\./,"",s)
      gsub(/@/,"",$1)
      print s " " ENVIRON["HOME"] "/INF/sumstats/" dir "/" $1
   }' >> METAL/METAL.tmp
done
sort -k1,1 METAL/METAL.tmp > METAL/METAL.list

# generate METAL command files
for p in $(cut -f1 inf1.list)
do
   export metal=METAL/$p.metal
   echo SEPARATOR TAB > $metal
   echo COLUMNCOUNTING STRICT >> $metal
   echo CUSTOMVARIABLE CHR >> $metal
   echo LABEL CHR as CHR >> $metal
   echo CUSTOMVARIABLE POS >> $metal
   echo LABEL POS as POS >> $metal
   echo CUSTOMVARIABLE WEIGHT >> $metal
   echo LABEL WEIGHT as N >> $metal
   echo AVERAGEFREQ ON >> $metal
   echo MINMAXFREQ ON >> $metal
   echo MARKERLABEL SNPID >> $metal
   echo ALLELELABELS EFFECT_ALLELE REFERENCE_ALLELE >> $metal
   echo EFFECTLABEL BETA >> $metal
   echo PVALUELABEL PVAL >> $metal
   echo WEIGHTLABEL N >> $metal
   echo FREQLABEL CODE_ALL_FQ >> $metal
   echo STDERRLABEL SE >> $metal
   echo SCHEME STDERR >> $metal
   echo GENOMICCONTROL OFF >> $metal
   echo OUTFILE $HOME/INF/METAL/$p- .tbl >> $metal
   echo $p | join METAL/METAL.list - | awk '{$1="PROCESS"; print}' >> $metal;
   echo ANALYZE >> $metal
   echo CLEAR >> $metal
done

# conducting the analysis
module load metal/20110325 parallel/20170822
ls METAL/*.metal | \
sed 's/.metal//g' | \
parallel --env HOME -j8 -C' ' '
  metal $HOME/INF/{}.metal; \
  gzip -f $HOME/INF/{}-1.tbl
'

# extracting the top-hits
ls METAL/*-1.tbl.gz | \
parallel -j4 -C' ' '
  gunzip -c {} | \
  awk "NR==1 || \$6 <= 5e-10" > METAL/$(basename -s -1.tbl.gz {}).top'

# obtain largest M -- the union of SNP lists as initially requested by NSPHS

function largest_M()
{
  for dir in EGCUT_INF INTERVAL LifeLinesDeep ORCADES PIVUS STABILITY STANLEY ULSAM VIS
  do
    export file=sumstats/$dir/$(ls sumstats/$dir -rS | tail -n 1 | sed 's/@//g;s/.gz//g')
    echo $file
    gunzip -c $file | awk 'NR>1' | cut -f1 | cut -d' ' -f1 > /data/jinhua/M/$dir
  done

  export female=$(ls sumstats/EGCUT_INF/**X_female* -rS | tail -n 1 | sed 's/@//g')
  export male=$(ls sumstats/EGCUT_INF/**X_male* -rS | tail -n 1 | sed 's/@//g')
  gunzip -c $female | awk 'NR>1' | cut -f1 | cut -d' ' -f1 > /data/jinhua/M/EGCUT_X_female
  gunzip -c $male | awk 'NR>1' | cut -f1 | cut -d' ' -f1 > /data/jinhua/M/EGCUT_X_male

  cd /data/jinhua/M
  cat EGCUT_INF EGCUT_X_female EGCUT_X_male INTERVAL ORCADES STABILITY STANLEY VIS | \
  sort | \
  uniq > /data/jinhua/M/M.union
  cd -
}

largest_M
