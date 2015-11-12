#' Builds markdown files from all Rmarkdown files in the given directories.
#' 
#' This function will build Rmarkdown files in the given directory to markdown.
#' The default is to traverse all subdirectories of the working directory
#' looking for .Rmd files to process. This function will save a file in the
#' working directory called \code{.rmdbuild} that contain the status of the
#' last successful build. This allows the function to only process changed files. 
#' 
#' @param dir root directory of the gitbook project.
#' @param clean if TRUE, all Rmd files will be built regardless of their 
#'        modification date. 
#' @param log.dir if specified, the output from \code{\link{knitr}} will be saved
#'        to a log file in the given directory.
#' @param log.ext if log files are saved, the file extension to use.
#' @param ... other parameters passed to \code{\link{knit}}.
#' @export
buildRmd <- function(dir = getwd(), clean=FALSE, log.dir = NULL, log.ext='.txt', ...) {
	dir <- normalizePath(dir, winslash = "/")
	
	if(!exists('statusfile')) {
		statusfile <- '.rmdbuild'
		statusfile <- file.path(dir, statusfile)
	}
	
	rmds <- list.files(dir[1], '.rmd$', ignore.case=TRUE, recursive=TRUE, full.names=TRUE)
	finfo <- file.info(rmds)

	# move matching pattern to end of list
	moveToEnd <- function(l, pattern) {
	  pos <- grep(pattern, l, ignore.case=TRUE)
	  if(length(pos) > 0) {
	    subset <- l[pos]
	    l <- c(l[-pos], subset)
	  }
	  return(l)
	}
	
	rmds <- moveToEnd(rmds, 'references.Rmd$')
	rmds <- moveToEnd(rmds, 'SUMMARY.Rmd$')

	if(!clean & file.exists(statusfile)) {
		load(statusfile)
		newfiles <- row.names(finfo)[!row.names(finfo) %in% row.names(rmdinfo)]
		existing <- row.names(finfo)[row.names(finfo) %in% row.names(rmdinfo)]
		existing <- existing[finfo[existing,]$mtime > rmdinfo[existing,]$mtime]
		rmds <- c(newfiles, existing)
	}

	for(j in rmds) {
		if(!missing(log.dir)) {
			dir.create(log.dir, showWarnings=FALSE, recursive=TRUE)
			log.dir <- normalizePath(log.dir, winslash = "/")
			logfile <- file.path(log.dir, sub('.Rmd$', log.ext, j, ignore.case=TRUE))
			dir.create(dirname(logfile), recursive=TRUE, showWarnings=FALSE)
		}
		oldwd <- setwd(dirname(j))
		tryCatch({
		  message(sprintf("\nRendering %s", j))
		  render_cmd <- sprintf('\'Rgitbook::markdownRender("%s")\'', j)
		  cmd <- paste("Rscript", "-e", render_cmd)
		  result = system(cmd, intern = TRUE)
		  cat(paste0(result, "\n"))
		  
		}, finally={ setwd(oldwd) })
		if(!missing(log.dir)) { sink() }
	}
	
	rmdinfo <- finfo
	last.run <- Sys.time()
	last.R.version <- R.version
	message(sprintf("Writing statusfile: %s", statusfile))
	save(rmdinfo, last.run, last.R.version, file=statusfile)
	invisible(TRUE)
}
