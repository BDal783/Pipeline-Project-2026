library(sleuth)
library(dplyr)

desired_wd <- "Pipeline-Project-2026"
current_wd <- getwd()
if (!grepl(desired_wd, current_wd, fixed = TRUE)) {
  if (dir.exists(desired_wd)) {
    setwd(desired_wd)
  }  
}

stab = read.table("Conditions.txt",header=TRUE)


so = sleuth_prep(stab)
so <- sleuth_fit(so, ~ condition, "full")
so <- sleuth_fit(so, ~ 1, "reduced")
so <- sleuth_lrt(so, "reduced", "full")

#extract the test results from the sleuth object 
sleuth_table = sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)

#making sure significant
sleuth_significant = dplyr::filter(sleuth_table, qval <= 0.05) |> dplyr::arrange(pval) 

# Write TSV 
write.table(
  sleuth_table[, c("target_id", "test_stat", "pval", "qval")],
  file = "results.tsv",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

# Write summary for pipeline report
cat("Problem 3\n", file = "PipelineReport.txt", append = TRUE)
cat("target_id\ttest_stat\tpval\tqval\n", file = "PipelineReport.txt", append = TRUE)
# Write the data frame
write.table(
  sleuth_significant[, c("target_id", "test_stat", "pval", "qval")],
  file = "PipelineReport.txt",
  append = TRUE,
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE 
)
cat("\n", file = "Dal_PipelineReport.txt", append = TRUE)
