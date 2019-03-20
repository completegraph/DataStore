library(tidyverse)
library(aRxiv)

#
# Count the papers by Peter Hall
arxiv_count('au:"Peter Hall"')

arxiv_count('au: "Andrew Y. Ng"')

#
# Note that a single author may be spelled in multiple ways
#
arxiv_count('au: "Andrew Ng"')

# This retreives all the abstracts, titles, full records of the papers by Andrew Ng.
# -----------------------------------------------
rec1 = arxiv_search('au: "Andrew Ng"')

str(rec1)

#  A full list of titles
#--------------------------------------------------
rec1$title

# The list of  text abstract of all the papers
# -------------------------------------------------
rec1$abstract

# Search for papers by Andrew Ng and category is cs.AI
# ------------------------------------------------
rec1_search = arxiv_search('au: "Andrew Ng" AND cat:CS.cv;')


# FInd paperps about butterflys on windos.
# ---------------------------------------------
rec2_search = arxiv_search('cat:CS.cv')

#
# ----------------------------------------------
rec3_search = arxiv_search('au: "Andrew Ng" AND submittedDate:[2013 TO 2015]' )

# Archive categories
# ---------------------------------------------
arxiv_cats

# Search abstract text for the term machine learning in last 3 years
# -------------------------------------------------------------------------
(rec4_search = arxiv_search('abs: "machine learning" AND submittedDate:[2017 TO 2019]') )

#
#  Multiple names in arXiv

arxiv_search('au: "Geoffrey Hinton"')


arxiv_search('au: "Yann Lecun"')



