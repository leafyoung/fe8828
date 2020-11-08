library(conflicted)
library(readr)
library(dplyr)
library(stringr)
library(fOptions)
library(ggplot2)
conflict_prefer("lag","dplyr")
conflict_prefer("filter","dplyr")

# Q2.1 Data Cleaning/Munging
# Set the working directory and read the .csv file
setwd('~/Studies/NTU MFE/T1MT2 FE8828 Programming Web Applications in Finance (E)/Homeworks/Assignment3')
raw_df <- read_delim("goog_options.csv", ',', escape_double = FALSE, trim_ws = TRUE)

# replace "--" with "0.0" in the dataset
raw_df[raw_df == "--"] <- "0.0"

# convert all 'characters'-type columns to numeric-type, except 'Exp. Date' column
# Remove a nasty space at the back of the characters
cols <- names(raw_df)[vapply(raw_df, is.character ,TRUE)]
cols <- cols[cols != 'Exp. Date']
raw_df[,cols] <- sapply(raw_df[,cols], str_trim)
raw_df[,cols] <- sapply(raw_df[,cols], as.numeric)

# Split the dataframe into 2: 1 for calls, 1 for puts
# As the column names are duplicated for puts, '_1' is added to each duplicated column name
df1 <- select(raw_df, !contains("_1"))
df2 <- select(raw_df, contains("_1"))
names(df2) <- sub("_1","",names(df2))

# Since the calls and the puts dataframe share the 'Exp. Date' and the 'Strike' columns,
# We replicate them for the puts dataframe and indicate the option type. 
# Then, we join both the dataframes using bind_rows
df2['Exp. Date'] <- raw_df['Exp. Date']
df2['Strike'] <- raw_df['Strike']
df1['OptionType'] <- "c"
df2['OptionType'] <- "p"
df <- bind_rows(df1, df2)

# We select only those relevant columns and include 2 more columns:
# Current underlying asset price ('Underlying') & Today date ('Today)
df <- select(df, "Exp. Date", "Strike", "Open Int.", "OptionType", "Bid", "Ask")
df['Underlying'] <- 1458.42
df['Today'] <- "2020-10-04"
print(as.data.frame(df))

# Q2.2 Calcualte the total valuation of 1) call alone, 2) put alone, 3) call and put.
# First, we calculate the valuation for each strike price and for each option type
df %>% 
  mutate(Valuation = `Open Int.` * (Bid + Ask) / 2) -> df

# Then we filter accordingly and sum the valuation to get the total valuation.
# For call alone: 
df %>% 
  filter(OptionType=="c") %>% summarise(TotalValuation=sum(Valuation))

# For put alone: 
df %>% 
  filter(OptionType=="p") %>% summarise(TotalValuation=sum(Valuation))

# For both call and put: 
summarise(df, TotalValuation=sum(Valuation))

# Q2.3 The total open interest of in-the-money options
# First we filter those calls whose strikes are lower than the underlying price
# and those puts whose strikes are higher than the underlying price
# Then we sum their open interest to get total open interest.
df %>% 
  filter((Strike < Underlying & OptionType=="c") | (Strike > Underlying & OptionType=="p")) %>% 
  summarise("total Open Int." = sum(`Open Int.`))

# Q2.4 Plotting the volatility curve
# Using GBSVolatility to calculate the volatility for options of different strikes and different option types.
df %>% 
  rowwise() %>% 
  mutate(Volatility = GBSVolatility((Bid+Ask)/2,OptionType,Underlying,Strike,as.numeric((as.Date("2020-12-18") - as.Date(Today)))/365,r=0.03,b=0)) %>% 
  ungroup() -> df

# Filter calls whose strikes are higher than underlying price and puts whose strikes are lower than underlying price
# i.e. Select those out-of-money options to plot the volatility curve.
ggplot(data=filter(df, (Strike > Underlying & OptionType=="c") | (Strike < Underlying & OptionType=="p")),aes(x = Strike, y = Volatility)) +
  geom_point() +
  geom_line()