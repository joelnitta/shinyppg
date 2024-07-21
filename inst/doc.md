## About `ppg-editor`

`ppg-editor` is a [Shiny app](https://shiny.posit.co/) for editing the [Pteridophyte Phylogeny Group (PPG)](https://pteridogroup.github.io/) taxonomic system for ferns and lycophytes.

## Starting a session

You cannot start working on the data until you start a new session or load an existing session.

The PPG data is stored as a [single CSV file](https://github.com/pteridogroup/ppg/blob/main/data/ppg.csv) at <https://github.com/pteridogroup/ppg> (during initial development of `ppg-editor`, we are using <https://github.com/pteridogroup/ppg-test> instead).

You (the user of `ppg-editor`) do not edit the CSV directly. Rather, you will work in your own *session* of the editor[^1]. Any changes you make will be subject to review before they are merged into the official dataset.

To begin working on the data in a new session, click on the "*Manage Sessions"* tab and then click "*Start new session"*. A new session will be created and automatically named. The name consists of your username, followed by a timestamp separated by a hyphen (for example, `joelnitta-240716-075447`). You cannot change the automatically created session name. The new session is created based on the most recent version of the official PPG data.

If you have any existing sessions, they will appear under "*Load an existing session"*. You can select one by clicking on its row, then load it by clicking "*Load session"*.

Now you can begin working on the data.

## Subsetting

Actually, before working on the data, it is a good idea to *subset* it, that is, to narrow it down to a smaller range, first. This is because the PPG dataset is rather large (>60,000 rows) and the app is very slow if you try to work with all of the data at once.

To subset the data, click on the "*Data Entry"* tab, then click on the "*Subset data"* sub-tab. Here, you can choose any number of orders, families, or genera that you want to subset to. You should choose the group that most narrowly defines your target -- remember, smaller is better, as far as performance is concerned. Once you have made your selection, click "*Subset data"*.

You can click "*Reset"* to undo the subsetting and switch back to the full dataset.

## Editing the data

Click on the "*Data Entry"* tab to enter the data editing mode. The (subsetted) data is visible in the main panel, and a series of fields for entering or editing data appear in the left panel in a vertical layout.

### Add a new row

To add a new row, click on the "*Add Row"* sub-tab under "*Data Entry"*.

The first thing you will probably want to enter is the scientific name. You could type it directly into the `ScientificName` field, but this is not advised because it is easy to make spelling mistakes. In particular, PPG uses [IPNI formatting of author names](https://www.ipni.org/about#about-the-authors-dataset)[^2]. In the IPNI system, every author has a specific abbreviation (for example `J.H.Nitta` for Joel H. Nitta; spaces are generally not used).

Instead of typing directly into the `ScientificName` field, you can start typing the a genus, specific epithet, or author in those respective fields above `ScientificName`, and select one of the names that appears. Once you select a name, it will automatically be added to `ScientificName`. This way, you can build up a name while avoiding any spelling errors.

All other fields correspond to [Darwin Core Taxon (Dwc Taxon) columns](https://dwc.tdwg.org/terms/#taxon)[^3]. Once you have filled in the fields, click "*Add row"* at the bottom of the left panel.

You should see the new row appear at the top of the data. By default the data is sorted with the most recently edited (or added) rows at the top.

### Modify an existing row

To edit an existing row, click on the "*Edit Row"* sub-tab under "*Data Entry"*.

The fields on the left are the same as "*Add Row"*, but now if you select a row by clicking on it, the fields are automatically filled from the currently selected row. Edit the fields as needed, then click "*Modify Row"* at the bottom of the left panel.

Notice that if you modify a name with one or more synonyms, the synonyms will also be modified as needed. So even if you modify only one name, you may see that multiple names have been modified.

For example:

- Before modification:
  - Accepted species 1: *Cephalomanes crassum*
    - Synonym: *Trichomanes crassum*
  - Accepted species 2: *Cephalomanes densinervium*
    - Synonym: *Trichomanes densinervium*

- After modification: (*C. crassum* → synonym of *C. densinervium*):
  - Accepted species: *Cephalomanes densinervium*
    - Synonym 1: *Cephalomanes crassum*
    - Synonym 2: *Trichomanes crassum*
    - Synonym 3: *Trichomanes densinervium*

In this case, even though you only made one change (*C. crassum* → synonym of *C. densinervium*), it would result in modifying **two** names, since *C. crassum* "brings along" its synonym *T. crassum*.

The time stamp of each row will be automatically updated to reflect when you made the modification.

### Deleting rows

You can delete one or more rows by clicking on one or more rows to select them, then click the "*Delete row"* button at the bottom of the left panel.

### Undoing an edit

You can undo edits one at a time by clicking "*Undo"*. An undo is permanent (there is no "*redo"* button). Also, if you reset the subsetting or load a new session, you will lose your undo history (you lose the ability to undo anything up to that point).

### Selecting and filtering rows

You can select one or more rows in the main panel of the editor by clicking on them. Selected rows appear blue.

You can filter the data by typing into the text entry boxes above each column, or by using the search bar.

Note that while you have filtered the data, any selected rows stay selected (even though you can't see them). By combining selecting and filtering, you can select a very specific set of rows (for example, all accepted species in each of two genera, etc.).

## Saving a session

You can save your session in the "*Manage Sessions"* tab. The title must be less than 50 characters. The summary may be longer.

Please phrase the title as an active sentence, for example `Synonymize Homalosorus with Diplaziopsis`.

If your changes implement an approved PPG proposal, please indicate this by including the phrase `Fixes #<propsal-number>` in the summary, for example `Fixes #82`. The rest of the summary can include any relevant details. If you are having trouble [passing validation](#validating-data), please describe your problem here.

You should generally focus on one taxonomic group per session. It is better to make smaller sets of changes across multiple sessions than many unrelated changes in one long session, since your changes must be reviewed before they can be approved.

## Validating data

Before you can [submit your changes for approval](#submitting-changes-for-approval), you need to pass data validation.

Click on the "*Data Validation"* tab, the click the "*Validate"* button. If the data are valid, you will see a "*Validation passed"* notification appear. If the data are not valid, a table will appear describing the failed checks.

If such a table appears, you should use the information in it to revise your data, and run validation again. Repeat this process until validation passes. Note that the error messages will often refer to `taxonID`; see [About advanced columns](#about-advanced-columns) for more information on this topic.

## Settings

Overall settings for the app can be found in the "*Settings"* tab.

## About advanced columns

In `ppg-editor`, *advanced columns* include `taxonID` and related columns.
`taxonID` is a column with a unique identifier code for each row in the data.
The identifier code is a string of 32 numbers and letters.
They are automatically generated, and the user generally should not need to edit or view them.

The reason `taxonID` is needed is that `scientificName` is not always unique. In theory, `scientificName` (taxon including author) should be unique, but during taxonomic history, some names have been published by the same author more than once. So another column is required to distinguish scientific names; this is `taxonID`.

The reason that multiple advanced columns exist besides `taxonID` is because of columns that link rows, such as `acceptedNameUsage` (the accepted name of a synonym) and `parentNameUsage` (the parent of a taxon). Since `scientificName` is not necessarily unique, it cannot be used to uniquely identify an accepted name or parent. So in addition to `acceptedNameUsage` and `parentNameUsage`, we have `acceptedNameUsageID` and `parentNameUsageID` (the `taxonID` corresponding to the the accepted name of a synonym and the parent of a taxon, respectively).

Again, the values of these advanced columns should generally not be edited by the user, nor should the user need to see them. But in case it becomes necessary, they can be shown by clicking the "*Show advanced columns"* button beneath the data in the main panel or the "Show advanced options" button at the bottom of the left panel.

## Submitting changes for approval

*To come*

This part is still under development.

## More information

`ppg-editor` uses the `dwctaxon` R package for editing and validation of taxonomic names. Although you do not need to know R to use `ppg-editor`, you may find [the documentation for `dwctaxon`](https://docs.ropensci.org/dwctaxon/articles/what-is-dwc.html) has useful information to understand the process of working with Darwin Core Taxon data.

[^1]: A *session* in the `ppg-editor` is the same thing as a *branch* in Git.

[^2]: The IPNI author naming scheme is based on [Brummitt & Powell, Authors of Plant Names (1992)](https://en.wikipedia.org/wiki/Authors_of_Plant_Names).

[^3]: Except for `ipniURL`, `modifiedBy`, and `modifiedByID`.