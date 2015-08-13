#' Renders an RMarkdown file to markdown
#'  
#' This function should generally be called from Rscript to ensure a clean 
#' environment but is also callable from external applications. It currently
#' uses knitr::knit() to render the Rmarkdown file.
#' 
#' @param input_file is the name of the file to be rendered. 
#'        The filename must end in .Rmd and will be rendered to .md file
#' @export
markdownRender <- function(input_file) {
  library(methods)

  rmarkdown::render(input_file, 
                    output_file = sub('.Rmd$', '.md', basename(input_file), ignore.case=TRUE), 
                    output_format = "Rgitbook::md_gitbook_document", 
                    envir = globalenv())
}


