# load the data
library(tibble)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(patchwork)
library(RColorBrewer)
library(gridExtra)
library(data.table)
library(tm)
library(SnowballC)
library(wordcloud)


# load the data. Take an overlook data
data1<-read.table("data/anes_timeseries_cdf_rawdata.txt", header = TRUE, sep=",")
dim(data1)
sum(is.na(data1))

# Percentage NA
sum( is.na(data1) ) / prod( dim(data1) )

# count complete cases
datacomplete<- data1[complete.cases(data1), ] 
# No case ID totally complete all the questions. This must be because the question sets are
#different from year to year

#  >>> read the codebook and choose variable of interest NOW


#### Look at the thermometer for democrat
sum(is.na(data1$VCF0201))/length(data1$VCFO2O1)   # count NA values -> too many
length(data1$VCF0201)

data1$VCF0301       #party identification respondent scale 1-7 strong democrat - strong republican
sum(is.na(data1$VCF0301))   
length(data1$VCF0301)      # good variable, not a lot of NA

################# Table: education + year +party ID
datacleanyear<-data1$VCF0004    #get the year column
datacleanedu<-data1$VCF0110     #get the education column
datacleanparty<- data1$VCF0303
#bind data
dataclean1<-cbind(datacleanyear,datacleanedu, datacleanparty)  #combine new dataframe with year and education

#get rid of NA, only take complete cases
data_complete<-dataclean1[complete.cases(dataclean1),]      #only select complete case
data_complete<-as.data.frame(data_complete)
names(data_complete)<- c("Year", "Education_Levels", "Party_Identification")

##### get rid of level 0 in edu and level 0 in party id
data_complete <- data_complete[ data_complete$Education_Levels != 0, ]
data_complete<-data_complete[data_complete$Party_Identification !=0,]
unique(data_complete$Education_Levels)          #check if we get rid of 0
unique(data_complete$Party_Identification)     #check if we get rid of 0

###############3
#second trial_count frequency and Percentage based on edu and party group

data_complete2<-data_complete
frequency<-data_complete2 %>% count(Year, Education_Levels, Party_Identification)

#add new column: sum by party
foo<-data_complete2 %>% count(Year, Party_Identification)
foo_expanded<- foo[rep(row.names(foo),each=4), 2:3]

# sorty bby party
frequency<-frequency[order(frequency$Year, frequency$Party_Identification), ]

# then expand
frequency[,5]<-foo_expanded[,2]

# add new column for percentage 
frequency[,6]<- frequency[,4]/frequency[,5]

#rename column
names(frequency)<-c("Year", "EducationID","PartyID", "Countpereduparty", "partySum", "percentage")
data_sorted<-frequency

################# Counting Row/variable based on year, edu level, party ID
#data_sorted<-aggregate( . ~data_complete$Year+ data_complete$Education_Levels + data_complete$Party_Identification, data = data_complete, FUN = length)
#data_sorted<-data_sorted[,!names(data_sorted) %in% "Year"]    #remove year column
#names(data_sorted)<-c("Year", "EducationID","PartyID", "Educount", "Partycount")




######### make data_test 2 to rename factor levels
test2<-data_sorted


label_table<- data_frame(ID=c(1,2,3,4), Level=c("1_Grade School", "2_High school", "3_SomeCollege", "4_College and Grad school"))
test2$EducationID <- label_table$Level[match(test2$EducationID, label_table$ID)]

label_table2<- data_frame(ID=c(1,2,3), Level=c("Dem", "Ind", "Rep"))
test2$PartyID <- label_table2$Level[match(test2$PartyID, label_table2$ID)]

#### assign relabeled test 2 to data_sorted
data_sorted<-test2

##########
#Plotting by PERCENTAGE, based on different party group
ggplot(data= data_sorted, aes(x= Year, y=percentage, colour= as.factor(PartyID)))+
               facet_wrap(data_sorted$EducationID~.) + 
        scale_color_brewer(palette="Dark2") +
        geom_point() +geom_line() +  scale_color_manual(name="Party Identification",
                                                        labels=c("Democrats","Independent","Republican"),
                                                        values=c("blue","orange", "red"))+
        scale_x_continuous(limits = c(1949,2020))+
        scale_y_continuous(limits = c(0,0.6))

## Plot the total count by party by party and year
ggplot(data= data_sorted, aes(x= Year, y=Countpereduparty, colour= as.factor(PartyID)))+
        facet_wrap(data_sorted$EducationID~.) + 
        scale_color_brewer(palette="Dark2") +
        geom_point() +geom_line() +  scale_color_manual(name="Party Identification",
                                                        labels=c("Democrats","Independent","Republican"),
                                                        values=c("blue","orange", "red"))
       

###################################
# ATTEMPT DISLIKE about DEMOCRATIC PARTY
#11-50
dislikedem<-data1$VCF0381b
dislikedem<-dislikedem[!is.na(dislikedem)]
dislikedem<-as.data.frame(dislikedem)
names(dislikedem)<-"DislikeID"



#VCF0382
dislikedem3<-data1$VCF0382b
dislikedem3<-dislikedem3[!is.na(dislikedem3)]
dislikedem3<-as.data.frame(dislikedem3)
names(dislikedem3)<-"DislikeID"



## VCF0383
dislikedem6<-data1$VCF0383b
dislikedem6<-dislikedem6[!is.na(dislikedem6)]
dislikedem6<-as.data.frame(dislikedem6)
names(dislikedem6)<-"DislikeID"

## VCF0384
dislikedem5<-data1$VCF0384b
dislikedem5<-dislikedem5[!is.na(dislikedem5)]
dislikedem5<-as.data.frame(dislikedem5)
names(dislikedem5)<-"DislikeID"


# rbind 2 data frame
dislikedem_total<-rbind(dislikedem, dislikedem3, dislikedem6, dislikedem5)
dim(dislikedem_total)

# match the dislikeID with answer key
dislike_label1 <- data.frame(
        ID = c(11, 12,21,22,23,24,31,32,33,34,35,40,50), 
        Reason = c("PeopleinParty", 
                 "PartyCharacter", 
                 "Candidate Ability", 
                 "Leadership Qualities",
                 "Candidate Personal Qualities", 
                 "Party Connection", 
                 "Management", 
                 "Philosophy", 
                 "DomesticPolicy", 
                 "F-Policies",
                 "GroupConnect", 
                 "Etc",
                 "Events Unique to One campaign"
                 )
        )

dislike_label2 <- data.frame(
        ID= c(1,2,3,4,5,6,7,8,9,10), 
        Reason= c("PeopleinParty",
                  "Management", 
                  "Philosophy", 
                  "DomesticPolicy", 
                  "DomesticPolicy", 
                  "ForeignPolicy", 
                  "Bad for groups of interest", 
                  "Good for group of interest", 
                  "Party Attitude",
                  "Others"
                  )
        )
dislike_label<-rbind(dislike_label1, dislike_label2)

#match label with factor in main data frame
dislikedem_total$DislikeID <- dislike_label$Reason[
        match( dislikedem_total$DislikeID, dislike_label$ID )
        ]

####### CREATE WORD CLOUD PLOT

text<-dislikedem_total$DislikeID
cd2 <- count(dislikedem_total, DislikeID)
wordcloud(words=cd2$DislikeID, freq = cd2$n,scale=c(2,.5), random.order = FALSE,rot.per=.5)


############   REPUBLICAN

dislikerep<-data1$VCF0393b
dislikerep2<-data1$VCF0394b
dislikerep4<- data1$VCF0395b
dislikerep5<- data1$VCF0396b
dislikerep6<- data1$VCF0397b

# create dataframe and rename column
dislikerep<-as.data.frame(dislikerep)
names(dislikerep)<-"DislikeID"

dislikerep2<-as.data.frame(dislikerep2)
names(dislikerep2)<-"DislikeID"

dislikerep4<-as.data.frame(dislikerep4)
names(dislikerep4)<-"DislikeID"

dislikerep5<-as.data.frame(dislikerep5)
names(dislikerep5)<-"DislikeID"

dislikerep6<-as.data.frame(dislikerep6)
names(dislikerep6)<-"DislikeID"

dislikerep_total<-rbind(dislikerep, dislikerep2,dislikerep4,dislikerep5,dislikerep6)
dislikerep_total<-dislikerep_total[!is.na(dislikerep_total)]
dislikerep_total<-as.data.frame(dislikerep_total)
names(dislikerep_total)<- "DislikeID"


### Match label with the dislikeID
dislikerep_total$DislikeID <- dislike_label$Reason[match(dislikerep_total$DislikeID, dislike_label$ID)]

### CREATE WORD CLOUD PLOT

text2<-dislikerep_total$DislikeID
cd <- count(dislikerep_total, DislikeID)
wordcloud(words=cd$DislikeID, freq = cd$n, scale=c(2,.5), random.order = FALSE,rot.per=.5)

######################## LIKE
# Like Dem Party
likedem<-data1$VCF0375b
likedem2<-data1$VCF0376b
likedem3<-data1$VCF0377b
likedem4<- data1$VCF0378b
likedem5<- data1$VCF0379b

likedem<-as.data.frame(likedem)
names(likedem)<-"LikeID"

likedem2<-as.data.frame(likedem2)
names(likedem2)<-"LikeID"

likedem3<-as.data.frame(likedem3)
names(likedem3)<-"LikeID"

likedem4<-as.data.frame(likedem4)
names(likedem4)<-"LikeID"

likedem5<-as.data.frame(likedem5)
names(likedem5)<-"LikeID"

likedem_total<-rbind(likedem,likedem2,likedem3, likedem4, likedem5)
likedem_total<-likedem_total[!is.na(likedem_total)]
likedem_total<-as.data.frame(likedem_total)
names(likedem_total)<- "LikeID"

#create data frame used for label
like_label <- data.frame(
        ID = c(11, 12,21,22,23,24,31,32,33,34,35,40,50), 
        Reason = c("PeopleinParty", 
                   "PartyCharacter", 
                   "Candidate Ability", 
                   "Leadership Qualities",
                   "Candidate Personal Qualities", 
                   "Party Connection", 
                   "Management", 
                   "Philosophy", 
                   "DomesticPolicy", 
                   "F-Policies",
                   "GroupConnect", 
                   "Etc",
                   "Events Unique to One campaign"
        )
)

### Match label with the LikeID
likedem_total$LikeID <- like_label$Reason[match(likedem_total$LikeID, like_label$ID)]

### CREATE WORD CLOUD PLOT

text3<-likedem_total$LikeID
wc <- count(likedem_total, LikeID)
wordcloud(words=wc$LikeID, freq = wc$n, scale=c(2,.5), random.order = FALSE,rot.per=.5)


######### REPUBLICAN

likerep<-data1$VCF0387b
likerep2<-data1$VCF0388b
likerep3<-data1$VCF0389b
likerep4<- data1$VCF0390b
likerep5<- data1$VCF0391b

likerep<-as.data.frame(likerep)
names(likerep)<-"LikeID"

likerep2<-as.data.frame(likerep2)
names(likerep2)<-"LikeID"

likerep3<-as.data.frame(likerep3)
names(likerep3)<-"LikeID"

likerep4<-as.data.frame(likerep4)
names(likerep4)<-"LikeID"

likerep5<-as.data.frame(likerep5)
names(likerep5)<-"LikeID"

likerep_total<-rbind(likerep,likerep2, likerep3, likerep4, likerep5)   
likerep_total<-likerep_total[!is.na(likerep_total)]
likerep_total<-as.data.frame(likerep_total)
names(likerep_total)<- "LikeID"

likerep_total$LikeID <- like_label$Reason[match(likerep_total$LikeID, like_label$ID)]

## Plotting
text4<-likerep_total$LikeID
wc2 <- count(likerep_total, LikeID)
wordcloud(words=wc2$LikeID, freq = wc2$n, scale=c(2,.5), random.order = FALSE,rot.per=.5)
