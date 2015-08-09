#' Renders an RMarkdown file to markdown
#'  
#' This function should generally be called from Rscript to ensure a clean 
#' environment but is also callable from external applications. It currently
#' uses knitr::knit() to render the Rmarkdown file.
#' 
#' @param dir is the directory of the project
#' @param filename is the name of the file to be rendered. 
#'        The filename must end in .Rmd and will be rendered to .md file
#' @export
markdownRender <- function(dir, filename) {
  output_file <- sub('.Rmd$', '.md', basename(filename), ignore.case=TRUE)
  knitr::knit(basename(filename), output_file, envir = globalenv())
}
