setwd(".")

data = read.csv("WGS_PCAWG/WGS_PCAWG.indels.csv", head = T)

data_scale = data[,-c(1:4)]/max(as.vector(unlist(data[,-c(1:4)])))

rownames(data_scale) = sub("_", "-", paste(data[,1], data[,2], data[,3], data[,4], sep = "_"))
colnames(data_scale) = sub("\\.\\.", "::",colnames(data_scale))
colnames(data_scale) = sub("\\.", "-",colnames(data_scale))

write.table(data_scale, "WGS_PCAWG.Indel.txt", sep = "\t", quote = F)