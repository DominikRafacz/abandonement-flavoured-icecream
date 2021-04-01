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
               if (is.null(parent_ref)) "" else paste0(" at ", as_label(parent_ref)), "\n"))
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
