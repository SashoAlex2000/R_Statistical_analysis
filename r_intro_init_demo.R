

# putting a question mark in front of a function/method (?) 
# opens a helper descriptive window 
?mean

# calculator
a <- 2
b <- 13
a + b

sum(a+b)

# concatenation
some_data <- c(a, b)
some_data # 2 13
sum(some_data)

prod_names <- c('bread', 'chicken')

prices <- data.frame(prod_names, some_data)
View(prices)
str(prices)

prices$some_data
sum(prices$some_data)

add_one <- function(x) {
  x + 1 
}

test_var_c = add_one(b)
test_var_c

# access the DataFrame like a matrix, with indeces;
# counting starts from 1 ?
prices[1,1] # "bread"
prices[1, ] # bread 2 
prices[,1] # bread chicken
prices[2,2] # 13
prices[,2] # 2 13


# Build in data sets
data()
View(starwars) # object not found - included in tidyverse
View(ChickWeight)

# install only once, include in each scrpit with library()
install.packages("tidyverse")
library(tidyverse)

View(starwars)

# Shift + ctr + M => Piper operator
starwars %>% 
  filter(height > 150 & mass > 100) %>% 
  mutate(height_in_meters = height/100) %>% 
  select(name, height_in_meters, mass) %>% 
  arrange(-mass) %>% 
  View()
  # plot() # plot with three parameters is messed af


# --------------------------
# Mammal Sleep Data - msleep

view(msleep)
glimpse(msleep)
head(msleep)

class(msleep$name) # character

length(msleep) # number of  variables (columns)
length(msleep$name) # number of observations (rows)

names(msleep) # all the names of the columns

unique(msleep$vore)

missing <- !complete.cases(msleep)
missing

msleep[missing,] # get all rows with missing data
# How to take the rows without missing data?
# just get the condition to be without '!' ...

full_rows = complete.cases(msleep)
full_rows

msleep[full_rows,]

# Alternatively:
rows_without_missing <- subset(msleep, complete.cases(msleep))
rows_without_missing

# Data cleanup - SW

starwars %>% 
  select(name, height, mass)
  
starwars %>% 
  select(0:3) # equivalent to previous

starwars %>% 
  select(name, ends_with("color"))

# order can be shifted arround 
starwars %>% 
  select(name, hair_color, mass, height, everything()) %>% 
  View()

starwars %>% 
  rename("NEW_name_first" = "name") %>%
  head()

# The class is character - not recognized as categorical variable
class(starwars$hair_color)

starwars$new_hair_color <- as.factor(starwars$hair_color)
class(starwars$new_hair_color)

# get all the unique categorical variables
unique_factor_hair_colors <- levels(starwars$new_hair_color)
unique_factor_hair_colors

# factor order - sometimes it matters, as it can be scaled - big, bigger, biggest

df <- starwars
df$sex <- as.factor(df$sex)

# alphabetic order
levels(df$sex)

df <- df%>% 
  mutate(sex=factor(sex,
                    levels = c("male", 
                               "female", 
                               "hermaphroditic", 
                               "none")))

# ordered in the custom order now
levels(df$sex)

# select filters cols, filter filters rows
starwars %>% 
  select(name, mass, sex) %>% 
  filter(mass < 75 & 
           mass > 50 & 
           sex %in% c("male", "female")) %>% 
  View()

data(starwars)

# Re-code data to different values
# the re-coding works here, but the changes are 
# not reflected on further inspections: because
# the %>% operator creates a new environment
# to make the changes persistent save to the variable ->
# this bugs out everything and data becomes unusable unless reloaded again :D

# Error in View : no applicable method for 'select' 
# applied to an object of class "NULL"

# starwars <-starwars %>% 
starwars %>% 
  select(name, hair_color, sex) %>% 
  mutate(sex = recode(sex,
                      "male" = "man",
                      "female" = "woman",
                      .default = "other")) %>% 
  View()

starwars %>% 
  select(name, mass, sex) %>% 
  View()

