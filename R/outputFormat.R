#' Convert to Markdown format for Gitbook 
#'  
#' This function converts from R Markdown to a variant of markdown used
#' by Gitbook.
#' 
#' @inheritParams md_document
#'
#' @export
md_gitbook_document <- function() {
  rmarkdown::md_document(variant  = "markdown_github+backtick_code_blocks+autolink_bare_uris")
}
