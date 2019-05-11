# Comparison of cojo and clumping results

The directories are relative to /scratch/jhz22/INF, esp. cojo/ and clumping/ there,

**Run** | **Option** | **cis** | **trans** | **total** | **Comments**
-----------|----------|--------------|-----------|------------|--------------------------------------------------------------
**GCTA** |
1 | LD blocks | 228 | 182 | 410 | only SNPs, cojo/aild-snp/INF1.jma.*, also doc/INF1.paper.xlsx
~ | ~ | 254 | 191 | 445 | SNPs+indels, cojo/aild-indel/INF1.jma.*
2 | default | 234 | 173 | 407 | --cojo-collinear 0.9 --cojo-wind 10000, doc/SCALLOP_INF1-260419.xlsx
3 | small R2 & window | 189 | 186 | 375 | --cojo-collinear 0.1 --cojo-wind 500, doc/SCALLOP_INF1-260419.xlsx
**PLINK** |
4 | LD blocks | 594 | 252 | 846 | only SNPs, clumping/aild-snp/INF1.jma.*, also doc/INF1.paper.xlsx
~ | ~ | 621 | 258 | 879 | SNPs+indels, clumping/aild-indel/INF1.jma.*
5 | INTERVAL LD panel | 657 | 275 | 932 | --clump-r2 0.1 --clump-kb 500, doc/SCALLOP_INF1-120419.xlsx
6 | 1000G LD panel | 405 | 229 | 634 | --clump-r2 0.1 --clump-kb 500, clumping/INF1.1KG.r2-0.1.clumped.*
7 | INTERVAL data | 424 | 188 | 612 | --clump-r2 0.1 --clump-kb 500, doc/SCALLOP_INF1-120419.xlsx
8 | 1000G LD panel | 402 | 226 | 628 | --clump-r2 0.1 --clump-kb 1000, on tryggve

Factors on number of signals,

* indels lead to more signals in cojo (1) and clumping (4) analyses.
* **default GCTA perameters yields smaller number of signals** (1, 2).
* increase with value of --cojo-collinear and --cojo-wind (2, 3), yet moderate changes in LD window have less impact than panel (5, 8).
* PLINK --clump gives more signals than GCTA --cojo (1, 4).
* **Specification in clumping of sliding LD windows disregarding LD patterns gives more signals** (4, 5).
* INTERVAL as LD reference leads to more signals than 1000Genomes (5, 6).
* Larger sample size gives more signals (5, 7).
* Unpruned results are likely to give more cis signals.

As highlighted, it is desirable to employ approximately independent LD blocks for both GCTA (1) and PLINK (4).