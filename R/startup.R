# Define vectors used in the app ----

# Valide Darwin Core (DwC) Taxon terms (columns)
dct_terms <- dwctaxon::dct_terms

# Columns to display in the main ppg dataframe
cols_select <- c(
  "scientificName",
  "taxonRank",
  "taxonomicStatus",
  "namePublishedIn",
  "taxonRemarks",
  "acceptedNameUsage",
  "parentNameUsage",
  "taxonID",
  "acceptedNameUsageID",
  "parentNameUsageID",
  "modified",
  "modifiedBy",
  "modifiedByID"
)

# Valid values to use for taxonomicStatus
valid_tax_status <- c(
  "accepted",
  "synonym",
  "ambiguous synonym",
  "variant"
)

# Valid values to use for taxonomicRank
valid_tax_rank <- c(
  "species",
  "genus",
  "tribe",
  "subfamily",
  "family",
  "order",
  "form",
  "subspecies",
  "variety"
)

# Define validation settings ----

dwctaxon::dct_options(
  check_sci_name = FALSE,
  check_mapping_accepted_status = TRUE,
  valid_tax_status = paste(valid_tax_status, collapse = ", "),
  stamp_modified_by = TRUE,
  stamp_modified_by_id = TRUE,
  extra_cols = c("modifiedBy", "modifiedByID")
)

# Create environment to store data across functions (used for patch list)
pkg_env <- new.env(parent = emptyenv())
