library(tidyverse)
library(glue)

# set working dir
setwd("/Volumes/T9/vilius/human/ipsc_comparison")

# read ENCODE metadata
metadata <- read.table("./report.tsv", sep = "\t",
                           skip = 1, header = TRUE)

# filter for relevant columns
metadata <- metadata[, c("Accession", "Files")]

# list .fastq.gz in the directory
files <- list.files() # List all files in the current directory
fastq_files <- str_subset(files, "ENCFF.*\\.fastq\\.gz") # Subset to only fastq.gz files.
fastq_files_no_ext <- str_replace(fastq_files, "\\.fastq\\.gz", "") # Use str_replace for conciseness and clarity

file_df <- as.data.frame(fastq_files_no_ext)
file_df$Accession <- NA

# rename .fastq.gz to {accession}_{original_file_name}.fastq.gz
for (file in file_df$fastq_files){
  fastq_file_no_ext <- str_replace(file, "\\.fastq\\.gz", "")
  file_df$Accession[str_detect(file_df$fastq_files, fastq_file_no_ext)] <- metadata$Accession[str_detect(metadata$Files, fastq_file_no_ext)]
  old_file <- glue("{file}.fastq.gz")
  accession <- file_df$Accession[str_detect(file_df$fastq_files_no_ext, file)]
  new_file <- glue("{accession}_{file}.fastq.gz")
  file.rename(old_file, new_file)
}
