#' icecream - Never use print() to debug again
#'
#' @description Do you ever use print() or log() to debug your code?
#' Of course you do. IceCream, or ic for short, makes print debugging
#' a little sweeter. It provides a function that tells you where in your
#' code it was called or, if an expression is passed to it, what the value
#' of that expression is.
#'
#' @author Dominik Rafacz
#' @docType package
#' @name icecream-package
#' @aliases icecream
NULL


#' Print debugging information with less effort and more clarity
#'
#' @description This function is designed to be used inside the code that is being debugged.
#' If called without any arguments, prints information on where it was called. If called
#' with an expression inside, it prints both the expression and its value.
#'
#' @param expr (optional) An expression to evaluate.
#'
#' @return A value of the passed expression returned invisibly. If no expression was
#' provided, \code{NULL}.
#'
#' @details
#' If an expression is given as an argument, it is always evaluated and output is returned.
#' If no argument is supplied, information about where the function was called is printed:
#' the file name, the exact line and column number, and the name of the function within which
#' the function was called. However, this functionality is more sensitive. If the function is
#' called directly from the console, information about the missing source is displayed.
#' Finding the file source itself is based on the \link[rlang]{trace_back} function and is
#' subject to its limitations.
#'
#' @examples
#' # using ic() in the console is aimless, it should be used inside other functions
#' # or when sourcing a file
#' \donttest{
#' ic()
#'
#' foo <- function() {
#'   2 + 3
#'   ic()
#'   3 + 4
#'   ic()
#' }
#'
#' foo()
#'
#' bar <- function(x) x + 123
#'
#' ic(bar(765))
#'
#' a <- ic(234 + 876)
#'
#' }
#'
#' @importFrom rlang trace_back enquo eval_tidy is_missing as_label
#' @importFrom cli console_width
#' @export
ic <- function(expr) {
  argq <- enquo(expr)
  if (is_missing(expr)) {
    trace <- trace_back()
    num_calls <- length(trace$calls)
    parent_ref <-  if (num_calls > 1) trace$calls[[num_calls - 1]][[1]] else NULL
    ref <- attr(trace$calls[[num_calls]], "srcref")
    loc <- rlang:::src_loc(ref)
    if (nchar(loc) == 0)
      loc <- "[filename unavailable]"
    cat(paste0("ic| ", loc,
               if (is.null(parent_ref)) "" else paste0(" in ", as_label(parent_ref)), "\n"))
  } else {
    value <- eval_tidy(argq)
    printed <- capture.output(print(value))
    if (length(printed) <= 1) {
      if (nchar(printed) + 5 < console_width()) {
        cat(paste0("ic| ", as_label(argq), ": ", printed, "\n"))
      } else {
        cat(paste0("ic| ", as_label(argq), ":\n", printed, "\n"))
      }
    } else {
      cat(paste0("ic| ", as_label(argq), ":\n"))
      cat(paste(printed, collapse = "\n"), "\n")
    }
    invisible(value)
  }
}
