#' This function clean the files generated from a previous call to buildGitbook().
#' #' 
#' @param source.dir location containing the source files.
#' @param out.dir location of the built book.
#' @export
cleanGitbook <- function(source.dir=getwd(), out.dir=file.path(getwd(), '_book')) {
  source.dir <- normalizePath(source.dir)
  
  delete_dir <- function(dir) {
    if (dir.exists(dir)) {
      message(sprintf("removing directory: %s", dir))
      unlink(dir, recursive = TRUE, force = TRUE)
    }
  }

  delete_file <- function(file) {
    if (file.exists(file)) {
      message(sprintf("removing file: %s", file))
      unlink(file)
    }
  }
  
  delete_all <- function(input.pattern, 
                         output.subst = NULL, 
                         all.files = FALSE,
                         include.dirs = FALSE) {
    
    files <- list.files(source.dir[1], 
                        input.pattern, 
                        ignore.case=TRUE, 
                        recursive=TRUE, 
                        full.names=TRUE, 
                        all.files = all.files,
                        include.dirs = include.dirs)
    
    if (is.null(output.subst))
      out_files = files
    else
      out_files <- lapply(files, function(f) sub(input.pattern, output.subst, f, ignore.case=TRUE))
    
    lapply(out_files, ifelse(include.dirs, delete_dir, delete_file))
  }

  # delete output dirtory and default log directory
  delete_dir(out.dir)  
  delete_all("^.log$", all.files = TRUE, include.dirs = TRUE)
  
  # delete all figures
  delete_all("^figure$", include.dirs = TRUE)

  # delete all generated files
  delete_all("\\.Rmd$", "_files", include.dirs = TRUE)
  delete_all("\\.md$", ".html")
  delete_all("\\.Rmd$", ".md")
  
  # delete rmbuild
  delete_all("^\\.rmdbuild$", all.files = TRUE)
  
  invisible(0)
}

                         