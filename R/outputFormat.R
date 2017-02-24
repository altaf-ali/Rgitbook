#' Convert to Markdown format for Gitbook
#'
#' This function converts from R Markdown to a variant of markdown used
#' by Gitbook.
#'
#' @inheritParams md_document
#'
#' @export
md_gitbook_document <- function() {
  html_format <- rmarkdown::html_document()
  output_format <- rmarkdown::md_document(variant  = "markdown+backtick_code_blocks+autolink_bare_uris")
  output_format$pre_processor <- html_format$pre_processor
  return(output_format)
}
