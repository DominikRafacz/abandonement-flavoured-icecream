library(withr)

foo <- function(x) x + 25

test_that("ic called with single argument return value of this argument", {
  with_tempfile("sink_file", {
    with_output_sink(sink_file, {
      expect_equal(ic(100), 100)
      expect_equal(ic("ABCDE"), "ABCDE")
      expect_equal(ic(125 + 734), 125 + 734)
      expect_equal(ic(sum(seq(1, 10))), sum(seq(1, 10)))
      expect_equal(ic(foo(0)), foo(0))
    })
  })
})

test_that("ic prints value correctly", {
  expect_equal(capture_output(ic(100)), "ic| 100: [1] 100")
  expect_equal(capture_output(ic(foo(12))), "ic| foo(12): [1] 37")
})
