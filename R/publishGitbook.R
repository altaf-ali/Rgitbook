#' Publish the built gitbook to Github.
#' 
#' Note that this is a wrapper to system \code{git} call.
#' 
#' This function assumes that the repository has already exists on Github.
#' 
#' Thanks to ramnathv for the shell script.
#' https://github.com/GitbookIO/gitbook/issues/106#issuecomment-40747887
#' 
#' @param repo the github repository. Should be of form username/repository.
#'        If repo paramater is omitted then 'git remote' command is used to
#'        detect the repository name.
#' @param out.dir location of the built gitbook. 
#' @param message commit message.
#' 
#' @export
publishGitbook <- function(repo = NULL, 
						   out.dir=paste0(getwd(), '/_book'),
						   message='Update built gitbook') {
  if (is.null(repo)) {
    # get repo name from git
    git_response <- system("git remote --verbose", intern = TRUE)
    if (length(git_response) != 2) { stop('Unexpected output from Git.')}
    git_remote <- git_response[1]
    pattern <- "^origin\\shttps:\\/\\/github.com\\/(.*?)\\.git\\s\\(.*\\)"
    matches <- regmatches(git_remote, regexec(pattern, git_remote))
    if (length(matches) != 1 || length(matches[[1]]) != 2) { stop('Failed to get repository name from Git.')}
    repo = matches[[1]][2]
  }

	test <- system('git --version', ignore.stderr=TRUE, ignore.stdout=TRUE, show.output.on.console=FALSE)
	if(test != 0) { stop('Git does not appear to be installed.')}
	cmd <- paste0(
		"cd ", out.dir, " \n",
		"git init \n",
		"git commit --allow-empty -m '", message,"' \n",
		"git checkout -b gh-pages \n",
		"git add . \n",
		"git commit -am '", message, "' \n",
		"git push git@github.com:", repo, " gh-pages --force ")
	system(cmd)
}
