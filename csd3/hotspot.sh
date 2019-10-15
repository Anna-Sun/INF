# 16-10-2019 JHZ

export HOTSPOT=$1
(
  grep ${HOTSPOT} work/INF1.merge.cis.vs.trans | \
  awk -v OFS="\t" '{print "chr" $14,$15,$16,$13,$17}' | \
  sed 's/\"//g'
) > a

(
  grep ${HOTSPOT} work/INF1.merge.cis.vs.trans | \
  cut -d' ' -f3,4 | \
  awk -v OFS="\t" '{print "chr" $1,$2-1, $2}'
) > b1

(
  sort -k1,1n -k2,2n csd3/glist-hg19 | \
  grep -v X | \
  grep -v Y | \
  awk '{$1="chr" $1;print}' | \
  sed 's/ /\t/g'
) > b2

bedtools intersect -a b1 -b b2 -wa -wb -loj | \
cut  -f1-3,7 > b

R --no-save -q <<END
  library(circlize)
  a <- read.table("a",as.is=TRUE,col.names=c("chr","start","end", "gene", "cistrans"))
  b <- read.table("b",as.is=TRUE,col.names=c("chr","start","end", "gene"))
  ab <- rbind(data.frame(b,cistrans="."),data.frame(unique(a[,-5]),cistrans="."))
  HOTSPOT <- Sys.getenv("HOTSPOT")
  pdf(paste0(HOTSPOT,".pdf"))
  circos.par(start.degree = 90, track.height = 0.1, cell.padding = c(0, 0, 0, 0))
  circos.initializeWithIdeogram(species="hg19", track.height = 0.05, ideogram.height = 0.06)
  circos.genomicLabels(ab,labels.column = 4, side="inside")
  cols <- rep(12,nrow(a))
  cols[a["cistrans"]=="trans"] <- 10
  circos.genomicLink(a, b, col = cols, directional=1, border = 10, lwd = 2)
  circos.clear()
  dev.off()
END

pdftopng -r 300 ${HOTSPOT}.pdf ${HOTSPOT}
mv ${HOTSPOT}-000001.png ${HOTSPOT}.png

rm a b b1 b2
