---
title: "LA Restaurant Health Inspections - Tidyverse Recipe"
author: "Alexander Ng"
date: "5/5/2019"
output: 
  html_document:
      keep_md: TRUE
---




```r
library(tidyverse)
library(knitr)
library(kableExtra)
```
## Tidyverse Recipe

Often a classification schema is implicitly used and displayed in a large dataset, but the classification schema itself is unavailable in an easy-to-use form.   This tidyverse recipe illustrates how to extract the classification data from a large dataset, identify all unique observed values and returned those unique values in a dataframe.   In effect, we will use the dplyr package to perform these basic transformations.

## An Example:  LA Restaurant Health Inspections

A basic example is the set of restaurant health inspections collected for all restaurants in the City of Los Angeles by the Los Angeles Environmental Health Department.   The department publishes this dataset as a csv file to Kaggle.  The file is large and contains 58,872 rows and 20 columns.   Moreover, file is approximately 14MB in size.  This file will represent our large dataset for this recipe.

Moreover, certain columns are repetitive and clearly important for underlying the scope and complexity of the inspection assessment.  These include pe_description (which means program element description) and program_element_pe (a 4 digit numeric code).

Examples of the pe_description field values are:

* pe_description:  RESTAURANT (0-30) SEATS MODERATE RISK
* pe_description:  RESTAURANT (61-150) SEATS HIGH RISK
* pe_description:  FOOD MKT RETAIL (25-1,999 SF) LOW RISK

Examples of the program_element_pe values are:

* 1631
* 1630
* 1636

We decide to select two columns of the data file:  pe_description and program_element_pe to define our classification schema.

The tidyverse recipe will then seek to report all unique 2-tuples of (pe_description, program_element_pe) in the data set.

We will also repeat the recipe to seek all unique 1-tuples of distinct (pe_description) and (program_element_pe)

We can therefore answer three questions with this recipe:

How many distinct pe_description values exist in the LA County Environmental Health classification schema?

For a given pe_description, do all restaurants get assigned the same program_element_pe during their inspection?

What are the distinct values for program_element_pe?

## Data Source


```r
inspections = read_csv("https://raw.githubusercontent.com/completegraph/DataStore/master/Tidyverse/restaurant-and-market-health-inspections.csv")

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
##  $ pe_description     : chr  "RESTAURANT (0-30) SEATS MODERATE RISK" "RESTAURANT (0-30) SEATS MODERATE RISK" "RESTAURANT (0-30) SEATS LOW RISK" "RESTAURANT (61-150) SEATS LOW RISK" ...
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
##   ..   pe_description = col_character(),
##   ..   program_element_pe = col_double(),
##   ..   program_name = col_character(),
##   ..   program_status = col_character(),
##   ..   record_id = col_character()
##   .. )
```
## Using the *distinct* function in dplyr

The function *distinct()* accomplishes this goal.  There are two ways to apply the function in this example.
In the first way, we may choose to extract the subset of columns used to obtain the unique k-tuples.   In this case, k=2 or k=1.   The second way, a feature of distinct, allows use to obtain the unique k-tuples without extracting the subset of columns of interest.   We start by illustrating the first approach.

### Approach 1: Taking a subset of columns to create a helper dataframe

We illustrate this approach by extracting an intermediate dataframe to which the *distinct* function is applied.
In the code below, we use *select* to choose the columns of interest and then *distinct* to get all distinct k-tuples.
Lastly, we sort the unique values by some ordering.


```r
inspections %>% select( pe_description, program_element_pe) -> trimmed_dataframe

trimmed_dataframe %>% distinct() %>% arrange(pe_description, program_element_pe) -> distinct_two_tuples

str(distinct_two_tuples)
```

```
## Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame':	18 obs. of  2 variables:
##  $ pe_description    : chr  "FOOD MKT RETAIL (2,000+ SF) HIGH RISK" "FOOD MKT RETAIL (2,000+ SF) LOW RISK" "FOOD MKT RETAIL (2,000+ SF) MODERATE RISK" "FOOD MKT RETAIL (25-1,999 SF) HIGH RISK" ...
##  $ program_element_pe: num  1615 1613 1614 1612 1610 ...
```

```r
distinct_two_tuples %>% kable() %>% kable_styling(bootstrap_options = c("striped", "hover")) %>%
   scroll_box(width="85%",  height="200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; overflow-x: scroll; width:85%; "><table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> pe_description </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> program_element_pe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) HIGH RISK </td>
   <td style="text-align:right;"> 1615 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) LOW RISK </td>
   <td style="text-align:right;"> 1613 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) MODERATE RISK </td>
   <td style="text-align:right;"> 1614 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) HIGH RISK </td>
   <td style="text-align:right;"> 1612 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) LOW RISK </td>
   <td style="text-align:right;"> 1610 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) MODERATE RISK </td>
   <td style="text-align:right;"> 1611 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1632 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1630 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1631 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1641 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1639 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1640 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1635 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1633 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1634 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1638 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1636 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1637 </td>
  </tr>
</tbody>
</table></div>

Let's test whether the two values are assigned in a 1-to-1 correspondence to each other.  



```r
inspections %>% select(pe_description) %>% distinct() %>% arrange(pe_description) -> distinct_pe_description
inspections %>% select(program_element_pe ) %>% distinct() %>% arrange(program_element_pe) -> distinct_program_element_pe

nrow(distinct_pe_description)
```

```
## [1] 18
```

```r
nrow(distinct_program_element_pe)
```

```
## [1] 18
```

```r
nrow(distinct_two_tuples)
```

```
## [1] 18
```

We see that both the 2-tuples and 1-tuples are all the same size.   This implies that the mapping between the two columns is 1-to-1.  

### Approach 2: Finding distinct tuples without a helper dataframe

The second approach is feasible because of the clever syntax of the *distinct* function.
*distinct* allows the identification of unique k-tuples by allowing the user to specify the k column names to use.


We illustrate the avoidance of the helper dataframe below.



```r
inspections %>% distinct( pe_description, program_element_pe) %>% 
    arrange(pe_description) %>% 
    kable() %>% 
    kable_styling(bootstrap_options = c("striped", "hover")) %>%
    scroll_box(width="90%", height="200px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; overflow-x: scroll; width:90%; "><table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> pe_description </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> program_element_pe </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) HIGH RISK </td>
   <td style="text-align:right;"> 1615 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) LOW RISK </td>
   <td style="text-align:right;"> 1613 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) MODERATE RISK </td>
   <td style="text-align:right;"> 1614 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) HIGH RISK </td>
   <td style="text-align:right;"> 1612 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) LOW RISK </td>
   <td style="text-align:right;"> 1610 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) MODERATE RISK </td>
   <td style="text-align:right;"> 1611 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1632 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1630 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1631 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1641 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1639 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1640 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1635 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1633 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1634 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1638 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1636 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1637 </td>
  </tr>
</tbody>
</table></div>


  In addition, if the *.keep_all* option is set to TRUE, the user can even obtain the first matching entire row of the dataset associated with each unique k-tuple. We illustrate the ability to keep a representative row of the complete set of columns below.


```r
inspections %>% distinct( pe_description, .keep_all=TRUE) %>% 
    arrange(pe_description) %>% 
    select(pe_description, program_element_pe, everything()) %>%   # place the pe_description column first
    kable() %>% 
    kable_styling(bootstrap_options = c("striped", "hover")) %>%
    scroll_box(width="85%", height="200px" )
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:200px; overflow-x: scroll; width:85%; "><table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> pe_description </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> program_element_pe </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> serial_number </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> activity_date </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> facility_name </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> score </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> grade </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> service_code </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> service_description </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> employee_id </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> facility_address </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> facility_city </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> facility_id </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> facility_state </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> facility_zip </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> owner_id </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> owner_name </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> program_name </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> program_status </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> record_id </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) HIGH RISK </td>
   <td style="text-align:right;"> 1615 </td>
   <td style="text-align:left;"> DAP9QQTMX </td>
   <td style="text-align:left;"> 2017-12-27 </td>
   <td style="text-align:left;"> G AND J MARKET </td>
   <td style="text-align:right;"> 92 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000798 </td>
   <td style="text-align:left;"> 2045 W MLK BLVD </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0024244 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90062 </td>
   <td style="text-align:left;"> OW0019978 </td>
   <td style="text-align:left;"> KPL PARTNERS, INC. </td>
   <td style="text-align:left;"> G AND J MARKET </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0024262 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) LOW RISK </td>
   <td style="text-align:right;"> 1613 </td>
   <td style="text-align:left;"> DAKSJB0AB </td>
   <td style="text-align:left;"> 2017-12-29 </td>
   <td style="text-align:left;"> 7 ELEVEN #37215A </td>
   <td style="text-align:right;"> 95 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000839 </td>
   <td style="text-align:left;"> 3330 W FLORENCE AVE </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0243779 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90043-4706 </td>
   <td style="text-align:left;"> OW0239028 </td>
   <td style="text-align:left;"> S &amp; U INVESTMENTS, INC. </td>
   <td style="text-align:left;"> 7 ELEVEN #37215A </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0192029 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (2,000+ SF) MODERATE RISK </td>
   <td style="text-align:right;"> 1614 </td>
   <td style="text-align:left;"> DAI2IWYYV </td>
   <td style="text-align:left;"> 2017-12-26 </td>
   <td style="text-align:left;"> CIRCLE K </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000366 </td>
   <td style="text-align:left;"> 3360 E OLYMPIC BLVD </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0243565 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90023-3724 </td>
   <td style="text-align:left;"> OW0238848 </td>
   <td style="text-align:left;"> MARKET AVENUE INC. </td>
   <td style="text-align:left;"> CIRCLE K </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0191776 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) HIGH RISK </td>
   <td style="text-align:right;"> 1612 </td>
   <td style="text-align:left;"> DA0OD6RH9 </td>
   <td style="text-align:left;"> 2017-12-27 </td>
   <td style="text-align:left;"> ALEX FISH MARKET </td>
   <td style="text-align:right;"> 98 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000798 </td>
   <td style="text-align:left;"> 1451 W MARTIN LUTHER KING JR BLVD </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0003285 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90062 </td>
   <td style="text-align:left;"> OW0020175 </td>
   <td style="text-align:left;"> KWON,UNG </td>
   <td style="text-align:left;"> ALEX FISH MARKET </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0004662 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) LOW RISK </td>
   <td style="text-align:right;"> 1610 </td>
   <td style="text-align:left;"> DAEWQMQV2 </td>
   <td style="text-align:left;"> 2017-12-29 </td>
   <td style="text-align:left;"> MARCE'S MINI MARKET </td>
   <td style="text-align:right;"> 96 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000707 </td>
   <td style="text-align:left;"> 4160 S AVALON BLVD </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0066361 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90011 </td>
   <td style="text-align:left;"> OW0015364 </td>
   <td style="text-align:left;"> HERNANDEZ, ERNESTINA </td>
   <td style="text-align:left;"> MARCE'S MINI MARKET </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0010572 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FOOD MKT RETAIL (25-1,999 SF) MODERATE RISK </td>
   <td style="text-align:right;"> 1611 </td>
   <td style="text-align:left;"> DA1LIO8WC </td>
   <td style="text-align:left;"> 2017-12-28 </td>
   <td style="text-align:left;"> LA SIRENA FISH MARKET </td>
   <td style="text-align:right;"> 98 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000366 </td>
   <td style="text-align:left;"> 4226 E OLYMPIC BLVD </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0006810 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90023 </td>
   <td style="text-align:left;"> OW0005654 </td>
   <td style="text-align:left;"> MARIA CABRALES </td>
   <td style="text-align:left;"> LA SIRENA FISH MARKET </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0045798 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1632 </td>
   <td style="text-align:left;"> DAMV56BMJ </td>
   <td style="text-align:left;"> 2017-12-29 </td>
   <td style="text-align:left;"> THE SPOT GRILL </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000727 </td>
   <td style="text-align:left;"> 10004 NATIONAL BLVD </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0245224 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90034 </td>
   <td style="text-align:left;"> OW0240313 </td>
   <td style="text-align:left;"> LIQUOR CLUB INC </td>
   <td style="text-align:left;"> THE SPOT GRILL </td>
   <td style="text-align:left;"> INACTIVE </td>
   <td style="text-align:left;"> PR0193589 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1630 </td>
   <td style="text-align:left;"> DASJI4LUR </td>
   <td style="text-align:left;"> 2017-12-29 </td>
   <td style="text-align:left;"> STREET CHURROS </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000835 </td>
   <td style="text-align:left;"> 6801 HOLLYWOOD BLVD # 253 </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0224109 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90028 </td>
   <td style="text-align:left;"> OW0228670 </td>
   <td style="text-align:left;"> STREETCHURROS, INC </td>
   <td style="text-align:left;"> STREET CHURROS </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0179282 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (0-30) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1631 </td>
   <td style="text-align:left;"> DAJ00E07B </td>
   <td style="text-align:left;"> 2017-12-29 </td>
   <td style="text-align:left;"> HABITAT COFFEE SHOP </td>
   <td style="text-align:right;"> 95 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000923 </td>
   <td style="text-align:left;"> 3708 N EAGLE ROCK BLVD </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0170465 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90065 </td>
   <td style="text-align:left;"> OW0178123 </td>
   <td style="text-align:left;"> GLASSELL COFFEE SHOP LLC </td>
   <td style="text-align:left;"> HABITAT COFFEE SHOP </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0160774 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1641 </td>
   <td style="text-align:left;"> DA85ZLP32 </td>
   <td style="text-align:left;"> 2017-12-28 </td>
   <td style="text-align:left;"> THE FOUNDATION CENTER </td>
   <td style="text-align:right;"> 97 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000224 </td>
   <td style="text-align:left;"> 11633 S WESTERN AVE </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0165629 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90047 </td>
   <td style="text-align:left;"> OW0128872 </td>
   <td style="text-align:left;"> NOAH'S DWELLING, LLC </td>
   <td style="text-align:left;"> THE FOUNDATION CENTER </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0153961 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1639 </td>
   <td style="text-align:left;"> DA1021441 </td>
   <td style="text-align:left;"> 2017-12-26 </td>
   <td style="text-align:left;"> WESTIN LAKEVIEW BISTRO </td>
   <td style="text-align:right;"> 94 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000721 </td>
   <td style="text-align:left;"> 404 S FIGUEROA ST LBBY LOBBY </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0073897 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90071 </td>
   <td style="text-align:left;"> OW0016394 </td>
   <td style="text-align:left;"> HOTEL BONAVENTURE LTD PARTNE </td>
   <td style="text-align:left;"> WESTIN LOBBY COURT </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0010971 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (151 + ) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1640 </td>
   <td style="text-align:left;"> DADCYUBZ0 </td>
   <td style="text-align:left;"> 2017-12-28 </td>
   <td style="text-align:left;"> SPECIALTY'S CAFE &amp; BAKERY </td>
   <td style="text-align:right;"> 94 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000924 </td>
   <td style="text-align:left;"> 2121 AVE OF STARS STE #100 </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0033907 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90067 </td>
   <td style="text-align:left;"> OW0033774 </td>
   <td style="text-align:left;"> SPECIALTY'S CAFE &amp; BAKERY, INC. </td>
   <td style="text-align:left;"> SPECIALTY'S CAFE &amp; BAKERY </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0018808 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1635 </td>
   <td style="text-align:left;"> DAHKJFBMR </td>
   <td style="text-align:left;"> 2017-12-28 </td>
   <td style="text-align:left;"> UPSTAIRS </td>
   <td style="text-align:right;"> 95 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000581 </td>
   <td style="text-align:left;"> 3707 N CAHUENGA BLVD </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0137987 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 91604 </td>
   <td style="text-align:left;"> OW0101400 </td>
   <td style="text-align:left;"> CLARITY MANAGEMENT, INC. </td>
   <td style="text-align:left;"> UPSTAIRS </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0122211 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1633 </td>
   <td style="text-align:left;"> DAQMQMDOR </td>
   <td style="text-align:left;"> 2017-12-26 </td>
   <td style="text-align:left;"> ADMIRALS CLUB </td>
   <td style="text-align:right;"> 99 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000122 </td>
   <td style="text-align:left;"> 400 WORLD WAY </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0004930 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90045 </td>
   <td style="text-align:left;"> OW0125020 </td>
   <td style="text-align:left;"> AMERICAN AIRLINES, INC. </td>
   <td style="text-align:left;"> ADMIRALS CLUB CHAMPAGNE BAR </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0201945 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (31-60) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1634 </td>
   <td style="text-align:left;"> DAQKIE2OT </td>
   <td style="text-align:left;"> 2017-12-27 </td>
   <td style="text-align:left;"> SUBWAY -52105 </td>
   <td style="text-align:right;"> 95 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000721 </td>
   <td style="text-align:left;"> 255 S GRAND AVE STE 101 </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0034746 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90012 </td>
   <td style="text-align:left;"> OW0005591 </td>
   <td style="text-align:left;"> C G INVESTMENTS INC </td>
   <td style="text-align:left;"> SUBWAY -52105 </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0017785 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS HIGH RISK </td>
   <td style="text-align:right;"> 1638 </td>
   <td style="text-align:left;"> DAKFCHD0L </td>
   <td style="text-align:left;"> 2017-12-29 </td>
   <td style="text-align:left;"> LE PAIN QUOTIDIEN </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000629 </td>
   <td style="text-align:left;"> 13050 SAN VICENTE BLVD STE 114 </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0034788 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90049 </td>
   <td style="text-align:left;"> OW0028928 </td>
   <td style="text-align:left;"> PQ SAN VICENTE INC. </td>
   <td style="text-align:left;"> LE PAIN QUOTIDIEN </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0017456 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS LOW RISK </td>
   <td style="text-align:right;"> 1636 </td>
   <td style="text-align:left;"> DAWVA0CY3 </td>
   <td style="text-align:left;"> 2017-12-29 </td>
   <td style="text-align:left;"> RIO GENTLEMANS CLUB </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000958 </td>
   <td style="text-align:left;"> 13124 S FIGUEROA ST </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0046462 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90064 </td>
   <td style="text-align:left;"> OW0011830 </td>
   <td style="text-align:left;"> FIGUEROA GROUP INC </td>
   <td style="text-align:left;"> RIO GENTLEMANS CLUB </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0044776 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> RESTAURANT (61-150) SEATS MODERATE RISK </td>
   <td style="text-align:right;"> 1637 </td>
   <td style="text-align:left;"> DAF0GFYS4 </td>
   <td style="text-align:left;"> 2017-12-28 </td>
   <td style="text-align:left;"> DELTA SKY CLUB T3 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:left;"> A </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> ROUTINE INSPECTION </td>
   <td style="text-align:left;"> EE0000633 </td>
   <td style="text-align:left;"> 300 WORLD WAY </td>
   <td style="text-align:left;"> LOS ANGELES </td>
   <td style="text-align:left;"> FA0248072 </td>
   <td style="text-align:left;"> CA </td>
   <td style="text-align:left;"> 90045 </td>
   <td style="text-align:left;"> OW0242509 </td>
   <td style="text-align:left;"> DELTA AIR LINES, INC. </td>
   <td style="text-align:left;"> DELTA SKY CLUB T3 </td>
   <td style="text-align:left;"> ACTIVE </td>
   <td style="text-align:left;"> PR0196711 </td>
  </tr>
</tbody>
</table></div>

## Conclusion

The ability to extract classification schema from a larger data set is a frequently required recipe.  Outside of data science, one can easily do this process using Excel and a pivot table to get distinct values for a single column.  It is even possible though non-trivial to obtain the unique 2-tuples.  However, it is more difficult to get a representative row of an entire dataset in Excel using the pivot table approach for getting distinct values.   Thus, the tidyverse recipe approach clearly shows more flexibility and power rather quickly.


