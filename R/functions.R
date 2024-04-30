cols_select <- c("taxonID",
"acceptedNameUsageID",
"scientificName",
"namePublishedIn",
"taxonRank",
"vernacularName",
"taxonomicStatus",
"taxonRemarks",
"parentNameUsageID",
"acceptedNameUsage",
"parentNameUsage",
"modified")

load_data <- function() {
  url <- "https://raw.githubusercontent.com/pteridogroup/ppg/main/data/ppg.csv"
  read_csv(url, col_select = any_of(cols_select))
}
