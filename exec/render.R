require(rmarkdown)
require(knitcitations)

rmarkdown_render <- function(dir, filename, clean) {
  bib <- NULL
  knitenv <- new.env()
  assign('bib', bib, envir=knitenv)
  
  knitenv <- new.env()
  bibs <- list.files(dir[1], '.bib$', ignore.case=TRUE)
  if(length(bibs) > 0) {
    newbib <- read.bibtex(paste0(dir, '/', bibs[1]))
    if(clean | is.null(bib)) {
      if(length(bibs) > 1) { #TODO: support more than one bib file
        warning(paste0('More than one BibTex file found. Using ', bibs[1]))
      }
      cleanbib()
      bib <- newbib
    } else {
      # This will any new references to the bib object
      newbibs <- names(newbib)[!names(newbib) %in% names(bib)]
      for(i in newbibs) {
        bib[i] <- newbib[i]
      }
    }
    assign('bib', bib, envir=knitenv)
  }
  
  output_file <- sub('.Rmd$', '.md', basename(filename), ignore.case=TRUE)
  #rmarkdown::render(basename(filename), output_format = "md_document", output_file = output_file, envir=knitenv)
  knitr::knit(basename(filename), output_file, envir=knitenv)
}