require(httr)
require(FAOSTAT)
require(sqldf)
require(arm)
require(ggplot2)
require(countrycode)

FAOsearch()

names=c("cow_kg_capita_yr","pig_kg_capita_yr","poultry_kg_capita_yr",
        "cow_kcal_capita_day","pig_kcal_capita_day","poultry_kcal_capita_day")
element_num=c(645,664,645,664,645,664)
item_num=c(2731, 2733,2734,2731, 2733,2734)

meta<-data.frame(names,element_num, item_num,stringsAsFactors=FALSE)

meat<-vector(mode="list", length=nrow(meta))

for (i in 1:nrow(meta)){
meat[[i]]<-data.frame(getFAO(name="meat_type",
       domainCode="FB",
       elementCode=meta$element_num[i],
       itemCode=meta$item_num[i]),name=meta$names[i], stringsAsFactors=FALSE)
cat(paste0("Jon is amazing \n"),meta$names[i])

}

meat_full<-do.call("rbind", meat)

test<-merge(FAOcountryProfile,meat_full, by=c("FAOST_CODE"))

pdf("meat.pdf",width=15, height=10)
for (i in unique(test$FAO_TABLE_NAME)[]){
# for (i in 'India'){
print(ggplot(test[test$FAO_TABLE_NAME==i,], aes(Year, meat_type)) + 
  geom_line(lwd=1) + 
  geom_smooth(size=2) + facet_grid(.~name) + 
  ggtitle(unique(test$FAO_TABLE_NAME[test$FAO_TABLE_NAME==i])) +
  theme_bw())
}
dev.off()
