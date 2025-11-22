#### PCA visualisations for Hemingway vs. Lovecraft
#### Works with pca_scores.csv

# Load libraries
library(tidyverse)
library(ggrepel)
library(hrbrthemes)

# --- 1. Load PCA scores ---
df <- read.csv("data/pca_scores.csv")

# --- 2. Scatterplot PC1 vs PC2 ---
scatterPlot <- ggplot(df, aes(x=PC1, y=PC2, color=register, label=file_names)) +
  geom_point(size=3) +
  geom_text_repel(size=3) +
  xlab("PC1 (main stylistic dimension)") +
  ylab("PC2 (secondary stylistic dimension)") +
  theme_bw(base_size=12) +
  theme(legend.position="top")

# Save
# ggsave("scatter_pca_PC1_PC2.pdf", scatterPlot, dpi=300, width=180, units="mm")

print(scatterPlot)


# --- 3. Boxplot of PC1 by register (are Hemingway & Lovecraft separated?) ---
boxPlot_PC1 <- ggplot(df, aes(x=register, y=PC1, fill=register)) +
  geom_boxplot(alpha=0.6, outlier.shape=NA) +
  geom_jitter(width=0.2, size=2, alpha=0.7) +
  ylab("PC1 score") +
  theme_bw(base_size=12) +
  theme(legend.position="none")

print(boxPlot_PC1)


# --- 4. Boxplot of PC2 by register ---
boxPlot_PC2 <- ggplot(df, aes(x=register, y=PC2, fill=register)) +
  geom_boxplot(alpha=0.6, outlier.shape=NA) +
  geom_jitter(width=0.2, size=2, alpha=0.7) +
  ylab("PC2 score") +
  theme_bw(base_size=12) +
  theme(legend.position="none")

print(boxPlot_PC2)


# Assuming you still have your PCA object
pca <- prcomp(fa.data, scale.=TRUE)

# Get loadings
loadings <- as.data.frame(pca$rotation[,1:2])  # first 2 PCs
loadings$feature <- rownames(loadings)

# Plot loadings for PC1 vs PC2
ggplot(loadings, aes(x=PC1, y=PC2, label=feature)) +
  geom_point(color="darkblue") +
  geom_text_repel(size=3) +
  xlab("PC1 loadings") +
  ylab("PC2 loadings") +
  theme_bw(base_size=12)

