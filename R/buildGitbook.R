#' This will build a gitbook from the source markdown files.
#'
#' This function is simply a wrapper to a system call to \code{gitbook}.
#'
#' \url{https://github.com/GitbookIO/gitbook}
#'
#' @param source.dir location containing the source files.
#' @param out.dir location of the built book.
#' @param format the format of book. Options are pdf or ebook. If omitted,
#'        this will build a website.
#' @param buildRmd should \code{\link{buildRmd}} be called first.
#' @param gitbook.params other parameters passed to the gitbook command.
#' @param ... other parameters passed to \code{\link{buildRmd}}.
#' @export
buildGitbook <- function(source.dir=getwd(),
						 out.dir=paste0(getwd(), '/_book'),
						 buildRmd = TRUE,
						 clean=FALSE,
						 log.dir,
						 format,
						 gitbook.params, ...) {
	if(buildRmd) {
		message('Building R markdown files...')
		buildRmd(source.dir, clean=clean, log.dir=log.dir, ...)
		message('R Markdown files successfully built!')
	}

	checkForGitbook(quiet=TRUE)

	buildCmd <- 'build'
	buildCmd <- 'build --log debug'
	if(!missing(format)) { buildCmd <- format }
	cmd <- paste0("gitbook ", buildCmd, " ", source.dir, " --output=", out.dir)
	message(sprintf("Running gitbook: %s", cmd))
	#if(!missing(title)) { cmd <- paste0(cmd, ' --title="', title, '"') }
	#if(!missing(intro)) { cmd <- paste0(cmd, ' --intro="', intro, '"') }
	#if(!missing(github)) { cmd <- paste0(cmd, ' --github=', github) }
	#if(mathjax) { cmd <- paste0(cmd, " --plugins plugin-mathjax") }
	if(!missing(gitbook.params)) { cmd <- paste0(cmd, " ", gitbook.params)}
	system(cmd)
}
