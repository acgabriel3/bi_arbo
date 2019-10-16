
library(foreign)

'%%' <- function(x,y) paste0(x, y) 

dengue2017 <- read.dbf("dados/sinam/dengue/original/2016_2017/DENGUE_2017.dbf")
dengue2016 <- read.dbf("dados/sinam/dengue/original/2016_fora/DENGUE_2016.dbf")
dengue2015 <- read.dbf("dados/sinam/dengue/original/2015/DENGUE_2015.dbf")
dengue2014 <- read.dbf("dados/sinam/dengue/original/2014/DENGUE_2014.dbf")
dengue2013 <- read.dbf("dados/sinam/dengue/original/2012_2013/DENGUE_2013.dbf")
dengue2012 <- read.dbf("dados/sinam/dengue/original/2012_2013/DENGUE_2012.dbf")
dengue2011 <- read.dbf("dados/sinam/dengue/original/2008_2011/DENGUE_2011.dbf")
dengue2010 <- read.dbf("dados/sinam/dengue/original/2008_2011/DENGUE_2010.dbf")
dengue2009 <- read.dbf("dados/sinam/dengue/original/2008_2011/DENGUE_2009.dbf")
dengue2008 <- read.dbf("dados/sinam/dengue/original/2008_2011/DENGUE_2008.dbf")


for (ano in 4:7) {
  
  eval(parse(text = 
    
    'dengue200' %% ano %% '<- read.dbf("dados/sinam/dengue/original/2004_2007/DENGUE_200' %% ano %% '.dbf")'
    
  )
  )
  
}

for (ano in 0:3) {
  
  eval(parse(text = 
               
               'dengue200' %% ano %% '<- read.dbf("dados/sinam/dengue/original/2000_2003/DENGUE_200' %% ano %% '.dbf")'
             
  )
  )
  
}

dengue1999 <- read.dbf("dados/sinam/dengue/original/1999/IDENG99.dbf")

for (ano in 3:8) {
  
  eval(parse(text = 
               
               'dengue199' %% ano %% '<- read.dbf("dados/sinam/dengue/original/1993_1998/DENG9' %% ano %% '.dbf")'
             
  )
  )
  
}
