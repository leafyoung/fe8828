# 2-ex-2.R

print_months <- function() {
  for (nn in 1:12) {
    cat(paste0(as.character(as.Date(paste0("2019-", nn, "-01")), format = "%B"), "\n"))
  }
}

print_months()

(
  function() {
    for (nn in 1:12) {
      cat(paste0(as.character(as.Date(paste0("2019-", nn, "-01")), format = "%B"), "\n"))
    }
  }
)()