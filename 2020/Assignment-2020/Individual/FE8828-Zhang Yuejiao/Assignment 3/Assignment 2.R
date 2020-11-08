library(fOptions)
library(conflicted)
library(tidyverse)

conflict_prefer("lag", "dplyr")
conflict_prefer("filter", "dplyr")


S0 = 1503.8525
#================
#Note: before running, pls adjust this line to locate data
#================
datapath = "~/00. Claire/01. MFE/FE8828 Programming/L3/GOOG1218_1009.csv" 

#================
#2.1
#================
# Load data and clean up
df_raw <- read.csv(datapath)
df_raw <- df_raw %>%
  select(-c(Last,Change,Volume,Last.1,Change.1,Volume.1)) %>%
  #remove '.' to make pivot_longer easier
  rename(OpenInt = `Open.Int.`, OpenInt.1 = `Open.Int..1`)%>%  
  #convert Ask, Bid, OpenInt to numeric: note: column(s) containing '--' are recoganized as charactor
  mutate(across(c(OpenInt, Ask, Bid, OpenInt.1, Ask.1, Bid.1), as.numeric))

# Convert to long format
df_long <- pivot_longer(df_raw, cols = -c(Exp..Date,Strike), names_to = c(".value",'OptionType'),names_pattern = "([:alpha:]+)([\\.1]*)")

# Update value and header per requirement
df_long <- df_long %>% 
  mutate(OptionType = ifelse(OptionType == ".1", "p","c")) %>% 
  mutate(Underlying = S0, Today = Sys.Date()) %>% 
  rename(`Open Int.` = OpenInt, `Exp. Date` = Exp..Date) %>% 
  relocate(`Open Int.`,.after = Strike)

head(df_long)
#================
#2.2
#================
# Total valuation of call and put
val <- df_long%>%
  group_by(OptionType)%>%
  summarize(Total_Val = sum(`Open Int.`*(Bid +Ask)/2, na.rm = TRUE))

cat(paste0("1) Total valueation of call alone: ", filter(val, OptionType == "c")$Total_Val),"\n")
cat(paste0("2) Total valueation of put alone: ", filter(val, OptionType == "p")$Total_Val),"\n")
cat(paste0("3) Total valueation of call and put: ", sum(val$Total_Val)),"\n")

#================
#2.3
#================
df_itm <- df_long %>% filter((OptionType == "c" & Strike < Underlying)|(OptionType == "p" & Strike > Underlying))
df_itm
cat(paste0("Total Open Interest of ITM call and put: ", sum(df_itm$`Open Int.`, na.rm = TRUE)),"\n")


#================
#2.4
#================
r = 0.03
b = 0


df_otm <- df_long %>% 
  filter((OptionType == "c" & Strike > Underlying)|(OptionType == "p" & Strike < Underlying))%>%
  mutate(`Exp. Date` = as.Date(`Exp. Date`, format = '%b-%d'))%>%
  mutate(Price = (Bid + Ask)/2)

df_otm

df_otm <- df_otm %>% rowwise() %>% 
  mutate(impVol = GBSVolatility(Price, OptionType, S = Underlying, X = Strike,
                      Time = as.numeric((as.Date(`Exp. Date`)-as.Date(Today)))/365, r, b)) %>% ungroup()
ggplot(df_otm) + 
  geom_smooth(aes(Strike, impVol), color = 'steelblue')
