---
title: "Tidyverse Recipe as Modified by Alexander Ng"
author: "Sheryl Piechocki, Alexander Ng"
date: "May 5, 2019"
output: 
  html_document:
      keep_md: TRUE

---



## Forcats Package  
### Vignette Demonstrating fct_infreq, fct_relevel, fct_other functions  

The **forcats** package is useful when dealing with categorical variables in the form of factors.  It contains functions that help with reordering factor levels and modifying factor levels.  This vignette focuses on **fct_infreq**, **fct_relevel**, and **fct_other**. 

The data used to demonstrate these functions is from a survey asking people how they like their steak prepared and can be found here: https://github.com/fivethirtyeight/data/tree/master/steak-survey.  

#### Load the data and subset to only keep respondents that answered 'Yes' they do eat steak.    


```r
steak <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/steak-survey/steak-risk-survey.csv")
steak <- subset(steak, Do.you.eat.steak. == "Yes")
```

A bar chart of how respondents like their steak prepared follows. As you can see, the order of the responses in the chart is haphazard and not visually appealing.    


```r
ggplot(steak, aes(x = How.do.you.like.your.steak.prepared.)) + 
  geom_bar() +  coord_flip() + xlab("Steak Preparation") + ylab("Number of Respondents")
```

![](spiechocki_AlexanderNg_tidyverse_copy_files/figure-html/chart-1.png)<!-- -->

#### fct_infreq  
The **fct_infreq** function from the forcats package will order the categorical variable by frequency.  **ordered** is a logical that determines the ordered status of the output factor.  If **ordered** is NA, it will keep the existing status of the factor.  

fct_infreq(f, ordered = NA)  

The resulting bar chart has a better appearance and is easier to analyze visually.  

```r
ggplot(steak, aes(x = fct_infreq(How.do.you.like.your.steak.prepared.))) + 
  geom_bar() +  coord_flip() + xlab("Steak Preparation") + ylab("Number of Respondents")
```

![](spiechocki_AlexanderNg_tidyverse_copy_files/figure-html/freq-1.png)<!-- -->

Grouping the data by the age category and creating bar charts yields the following chart.  The age categories are in no particular order.  The missing category is first, following by the >60 category, then it moves on to the 18-29 age category, etc.  Logically, the age categories should display in the correct order of numerical age.  

```r
ggplot(steak, aes(x = fct_infreq(How.do.you.like.your.steak.prepared.))) + 
  geom_bar() +  coord_flip() + xlab("Steak Preparation") + ylab("Number of Respondents") + facet_wrap(~Age)
```

![](spiechocki_AlexanderNg_tidyverse_copy_files/figure-html/age-1.png)<!-- -->

#### fct_relevel  
The **fct_relevel** function from the forcats package allows for factor reordering.  As arguments, it takes the factor, the level to be reordered, and after = (some number) that specifies where to move that level.  

fct_relevel(.f, character level, after = a number)  

It defaults to moving to the front, but you can move it after another level with the argument **after**. To move it to the end you set **after = Inf**.  Below example moves the "> 60" category to the 5th position by using after = 4.   

```r
steak$Age <- fct_relevel(steak$Age, "> 60", after = 4)
#steak$Age <- fct_other(steak$Age, drop = "", other_level = "Missing")

ggplot(steak, aes(x = fct_infreq(How.do.you.like.your.steak.prepared.))) + 
  geom_bar() +  coord_flip() + xlab("Steak Preparation") + ylab("Number of Respondents") + facet_wrap(~Age)
```

![](spiechocki_AlexanderNg_tidyverse_copy_files/figure-html/relevel-1.png)<!-- -->

These bar charts are in age order, but it would make more sense to put the chart for the missing data at the end.  This can be accomplished using the **fct_other** function from the forcats package.  

####fct_other  
**fct_other** will replace levels with "other".  It takes the factor, keep or drop, and other_level as arguments.  

fct_other(f, keep, drop, other_level = "Other")  

**keep** will keep the listed levels, replacing any not in the list with other_level.  **drop** will replace the listed levels with other_level.  **other_level** is the value used for other values and it is always placed at the end of the levels.  In the following code, the level for missing values "" is listed in the drop and other_level has the value "Missing".  This will result in the missing values category getting the new label of "Missing" and will place it at the end of the levels.  The resulting plots are ordered as we would expect and more aesthetically pleasing.   

```r
steak$Age <- fct_other(steak$Age, drop = "", other_level = "Missing")

ggplot(steak, aes(x = fct_infreq(How.do.you.like.your.steak.prepared.))) + 
  geom_bar() +  coord_flip() + xlab("Steak Preparation") + ylab("Number of Respondents") + facet_wrap(~Age)
```

![](spiechocki_AlexanderNg_tidyverse_copy_files/figure-html/relevel2-1.png)<!-- -->

Finally, the data can also be represented in stacked bar charts with the different Age levels being represented by colors. This can be done using ggplot2.  


```r
steak$Age <- fct_other(steak$Age, drop = "", other_level = "Missing")

ggplot(steak, aes(x = fct_infreq(How.do.you.like.your.steak.prepared.), fill=Age)) + 
  geom_bar() + xlab("Steak Preparation") + coord_flip() 
```

![](spiechocki_AlexanderNg_tidyverse_copy_files/figure-html/stacked bar-1.png)<!-- -->


As you can see, the forcats package provides various functions that make it easier to deal with categorical data in the form of factors.   

## Alexander Ng's Extension of forcats

We can apply the forcats package explained by Sherly Piechocki's work in another context of the Kaggle dataset of Los Angeles Restaurant Health Inspections.   I used this dataset in my own tidyverse recipe assignment which is posted to github and rpubs.  For brevity, I provide the RPubs link to the latter as:

[http://rpubs.com/Fixed_Point/493484]


```r
library(knitr)
library(kableExtra)
```

```
## 
## Attaching package: 'kableExtra'
```

```
## The following object is masked from 'package:dplyr':
## 
##     group_rows
```

```r
inspections = read_csv("https://raw.githubusercontent.com/completegraph/DataStore/master/Tidyverse/restaurant-and-market-health-inspections.csv", col_types = cols( pe_description = col_factor() ) )

str(inspections)
```

```
## Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame':	58872 obs. of  20 variables:
##  $ serial_number      : chr  "DAJ00E07B" "DAQOKRFZB" "DASJI4LUR" "DAWVA0CY3" ...
##  $ activity_date      : POSIXct, format: "2017-12-29" "2017-12-29" ...
##  $ facility_name      : chr  "HABITAT COFFEE SHOP" "REILLY'S" "STREET CHURROS" "RIO GENTLEMANS CLUB" ...
##  $ score              : num  95 92 93 93 93 94 96 94 93 95 ...
##  $ grade              : chr  "A" "A" "A" "A" ...
##  $ service_code       : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ service_description: chr  "ROUTINE INSPECTION" "ROUTINE INSPECTION" "ROUTINE INSPECTION" "ROUTINE INSPECTION" ...
##  $ employee_id        : chr  "EE0000923" "EE0000633" "EE0000835" "EE0000958" ...
##  $ facility_address   : chr  "3708 N EAGLE ROCK BLVD" "100 WORLD WAY # 120" "6801 HOLLYWOOD BLVD # 253" "13124 S FIGUEROA ST" ...
##  $ facility_city      : chr  "LOS ANGELES" "LOS ANGELES" "LOS ANGELES" "LOS ANGELES" ...
##  $ facility_id        : chr  "FA0170465" "FA0244690" "FA0224109" "FA0046462" ...
##  $ facility_state     : chr  "CA" "CA" "CA" "CA" ...
##  $ facility_zip       : chr  "90065" "90045" "90028" "90064" ...
##  $ owner_id           : chr  "OW0178123" "OW0208441" "OW0228670" "OW0011830" ...
##  $ owner_name         : chr  "GLASSELL COFFEE SHOP LLC" "AREAS SKYVIEW LAX JV, LLC" "STREETCHURROS, INC" "FIGUEROA GROUP INC" ...
##  $ pe_description     : Factor w/ 18 levels "RESTAURANT (0-30) SEATS MODERATE RISK",..: 1 1 2 3 4 1 5 1 6 7 ...
##  $ program_element_pe : num  1631 1631 1630 1636 1638 ...
##  $ program_name       : chr  "HABITAT COFFEE SHOP" "REILLY'S" "STREET CHURROS" "RIO GENTLEMANS CLUB" ...
##  $ program_status     : chr  "ACTIVE" "ACTIVE" "ACTIVE" "ACTIVE" ...
##  $ record_id          : chr  "PR0160774" "PR0193026" "PR0179282" "PR0044776" ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   serial_number = col_character(),
##   ..   activity_date = col_datetime(format = ""),
##   ..   facility_name = col_character(),
##   ..   score = col_double(),
##   ..   grade = col_character(),
##   ..   service_code = col_double(),
##   ..   service_description = col_character(),
##   ..   employee_id = col_character(),
##   ..   facility_address = col_character(),
##   ..   facility_city = col_character(),
##   ..   facility_id = col_character(),
##   ..   facility_state = col_character(),
##   ..   facility_zip = col_character(),
##   ..   owner_id = col_character(),
##   ..   owner_name = col_character(),
##   ..   pe_description = col_factor(levels = NULL, ordered = FALSE, include_na = FALSE),
##   ..   program_element_pe = col_double(),
##   ..   program_name = col_character(),
##   ..   program_status = col_character(),
##   ..   record_id = col_character()
##   .. )
```

Our application of the forcats package to the Health Inspection dataset will consider two separate extensions:

##Applying fct_lump

An additional function not considered in the above analysis is *fct_lump*.
*fct_lump* can be used to group together into an "other" category, those observations where the factor is not of interest.
In this case, we can try to display all restaurant program elements with at least 2 percent of all inspections within Los Angeles.   If we examine the total list of pe_descriptions, some categories are of marginal interest.


```r
inspections %>% count(pe_description, sort = TRUE) %>% kable() %>% scroll_box()
```

<div style="border: 1px solid #ddd; padding: 5px; "><table>
 <thead>
  <tr>
   <th style="text-align:left;"> pe_description </th>
   <th style="text-align:right;"> n </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 13735 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 9466 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 9314 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 6886 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) LOW RISK </td>
   <td style="text-align:right;"> 5480 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) HIGH RISK </td>
   <td style="text-align:right;"> 2778 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 2504 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1734 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1493 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) LOW RISK </td>
   <td style="text-align:right;"> 1408 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) HIGH RISK </td>
   <td style="text-align:right;"> 1194 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 961 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) MODERATE RISK </td>
   <td style="text-align:right;"> 642 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS LOW RISK </td>
   <td style="text-align:right;"> 483 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS LOW RISK </td>
   <td style="text-align:right;"> 265 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 247 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) MODERATE RISK </td>
   <td style="text-align:right;"> 195 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS LOW RISK </td>
   <td style="text-align:right;"> 87 </td>
  </tr>
</tbody>
</table></div>

Using the *fct_lump* function, we can resolve this by excluding the lesser categories. This collapses 18 categories of pe_description into 12 categories including the synthetic category of "other" which lumps that remaining 7 categories.


```r
inspections %>%  mutate( pe_description = fct_lump(pe_description, prop = .02)) %>%
  count(pe_description, sort = TRUE)
```

```
## # A tibble: 12 x 2
##    pe_description                              n
##    <fct>                                   <int>
##  1 RESTAURANT (0-30) SEATS HIGH RISK       13735
##  2 RESTAURANT (31-60) SEATS HIGH RISK       9466
##  3 RESTAURANT (0-30) SEATS MODERATE RISK    9314
##  4 RESTAURANT (61-150) SEATS HIGH RISK      6886
##  5 FOOD MKT RETAIL (25-1,999 SF) LOW RISK   5480
##  6 Other                                    2880
##  7 FOOD MKT RETAIL (25-1,999 SF) HIGH RISK  2778
##  8 RESTAURANT (151 + ) SEATS HIGH RISK      2504
##  9 RESTAURANT (31-60) SEATS MODERATE RISK   1734
## 10 RESTAURANT (0-30) SEATS LOW RISK         1493
## 11 FOOD MKT RETAIL (2,000+ SF) LOW RISK     1408
## 12 FOOD MKT RETAIL (2,000+ SF) HIGH RISK    1194
```

## Applying fct_relevel to a complex bespoke text category.

Suppose we wish to reorder the factors by restaurant-type and then risk-level.  The factor descriptions make this difficult because an alphabetical sort would screw up the order.  For example, an alphabetical sort would result HIGH RISK followed by LOW RISK and MODERATE RISK.  The reason is that H, L, M are in alphabetical order.

*FOOD MKT RETAIL (2,000+ SF) HIGH RISK
*FOOD MKT RETAIL (2,000+ SF) LOW RISK
*FOOD MKT RETAIL (2,000+ SF) MODERATE RISK

To solve this, we manually reorder the columns.


```r
inspections %>% mutate(pe_desc_text = as.character(pe_description)) %>% 
  distinct(pe_desc_text) %>% 
  arrange(pe_desc_text) ->pe

old_order = pe$pe_desc_text   # The native order of the original data arranged alphabetically
new_order = old_order[c(1,3,2,4,6,5,10,12,11,16,18,17,13,15,14,7,9,8)]  # the manually corrected order

new_order
```

```
##  [1] "FOOD MKT RETAIL (2,000+ SF) HIGH RISK"      
##  [2] "FOOD MKT RETAIL (2,000+ SF) MODERATE RISK"  
##  [3] "FOOD MKT RETAIL (2,000+ SF) LOW RISK"       
##  [4] "FOOD MKT RETAIL (25-1,999 SF) HIGH RISK"    
##  [5] "FOOD MKT RETAIL (25-1,999 SF) MODERATE RISK"
##  [6] "FOOD MKT RETAIL (25-1,999 SF) LOW RISK"     
##  [7] "RESTAURANT (151 + ) SEATS HIGH RISK"        
##  [8] "RESTAURANT (151 + ) SEATS MODERATE RISK"    
##  [9] "RESTAURANT (151 + ) SEATS LOW RISK"         
## [10] "RESTAURANT (61-150) SEATS HIGH RISK"        
## [11] "RESTAURANT (61-150) SEATS MODERATE RISK"    
## [12] "RESTAURANT (61-150) SEATS LOW RISK"         
## [13] "RESTAURANT (31-60) SEATS HIGH RISK"         
## [14] "RESTAURANT (31-60) SEATS MODERATE RISK"     
## [15] "RESTAURANT (31-60) SEATS LOW RISK"          
## [16] "RESTAURANT (0-30) SEATS HIGH RISK"          
## [17] "RESTAURANT (0-30) SEATS MODERATE RISK"      
## [18] "RESTAURANT (0-30) SEATS LOW RISK"
```

Then we display the data using fct_relevel to use data in a double decreasing sort by seating capacity and risk level.


```r
inspections %>% mutate( pe_description = fct_relevel(pe_description, new_order) ) -> new_inspections
    
ggplot(new_inspections, aes(x=pe_description) ) + geom_bar() + coord_flip() + xlab("PE Description Ordered") + 
  ylab("Inspection Count") + ggtitle("By Seating Capacity and Risk Level")
```

![](spiechocki_AlexanderNg_tidyverse_copy_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

This shows that tidyverse recipes for forcats can be readily extended with small modifications to handle both small and larger data sets.


