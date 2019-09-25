Book1 <- read_excel("Book1.xlsx", sheet = "Sheet2", 
                    col_types = c("text", "text", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric"))
Book1 <- mutate(Book1,
                Call_Put = "Call",
                Expiry = as.Date("2019-12-20"),
                Underlying = 1234.03)
colnames(Book1)
df <- bind_rows(Book1, Book2)

df1 <- mutate(df, Value = `Open Interest` * (Bid + Ask)/2)

df_call <- df1 %>% filter(Call_Put == "Call")
df_put <- df1 %>% filter(Call_Put == "Put")

df1[, "Open Interest"]
