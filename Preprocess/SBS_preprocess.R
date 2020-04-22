setwd(".")

data = read.csv("WGS_PCAWG/WGS_PCAWG.1536.csv", head = T)

data_scale = data[,-c(1,2)]/max(as.vector(unlist(data[,-c(1,2)])))

rownames(data_scale) = paste(data[,2],  substr((data[,1]),3,3), sep = "-")
colnames(data_scale) = sub("\\.\\.", "::",colnames(data_scale))
colnames(data_scale) = sub("\\.", "-",colnames(data_scale))

write.table(data_scale, "WGS_PCAWG.SBS.txt", sep = "\t", quote = F)