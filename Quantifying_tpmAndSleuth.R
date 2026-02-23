library(sleuth)
library(dplyr)

setwd("~/Pipeline-Project-2026/Results")

sample_id <- c(
  "SRR5660030",
  "SRR5660033",
  "SRR5660044",
  "SRR5660045"
)

condition <- c(
  "2dpi", "2dpi",
  "6dpi", "6dpi"
)

so <- data.frame(
  sample = sample_id,
  condition = condition,
  path = sample_id,
  stringsAsFactors = FALSE
)

print(so)

file.exists(so$path)
file.exists(file.path(so$path, "abundance.h5"))

#everything below has been copied from in class example 
so <- sleuth_prep(so, ~ condition)
class(so)
so <- sleuth_fit(so, ~ condition, "full")
so <- sleuth_fit(so, ~ 1, "reduced")
so <- sleuth_lrt(so, "reduced", "full")

#extract the test results from the sleuth object 
sleuth_table = sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE) 

#filter most significant results (FDR/qval < 0.05) and sort by pval
sleuth_significant = dplyr::filter(sleuth_table, qval < 0.05) |> dplyr::arrange(pval) 

#print top 10 transcripts
head(sleuth_significant, n=10)

#write FDR < 0.05 transcripts to file
write.table(sleuth_significant[, c("target_id", "test_stat", "pval", "qval")], file="sleuth_results.txt",quote = FALSE,row.names = FALSE)

#output is zero need to confirm before submission