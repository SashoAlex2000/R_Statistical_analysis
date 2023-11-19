

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

# reload the data
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

# missing data
mean(starwars$height) # returns NA

mean(starwars$height, na.rm = TRUE) # remote the NA values

#duplicates
d_names <- c("Ivan", "Petar", "Georgi", "Ivan")
d_ages <- c(22,23,24,22)

d_df <- data.frame(d_names, d_ages)
d_df

d_df %>% 
  distinct()

# aleternatively
distinct(d_df)

# Data manipulation

starwars %>% 
  mutate(height_m = height/100) %>% 
  mutate(tallness_qual = if_else(height_m < 1,
                                 "short",
                                 "tall")) %>% 
  select(name, height, height_m, tallness_qual) 
  

# Library
install.packages("gapminder")
library(gapminder)
View(gapminder)

# the dataset can be passed in as the first argument
gm_data <- select(gapminder, country, year, lifeExp)

View(gm_data)

wide_gm_data <- gm_data %>% 
  pivot_wider(
    names_from = year,
    values_from = lifeExp
  )

View(wide_gm_data)

# go back
longa_gm_data <- wide_gm_data %>% 
  pivot_longer(2:13,
               names_to = "year",
               values_to = "lifeExp")

View(longa_gm_data)

# Describe
View(msleep)

min(msleep$awake)
max(msleep$awake)
range(msleep$awake)
IQR(msleep$awake)

mean(msleep$awake)
median(msleep$awake)
mode(msleep$awake) # numberic ?

var(msleep$awake)

summary(msleep$awake)

msleep %>% 
  select(awake, sleep_rem, sleep_rem, sleep_total) %>% 
  summary()


# group by 'vore' (type of eating), and create a summary table
msleep %>% 
  drop_na(vore) %>% 
  group_by(vore) %>% 
  summarise(Lower = min(sleep_total),
            Average = mean(sleep_total),
            Upper = max(sleep_total), 
            Difference = 
              max(sleep_total) - min(sleep_total)) %>% 
  arrange(Average) %>% 
  View()


# tables
table(msleep$vore)

msleep %>% 
  select(vore, order) %>% 
  filter(order %in% c("Rodentia", "Primates")) %>% 
  table()

# Data visualization
plot(pressure)

View(starwars)

# ggplot is included in tidyverse
# mapping - define aesthetics
# plus instead of the pipe operator
ggplot(data=starwars, 
       mapping=aes(x=sex)) + geom_bar()
  

# do the things before plotting
# when using the piping operator, there is no need to explicitly pass in the 
# first argument to ggplot for example, assumed by default
starwars %>% 
  drop_na %>%
  ggplot(mapping = aes(x=height)) + 
  geom_histogram()


# Box pots ???
starwars %>% 
  drop_na(height) %>% 
  ggplot(aes(height))+
  geom_boxplot(fill="steelblue")+
  theme_bw()+
  labs(title="Boxplot; height", 
       x = "Height of the characters")

# density plot; alpha is the density of color in chart
starwars %>% 
  drop_na(height) %>% 
  filter(sex %in% c("male", "female")) %>% 
  ggplot(mapping = aes(x=height,
                       color=sex,
                       fill=sex))+
  geom_density(alpha=0.35)+
  theme_bw()


# scatter plot
# X axis -> height
# Y axis -> mass
# cannot remove the NA and None values :?
starwars %>% 
  filter(mass < 200) %>% 
  drop_na(mass) %>% 
  drop_na(height) %>% 
  ggplot(aes(height,mass,color=sex))+
  geom_point(size=5, alpha=0.5)+
  theme_dark()+
  labs(title="Height and mass by sex")


# Smoothed model
# geom smooth draws a small linear model
# another layer -> differnt boxes by sex
starwars %>% 
  filter(mass < 200) %>% 
  ggplot(aes(height,mass,color=sex))+
  geom_point(size=5, alpha=0.5)+
  geom_smooth()+
  facet_wrap(~sex)+
  theme_minimal()+
  labs(title="Height and mass by sex")


# --------------------
# Analyse - Hypothesis testing, T-test, ANOVA, etc.

library(gapminder)
View(gapminder)

# Test the idea of difference in life expectancy;
# Null hypothesis -> no difference
# IF true -> how likely would it be to get a sample with this magnitude of difference - p value

# lifeExp as a function of continent
# data=. due to the pipe operator
# other args are bythe same by default
# p-value < 2.2e-16 -> we can reject the null hypothesis
# extremely small chance of getting such a sample IF the null hypothesis was true
gapminder %>% 
  filter(continent %in% c("Africa", "Europe")) %>% 
  t.test(lifeExp ~ continent, data=.,
         alternative = "two.sided",
         paired=FALSE)

# alternative -> could be one.sided - more or less life exp
# pair true - pairs data between the datasets ?

# ANOVA - analysis of variance
gapminder %>% 
  filter(year == 2007) %>% 
  filter(continent %in% c('Americas', 'Europe', 'Asia')) %>% 
  aov(lifeExp ~ continent, data = .) %>% 
  summary()

# Small p value -> allnull hypothesis is that the three continents have the same 
# lifeExp, really small probability for this to have happened


# Look at the difference by pairs
gapminder %>% 
  filter(year == 2007) %>% 
  filter(continent %in% c('Americas', 'Europe', 'Asia')) %>% 
  aov(lifeExp ~ continent, data = .) %>% 
  TukeyHSD() %>% 
  plot()

# The difference in Asia and the Americas is not statistically significant
# the 95% interval includes 0

# chi squared - categorical data
chi_plot

head(iris)

# cut the flowers int groups based on Sepal length
flowers <- iris %>% 
  mutate(Size = cut(Sepal.Length,
                    breaks = 3,
                    labels = c('small', 'medium', 'large'))) %>% 
  select(Species, Size)

flowers %>% 
  select(Size) %>% 
  table() %>% 
  View()

flowers %>% 
  select(Species, Size) %>% 
  table() %>% 
  View()

# is the proportion the same: null hypothesis ->
# chi squared goodness of fit
flowers %>% 
  select(Size) %>% 
  table() %>% 
  chisq.test()
# extremely small p value -> extremely unlikely; reject null


# look the typs of species inside of the group, are the dependent
flowers %>% 
  table() %>% 
  chisq.test() # again small p value


# linear model
head(cars)
# x variable, speed - independent variable
# y - distance - dependent 
# p value the slope is 0, no relationship
# R^2 -> how much of Y is influenced by X -> 65%

cars %>% 
  lm(dist ~ speed, data = .) %>% 
  summary()

