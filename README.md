# **Hemingway vs. Lovecraft: Computational Stylometry with R, spaCy, and PCA**

This project compares the writing styles of **Ernest Hemingway** and **H.P. Lovecraft** using **computational stylistics**, **NLP feature engineering**, and **Principal Component Analysis (PCA)**.

The goal is to quantify a well-known literary contrast:

* **Hemingway** → minimalist, terse, low subordination
* **Lovecraft** → maximalist, adjective-heavy, highly embedded

Using spaCy-based parsing and Biber/MAT-style POS feature analysis, I build two feature datasets and show that **PCA cleanly separates the authors along a key stylistic dimension.**

---

## 📁 **Project Structure**

```
/data
    author_features.csv
    normalized_postag_counts_renamed.csv
    normalized_postag_counts_wide.csv
    pca_scores.csv

/scripts
    01_extract_stylometry_spacyr.R
    02_mda_pca_pipeline.R
    03_make_figures.R

/figures
    pca_scatter_PC1_PC2.png
    boxplot_PC1.png
    boxplot_PC2.png
    pca_loadings.png

/texts
    (Lovecraft public-domain texts)
```

---

## 🔧 **Methods Overview**

### **1. Stylometric Feature Extraction (spaCy + R)**

Using `spacyr` and spaCy’s English pipeline, I extracted:

* average sentence length
* adjective/adverb/pronoun densities
* proper noun density
* noun–verb ratio
* subordination markers (`dep_rel == "mark"`)
* past tense usage (% VBD/VBN)
* type–token ratio (lexical diversity)

These features are stored in:

```
data/author_features.csv
```

---

### **2. Multidimensional POS Analysis (MAT-style)**

I generated a POS-tagged feature matrix using a Biber-style tagset, then normalized and reshaped it into wide format:

```
data/normalized_postag_counts_wide.csv
```

This reflects dimensions such as:

* informational density
* involvement
* elaboration
* subordination
* nominal vs. verbal style

---

### **3. Dimensionality Reduction (PCA)**

Factor Analysis was attempted, but due to small sample size (N = 10 texts), PCA was used instead — a standard practice in stylometry.

The PCA pipeline:

* drops zero-variance features
* scales all variables
* extracts PC1–PC3
* exports scores to:

```
data/pca_scores.csv
```

---

### **4. Visualization (ggplot2)**

The `03_make_figures.R` script generates:

* **PC1 vs PC2 scatterplot** (clear author separation)
* **Boxplots of PC1/PC2 by author**
* **Loadings plot** showing which features drive the dimensions

All saved in `/figures`.

---

## 📈 **Key Result: Clear Stylometric Separation**

**PC1 strongly separates Hemingway and Lovecraft.**

Interpretation:

* **High PC1** → Lovecraft

  * more adjectives
  * more subordination
  * higher elaboration
  * longer sentences

* **Low PC1** → Hemingway

  * concise syntax
  * fewer modifiers
  * minimal embedding
  * lower lexical density

This matches well-known qualitative descriptions, but provides **quantitative confirmation**.

---

## ▶ **How to Run the Project**

### 1. Install packages

```r
install.packages(c("tidyverse", "spacyr", "psych", "ggrepel", "hrbrthemes"))
spacyr::spacy_initialize(model = "en_core_web_sm")
```

### 2. Extract stylometry features

```r
source("scripts/01_extract_stylometry_spacyr.R")
```

### 3. Run MDA + PCA pipeline

```r
source("scripts/02_mda_pca_pipeline.R")
```

### 4. Generate figures

```r
source("scripts/03_make_figures.R")
```

---

## 🧠 **Skills Demonstrated**

This project showcases skills relevant to NLP, data science, and computational linguistics:

### **NLP**

* spaCy dependency parsing
* POS-tag-based feature engineering
* corpus preprocessing

### **Data Science**

* PCA
* dimensionality reduction
* feature normalization
* exploratory data analysis

### **Programming / Tools**

* R (tidyverse, ggplot2, psych, ggrepel)
* data cleaning + wrangling
* reproducible project structure
* Git + GitHub

---

## 👤 **Author**

**Ersin Gültekin**
M.A. Linguistics, University of Freiburg
*Computational Linguistics & NLP*
