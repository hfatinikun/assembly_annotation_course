
# Load the circlize package
library(circlize)
library(tidyverse)
library(ComplexHeatmap)

# Load the TE annotation GFF3 file
gff_file <- "/data/users/hfatinikun/assembly_annotation_course/annotation/EDTA/asm.bp.p_ctg.fa.mod.EDTA.TEanno.gff3" 
gff_data <- read.table(gff_file, header = FALSE, sep = "\t", stringsAsFactors = FALSE)

gff_annotation <- "/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/filtered.genes.renamed.gff3"
annotation_data <- read.table(gff_annotation, header = FALSE, sep = "\t", stringsAsFactors = FALSE)


# Check the superfamilies present in the GFF3 file, and their counts
gff_data$V3 %>% table()


# custom ideogram data
## To make the ideogram data, you need to know the lengths of the scaffolds.
## There is an index file that has the lengths of the scaffolds, the `.fai` file.
## To generate this file you need to run the following command in bash:
## samtools faidx assembly.fasta
## This will generate a file named assembly.fasta.fai
## You can then read this file in R and prepare the custom ideogram data

custom_ideogram <- read.table("/data/users/hfatinikun/assembly_annotation_course/annotation/visualize_TE_annotation/hifiasm.fai", header = FALSE, stringsAsFactors = FALSE)
custom_ideogram$chr <- custom_ideogram$V1
custom_ideogram$start <- 1
custom_ideogram$end <- custom_ideogram$V2
custom_ideogram <- custom_ideogram[, c("chr", "start", "end")]
custom_ideogram <- custom_ideogram[order(custom_ideogram$end, decreasing = T), ]
sum(custom_ideogram$end[1:20])

# Select only the first 20 longest scaffolds, You can reduce this number if you have longer chromosome scale scaffolds
custom_ideogram <- custom_ideogram[1:14, ]

# ---------- Helpers to coerce to bed3 ----------
to_bed3 <- function(df, custom_ideogram) {
  # Expect GFF3 columns: V1=seqid, V4=start, V5=end
  bed <- data.frame(
    chr   = df[[1]],
    start = suppressWarnings(as.integer(df[[4]])),
    end   = suppressWarnings(as.integer(df[[5]])),
    stringsAsFactors = FALSE
  )
  # keep only selected scaffolds, valid ranges, start<=end
  bed <- bed[bed$chr %in% custom_ideogram$chr & !is.na(bed$start) & !is.na(bed$end) & bed$end >= bed$start, ]
  bed[, c("chr","start","end")]               # return EXACTLY 3 columns
}

filter_superfamily_bed3 <- function(gff_data, superfamily, custom_ideogram) {
  to_bed3(gff_data[gff_data$V3 == superfamily, , drop = FALSE], custom_ideogram)
}

filter_gene_bed3 <- function(annotation_data, custom_ideogram) {
  to_bed3(annotation_data[annotation_data$V3 == "gene", , drop = FALSE], custom_ideogram)
}

# Defensive wrapper: safely draw density only if non-empty & 3 cols
safe_genomic_density <- function(bed3, ...) {
  bed3 <- as.data.frame(bed3)
  bed3 <- bed3[, 1:3, drop = FALSE]
  if (!ncol(bed3) == 3) stop("bed input must have exactly 3 columns")
  colnames(bed3) <- c("chr","start","end")
  if (!nrow(bed3)) return(invisible(NULL))
  circos.genomicDensity(bed3, ...)
}


pdf("02-TE_density_with_genes.pdf", width = 10, height = 10)

gaps <- c(rep(1, nrow(custom_ideogram) - 1), 5)
circos.par(start.degree = 90, gap.after = gaps, track.margin = c(0, 0))
circos.genomicInitialize(custom_ideogram)  # chr/start/end columns already present

safe_genomic_density(filter_gene_bed3(annotation_data, custom_ideogram),
                     count_by = "number", track.height = 0.07, window.size = 1e5, col = "black")
safe_genomic_density(filter_superfamily_bed3(gff_data, "Gypsy_LTR_retrotransposon", custom_ideogram),
                     count_by = "number", track.height = 0.07, window.size = 1e5, col = "darkgreen")
safe_genomic_density(filter_superfamily_bed3(gff_data, "Copia_LTR_retrotransposon", custom_ideogram),
                     count_by = "number", track.height = 0.07, window.size = 1e5, col = "darkred")
safe_genomic_density(filter_superfamily_bed3(gff_data, "tRNA_SINE_retrotransposon", custom_ideogram),
                     count_by = "number", track.height = 0.07, window.size = 1e5, col = "darkblue")
safe_genomic_density(filter_superfamily_bed3(gff_data, "L1_LINE_retrotransposon", custom_ideogram),
                     count_by = "number", track.height = 0.07, window.size = 1e5, col = "purple")
safe_genomic_density(filter_superfamily_bed3(gff_data, "Mutator_TIR_transposon", custom_ideogram),
                     count_by = "number", track.height = 0.07, window.size = 1e5, col = "orange")

circos.clear()

lgd <- Legend(
  title = "Superfamily",
  at = c("gene", "Gypsy_LTR_retrotransposon", "Copia_LTR_retrotransposon",
         "tRNA_SINE_retrotransposon", "L1_LINE_retrotransposon", "Mutator_TIR_transposon"),
  legend_gp = gpar(fill = c("black", "darkgreen", "darkred", "darkblue", "purple", "orange"))
)
draw(lgd, x = unit(12, "cm"), y = unit(15, "cm"), just = c("center"))

dev.off()



# Check unique feature types
print(unique(gff_data$V3)[1:20])

# Confirm shapes of each bed3
beds <- list(
  gene   = filter_gene_bed3(annotation_data, custom_ideogram),
  gypsy  = filter_superfamily_bed3(gff_data, "Gypsy_LTR_retrotransposon", custom_ideogram),
  copia  = filter_superfamily_bed3(gff_data, "Copia_LTR_retrotransposon", custom_ideogram),
  trna   = filter_superfamily_bed3(gff_data, "tRNA_SINE_retrotransposon", custom_ideogram),
  l1     = filter_superfamily_bed3(gff_data, "L1_LINE_retrotransposon", custom_ideogram),
  mutator= filter_superfamily_bed3(gff_data, "Mutator_TIR_transposon", custom_ideogram)
)
lapply(beds, function(x) c(nrow=nrow(x), ncol=ncol(x)))
lapply(beds, function(x) head(x, 3))
