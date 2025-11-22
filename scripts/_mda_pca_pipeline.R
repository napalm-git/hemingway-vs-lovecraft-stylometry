#### MDA pipeline with FA or PCA fallback
#### Works with normalized_postag_counts_wide.csv (with register column)

library(tidyverse)
library(psych)

# --- 1. Load data ---
data <- read.csv("data/normalized_postag_counts_wide.csv")

# Remove metadata
fa.data <- data %>%
  select(-file_names, -register) %>%
  as.data.frame()

# Drop zero-variance columns
fa.data <- fa.data[, sapply(fa.data, function(x) var(x, na.rm=TRUE) > 0)]

# Replace NA with 0
fa.data <- fa.data %>% mutate_all(~replace(., is.na(.), 0))

# --- 2. Try Factor Analysis ---
doFA <- TRUE
fa_result <- NULL

tryCatch({
  # correlation matrix
  fa.cor <- cor(fa.data)
  
  # run FA with 2–3 factors (like Biber’s classic setup)
  fa_result <- factanal(x = fa.data, factors = 3, rotation = "promax", method = "mle", scores = "regression")
  
  print("Factor Analysis succeeded ✅")
  print(fa_result$loadings)
}, error = function(e) {
  doFA <<- FALSE
  message("Factor Analysis failed ❌ – falling back to PCA")
})

# --- 3. If FA failed, do PCA ---
if (!doFA) {
  pca <- prcomp(fa.data, scale. = TRUE)
  
  print("PCA results ✅")
  print(summary(pca))   # variance explained
  print(pca$rotation[,1:3])  # loadings on first 3 PCs
  
  # Get scores for plotting
  scores <- as.data.frame(pca$x[,1:3])
  colnames(scores) <- c("PC1", "PC2", "PC3")
  scores$register <- data$register
  scores$file_names <- data$file_names
  
  write.csv(scores, "data/pca_scores.csv", row.names = FALSE)
  
} else {
  # If FA worked, export scores
  scores <- as.data.frame(fa_result$scores)
  scores$register <- data$register
  scores$file_names <- data$file_names
  
  write.csv(scores, "data/fa_scores.csv", row.names = FALSE)
}
