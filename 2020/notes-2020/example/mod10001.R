# mod10001.R

mod_x <- function(a, b) {
  MOD <- 10001
  if (b == 1) {
    a %% MOD
  } else if (b == 2) {
    mod_x(mod_x(a, 1) ^ 2, 1)
  } else if (b == 5) {
    mod_x(mod_x(a, 2) * mod_x(a, 2) * mod_x(a, 1), 1)
  } else if (b == 10) {
    mod_x(mod_x(a, 2), 5)
  } else {
    stop("Unknown b")
  }
}

# Test
mod_x(2, 10) == 1024 # 1024
mod_x(mod_x(2, 10), 10) == 4966 # 1024
mod_x(mod_x(2, 10), 10) # 

final_res <- mod_x(2, 10)

for (i in 1:99) {
  final_res <- mod_x(final_res, 10)
}
final_res

