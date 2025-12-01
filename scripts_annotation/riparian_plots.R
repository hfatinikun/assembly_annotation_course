library(GENESPACE)
args <- commandArgs(trailingOnly = TRUE)

wd <- args[1]

pangenome <- readRDS(file.path(wd, "pangenome_matrix.rds"))

gpar <- init_genespace(wd = wd, path2mcscanx = "/usr/local/bin")

out <- run_genespace(gpar, overwrite = F)
#ripDat <- plot_riparian(
#  gsParam = pangenome, 
#  refGenome = "human", 
#  forceRecalcBlocks = FALSE)

invchr <- data.frame(
  genome = c("Nemrut_1", "Nemrut_1", "Nemrut_1", "Nemrut_1", "Nemrut_1", "Nemrut_1", "Nemrut_1", "Nemrut_1"), 
  chr = c("ptg000006l", "ptg000007l", "ptg000014l", "ptg000001l", "ptg000004l", "ptg000005l", "ptg000002l", "ptg000013l"))
ripDat <- plot_riparian(
  gsParam = out, 
  minChrLen2plot = 10,
  invertTheseChrs = invchr,
  reorderBySynteny = TRUE,
  refGenome = "TAIR10",
  chrLabFontSize = 7)