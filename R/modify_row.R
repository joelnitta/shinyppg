#' UI for modifying a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @returns UI
#' @noRd
modify_row_ui <- function(id) {
  tagList(
    textInput(
      NS(id, "taxonID"),
      label = "Taxon ID"
    ),
    textInput(
      NS(id, "scientificName"),
      label = "Scientific name"
    ),
    textInput(
      NS(id, "namePublishedIn"),
      label = "Name published in"
    ),
    textInput(
      NS(id, "taxonRank"),
      label = "Taxonomic rank"
    ),
    textInput(
      NS(id, "taxonomicStatus"),
      label = "Taxonomic status"
    ),
    textInput(
      NS(id, "taxonRemarks"),
      label = "Taxon remarks"
    ),
    textInput(
      NS(id, "acceptedNameUsageID"),
      label = "Taxon ID of accepted name"
    ),
    textInput(
      NS(id, "acceptedNameUsage"),
      label = "Accepted name"
    ),
    textInput(
      NS(id, "parentNameUsageID"),
      label = "Taxon ID of parent name"
    ),
    textInput(
      NS(id, "parentNameUsage"),
      label = "Parent name"
    ),
    actionButton(NS(id, "apply"), "Apply")
  )
}

#' Server logic to modify a row
#'
#' Internal function
#'
#' @import shiny
#' @param id Character vector of length 1; the ID for this module.
#' @param ppg Reactive dataframe (tibble) of PPG data
#' @returns Server logic
#' @noRd
modify_row_server <- function(id, ppg, rows_selected) {

  # Check args
  stopifnot(is.reactive(ppg))
  stopifnot(is.reactive(rows_selected))

  moduleServer(id, function(input, output, session) {
    # Modify one row
    observeEvent(input$apply, {
      updated_data <- dwctaxon::dct_modify_row(
        ppg(),
        taxonID = null_if_blank(input$taxonID),
        scientificName = null_if_blank(input$scientificName),
        namePublishedIn = null_if_blank(input$namePublishedIn),
        taxonRank = null_if_blank(input$taxonRank),
        taxonomicStatus = null_if_blank(input$taxonomicStatus),
        taxonRemarks = null_if_blank(input$taxonRemarks),
        acceptedNameUsageID = null_if_blank(input$acceptedNameUsageID),
        acceptedNameUsage = null_if_blank(input$acceptedNameUsage),
        parentNameUsageID = null_if_blank(input$parentNameUsageID),
        parentNameUsage = null_if_blank(input$parentNameUsage)
      )
      ppg(updated_data)
    })
    # Fill in row editing text boxes with data from selected row
    observeEvent(rows_selected(), {
      if (length(rows_selected()) > 0) {
        selected_row <- ppg()[rows_selected(), ]
        updateTextInput(
          session,
          "taxonID",
          value = selected_row$taxonID
        )
        updateTextInput(
          session,
          "scientificName",
          value = selected_row$scientificName
        )
        updateTextInput(
          session,
          "namePublishedIn",
          value = selected_row$namePublishedIn
        )
        updateTextInput(
          session,
          "taxonRank",
          value = selected_row$taxonRank
        )
        updateTextInput(
          session,
          "taxonomicStatus",
          value = selected_row$taxonomicStatus
        )
        updateTextInput(
          session,
          "taxonRemarks",
          value = selected_row$taxonRemarks
        )
        updateTextInput(
          session,
          "acceptedNameUsageID",
          value = selected_row$acceptedNameUsageID
        )
        updateTextInput(
          session,
          "acceptedNameUsage",
          value = selected_row$acceptedNameUsage
        )
        updateTextInput(
          session,
          "parentNameUsageID",
          value = selected_row$parentNameUsageID
        )
        updateTextInput(
          session,
          "parentNameUsage",
          value = selected_row$parentNameUsage
        )
      }
    })
  })
}
