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
  read_csv("ppg.csv", col_select = any_of(cols_select))
}
