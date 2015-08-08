#' This function clean the files generated from a previous call to buildGitbook().
#' #' 
#' @param source.dir location containing the source files.
#' @param out.dir location of the built book.
#' @export
cleanGitbook <- function(source.dir=getwd(), out.dir=file.path(getwd(), '_book')) {
  source.dir <- normalizePath(source.dir)
  
  delete_dir <- function(dir) {
    if (dir.exists(dir)) {
      message(sprintf("removing directory %s", dir))
      unlink(dir, recursive = TRUE, force = TRUE)
    }
  }

  delete_file <- function(file) {
    if (file.exists(file)) {
      message(sprintf("removing %s", file))
      unlink(file)
    }
  }
  
  delete_generated_files <- function(input.ext, output.ext) {
    input.re = sprintf("\\.%s$", input.ext)
    output.re = sprintf(".%s", output.ext)
  
    files <- list.files(source.dir[1], input.re, ignore.case=TRUE, recursive=TRUE, full.names=TRUE)
    generated_files <- lapply(files, function(f) sub(input.re, output.re, f, ignore.case=TRUE))
    lapply(generated_files, delete_file)
  }

  # delete output dirtory and default log directory
  delete_dir(out.dir)  
  delete_dir(file.path(source.dir, ".log"))
  
  # delete rmbuild
  rmdbuild_files <- list.files(source.dir[1], "^\\.rmdbuild$", recursive=TRUE, full.names=TRUE, all.files = TRUE)
  lapply(rmdbuild_files, delete_file)

  # delete all figures
  tmp_dirs <- list.files(source.dir[1], "^figure$", recursive=TRUE, full.names=TRUE, include.dirs = TRUE)
  lapply(tmp_dirs, delete_dir)
  
  # delete all generated files
  delete_generated_files("md", "html")
  delete_generated_files("Rmd", "md")
  
  # HACK  
  tmp_dirs <- list.files(source.dir[1], "(lab|solutions)_files", recursive=TRUE, full.names=TRUE, include.dirs = TRUE)
  lapply(tmp_dirs, delete_dir)
  
  invisible(0)
}

                         