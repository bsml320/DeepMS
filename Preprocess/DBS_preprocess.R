setwd(".")

data = read.csv("WGS_PCAWG/WGS_PCAWG.dinucs.csv", head = T)

data_scale = data[,-c(1,2)]/max(as.vector(unlist(data[,-c(1,2)])))

rownames(data_scale) = paste(data[,1],  data[,2], sep = "-")
colnames(data_scale) = sub("\\.\\.", "::",colnames(data_scale))
colnames(data_scale) = sub("\\.", "-",colnames(data_scale))

write.table(data_scale, "WGS_PCAWG.DBS.txt", sep = "\t", quote = F)