# **Hemingway vs. Lovecraft: Computational Stylometry with R, spaCy, and PCA**

This project compares the writing styles of **Ernest Hemingway** and **H.P. Lovecraft** using computational stylistics, POS-based feature engineering, spaCy parsing, and Principal Component Analysis (PCA).

The goal is to quantify a well-known literary contrast:

* **Hemingway** → minimalist, terse, paratactic, dialogue-driven
* **Lovecraft** → maximalist, elaborate, descriptively saturated

Using two independent feature pipelines — spaCy stylometry and MAT-style POS counts — the analysis shows an extremely clear separation between authors on PC1, confirming the minimalist ↔ maximalist divide.

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
    (Lovecraft public-domain texts only)
```

---

## 🔧 **Methods Overview**

### **1. Stylometric Feature Extraction (spaCy + R)**

Using `spacyr`, the pipeline extracts:

* average sentence length
* adjective, adverb, pronoun, proper noun densities
* noun–verb ratio
* subordination markers (`dep_rel == "mark"`)
* past-tense usage (VBD/VBN)
* type–token ratio

Output stored in:

```
data/author_features.csv
```

---

### **2. MAT / Biber-Style POS Feature Matrix**

A separate feature set was produced using Biber/MAT tags, yielding dimensions such as:

* elaboration
* subordination
* abstractness
* informational density
* involvement vs. informational

Stored in:

```
data/normalized_postag_counts_wide.csv
```

---

### **3. PCA Pipeline (Dimensionality Reduction)**

Factor Analysis was attempted but unstable due to small N (10 texts).
PCA was chosen — standard practice in stylometry.

Pipeline steps:

* drop zero-variance features
* scale variables
* extract PC1–PC3
* export scores to:

```
data/pca_scores.csv
```

---

### **4. Visualization**

`03_make_figures.R` generates:

* **PC1 vs PC2 scatterplot**
* **boxplots** of PC1 and PC2 by author
* **loadings plot** showing feature contributions

All saved in `/figures`.

---

# 📈 **Results**

The PCA revealed a **clear and systematic stylistic divide** between Hemingway and Lovecraft. PC1 captured the **main contrast**, while PC2 reflected **secondary variation** within each author.

---

## **PC1: Minimalism ↔ Maximalism (Primary Dimension)**

All Hemingway stories scored **strongly negative** on PC1, all Lovecraft stories **strongly positive** — with **zero overlap**.

### **Hemingway (PC1 ≈ –6 to –1)**

* short, paratactic clauses
* minimal modification
* low subordination
* dialogue-driven narration
* high use of private verbs
* concrete vocabulary

### **Lovecraft (PC1 ≈ +2 to +4)**

* recursive subordination
* dense adjectival/adverbial modification
* extended noun phrases
* abstract, elaborative description
* informational density

**Interpretation:**
Hemingway creates tension through **omission**.
Lovecraft creates tension through **linguistic excess**.

---

## **PC2: Internal Variation (Secondary Dimension)**

### **Hemingway:**

PC2 shows **wide internal stylistic range**.

* *Hills Like White Elephants* = extremely dialogue-heavy, minimalistic (low PC2)
* *Cat in the Rain* = more descriptive, reflective (high PC2)

Hemingway’s minimalism exists on a **continuum**, depending on narrative demands.

### **Lovecraft:**

Texts are tightly clustered around the center of PC2, indicating a **stable, homogeneous maximalist style**.

---

## **Feature Loadings: What Drives the Separation?**

### **Positive PC1 loadings (Lovecraft direction):**

* WH-relative clauses (WHOBJ, WHSUB, WHCL)
* subordination markers (e.g., *that*, *which*)
* participial forms (VBD, VBN)
* passive constructions
* complex noun phrase elaboration

→ Features indexing *syntactic density, embedding, elaboration, abstraction.*

### **Negative PC1 loadings (Hemingway direction):**

* contractions
* private verbs
* conversational markers
* simple clause structures

→ Features indexing *immediacy, parataxis, reduced modification.*

---

## **MAT Validation**

MAT results supported the PCA interpretation:

**Hemingway**

* involved
* narrative
* concrete
* low elaboration

**Lovecraft**

* informational
* explicit
* abstract
* heavily elaborated

Both independent pipelines converge on the same interpretation:
the authors differ strongly in linguistic complexity, modification, and subordination.

---

## **Summary**

This stylometric analysis quantitatively supports the widely-discussed literary contrast:

* **Hemingway** = terse, grounded, minimalist
* **Lovecraft** = dense, recursive, elaborative

PC1 splits them almost perfectly, PC2 reveals intra-author variation, and loadings identify the grammatical features responsible. MAT validates the findings across independent dimensions.

The pipeline provides a **reproducible quantitative foundation** for this contrast using modern NLP tools.

---

# ▶ **How to Run**

### Install packages

```r
install.packages(c("tidyverse", "spacyr", "psych", "ggrepel", "hrbrthemes"))
spacyr::spacy_initialize(model = "en_core_web_sm")
```

### Extract features

```r
source("scripts/01_extract_stylometry_spacyr.R")
```

### Run PCA

```r
source("scripts/02_mda_pca_pipeline.R")
```

### Generate figures

```r
source("scripts/03_make_figures.R")
```

---

# 🧠 **Skills Demonstrated**

* NLP (spaCy via R, dependency parsing)
* POS-based feature engineering
* Dimensionality reduction (PCA)
* Corpus construction
* Exploratory linguistic analysis
* Reproducible R workflows
* Data visualization with ggplot2
* Git/GitHub project management

---

# 👤 **Author**

**Ersin Gültekin**
M.A. Linguistics (Language, Communication & Cognition)
Computational Linguistics / NLP
University of Freiburg
