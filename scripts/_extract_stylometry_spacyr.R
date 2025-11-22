# libs
library(spacyr); library(stringr); library(tokenizers); library(quanteda)
spacy_initialize(model = "en_core_web_sm")

# helpers
read_txt <- function(path) str_c(readLines(path, warn = FALSE), collapse = " ")

features <- function(txt){
  parsed <- spacy_parse(txt, dependency = TRUE, lemma = FALSE)
  total  <- nrow(parsed)
  
  # sentence length
  s <- unlist(tokenize_sentences(txt))
  w <- sapply(s, function(x) length(unlist(tokenize_words(x))))
  avg_len <- mean(w)
  
  # lexical diversity
  toks  <- tokens(txt, remove_punct = TRUE)
  words <- unlist(toks)
  
  verbs <- sum(parsed$pos == "VERB")
  nouns <- sum(parsed$pos == "NOUN")
  
  data.frame(
    avg_sentence_length   = avg_len,
    adj_density           = 100 * sum(parsed$pos == "ADJ")   / total,
    adv_density           = 100 * sum(parsed$pos == "ADV")   / total,
    pron_density          = 100 * sum(parsed$pos == "PRON")  / total,
    subord_density        = 100 * sum(parsed$dep_rel == "mark") / total,
    noun_verb_ratio       = ifelse(verbs == 0, NA, nouns / verbs),
    past_tense_pct        = ifelse(verbs == 0, NA, 100 * sum(parsed$tag %in% c("VBD","VBN")) / verbs),
    type_token_ratio      = length(unique(words)) / length(words),
    proper_noun_density   = 100 * sum(parsed$pos == "PROPN") / total,
    conj_density          = 100 * sum(parsed$pos %in% c("CCONJ","SCONJ")) / total
  )
}

# load texts
hem_hills <- read_txt("texts/hemingway/hem_hills.txt")
hem_cat   <- read_txt("texts/hemingway/hem_cat.txt")
hem_indian <- read_txt("texts/hemingway/hem_indian.txt")
hem_soldier <- read_txt("texts/hemingway/hem_soldier.txt")
hem_bthr <- read_txt("texts/hemingway/hem_bthr.txt")

hpl_colour <- read_txt("texts/lovecraft/hpl_colour.txt")
hpl_dunwich <- read_txt("texts/lovecraft/hpl_dunwich.txt")
hpl_cthulhu <- read_txt("texts/lovecraft/hpl_cthulhu.txt")
hpl_mountain <- read_txt("texts/lovecraft/hpl_mountain.txt")
hpl_outsider <- read_txt("texts/lovecraft/hpl_outsider.txt")


# results
results <- rbind(
  cbind(author = "Hemingway", text = "Hills",   features(hem_hills)),
  cbind(author = "Hemingway", text = "Cat",     features(hem_cat)),
  cbind(author = "Hemingway", text = "Indian",  features(hem_indian)),
  cbind(author = "Hemingway", text = "Soldier",     features(hem_soldier)),
  cbind(author = "Hemingway", text = "Bthr",  features(hem_bthr)),
  
  cbind(author = "Lovecraft", text = "Colour",  features(hpl_colour)),
  cbind(author = "Lovecraft", text = "Dunwich", features(hpl_dunwich)),
  cbind(author = "Lovecraft", text = "Cthulhu", features(hpl_cthulhu)),
  cbind(author = "Lovecraft", text = "Mountain",  features(hpl_mountain)),
  cbind(author = "Lovecraft", text = "Outsider", features(hpl_outsider))
)

results

write.csv(results, "author_features.csv", row.names = FALSE)
