for (rr in 1:nrow(lj)) {
  rdata <- as.list(lj[rr, ])
  cons_ric <- rdata$`Constituent RIC`
  cons_change <- rdata$Change
  cons_date <- rdata$Date
  if (cons_change == "Leaver") {
    # add it to it
    # find it
    nn <- which(cons_ric == ic_list)
    if (length(nn) == 1) {
      stop(paste0("Found it: ", cons_ric ,"\n"))
    } else {
      cat(paste0("Add ", cons_ric, " on ", cons_date, "\n"))
      ic_list <- c(ic_list, cons_ric)
    }
  } else {
    # find it
    nn <- which(cons_ric == ic_list)
    if (length(nn) == 1) {
      # remove it
      ic_list <- ic_list[-nn]
      cat(paste0("Del ", cons_ric, " on ", cons_date, "\n"))
    } else {
      stop(paste0("Can't find it: ", cons_ric ,"\n"))
    }
  }
}

ic$`Constituent RIC`
