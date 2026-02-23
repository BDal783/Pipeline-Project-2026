library(sleuth)
library(dplyr)

desired_wd <- "Pipeline-Project-2026"
current_wd <- getwd()
if (!grepl(desired_wd, current_wd, fixed = TRUE)) {
  if (dir.exists(desired_wd)) {
    setwd(desired_wd)
  }  
}

sample_id <- c(
  "Results/SRR5660030",
  "Results/SRR5660033",
  "Results/SRR5660044",
  "Results/SRR5660045"
)

condition <- c(
  "2dpi", "2dpi",
  "6dpi", "6dpi"
)

so <- data.frame(
  sample = sample_id,
  condition = condition,
  path = file.path(sample_id),
  stringsAsFactors = FALSE
)

so$condition <- factor(so$condition)

so <- sleuth_prep(so, ~ condition)
so <- sleuth_fit(so, ~ condition, "full")
so <- sleuth_fit(so, ~ 1, "reduced")
so <- sleuth_lrt(so, "reduced", "full")

#extract the test results from the sleuth object 
sleuth_table = sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)

#making sure significant
sleuth_significant <- sleuth_table |> filter(qval < 0.05) |> arrange(pval)

# Write TSV 
write.table(
  sleuth_significant[, c("target_id", "test_stat", "pval", "qval")],
  file = "results.tsv",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

# Write summary for pipeline report
cat("Problem 3\n", file = "Dal_PipelineReport.txt", append = TRUE)

# Write the data frame
write.table(
  sleuth_significant[, c("target_id", "test_stat", "pval", "qval")],
  file = "Dal_PipelineReport.txt",
  append = TRUE,
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE 
)
cat("\n", file = "Dal_PipelineReport.txt", append = TRUE)