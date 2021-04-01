#' @importFrom rlang trace_back
#' @export
ic <- function(x = NULL) {
  if (is.null(x)) {
    trace <- rlang::trace_back()
    num_calls <- length(trace$calls)
    ref <- attr(trace$calls[[num_calls]], "srcref")
    loc <- rlang:::src_loc(ref)
    cat(paste0("ic | ", " ", loc))
  }
}
