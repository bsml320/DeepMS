library(RColorBrewer)
mycol <- c(brewer.pal(12,"Set3")[c(-2,-12)],brewer.pal(8,"Set2"),brewer.pal(9,"Set1"),brewer.pal(12,"Paired"))
mycol <- mycol[-14]

setwd("./DeepMS/R_script_plot/")

outdir = "."

latents = "SBS_latents.tsv"
signatures = "SBS_signatures.tsv"

latent = read.table(paste0(outdir,"/",latents), head = T, row.names = 1)
signature = read.table(paste0(outdir,"/", signatures), head = T, row.names = 1)

dim(latent)
latent = t(latent)
colnames(latent) = gsub("\\.","-",colnames(latent))

dim(signature)
signature = t(signature)
colnames(signature) = gsub("\\.","-",colnames(signature))

sig_threshold <- function (x){
	x = as.numeric(x)
	low = mean(x) - 2.58 * sd(x)
	high = mean(x) + 2.58 * sd(x)
	limit = c(low, high)
	return(limit)
}

label_raw = as.data.frame(colnames(latent))
names(label_raw) = "V1"
label_raw$V2 = NA
label_raw$V3 = NA
for (i in 1:ncol(latent)){
        label_raw$V2[i] = paste0( strsplit(as.character(label_raw$V1),"")[[i]][c(2)],  strsplit(as.character(label_raw$V1),"")[[i]][c(3)],  strsplit(as.character(label_raw$V1),"")[[i]][c(4)],"->", strsplit(as.character(label_raw$V1),"")[[i]][c(7)])
}

latent_sbs1536_barplot <- function (target, title_figure){
	target_merged = tapply(target, label_raw$V2, mean)
	target_merged = as.data.frame(target_merged)
	names(target_merged) = "V1"
	target_merged$V2 = NA
	for (k in 1:96){
		target_merged$V2[k] = paste0(strsplit(rownames(target_merged),"")[[k]][2], strsplit(rownames(target_merged),"")[[k]][6])
	}
		target_merged$V3 = target_merged$V2
        target_merged$V3 = gsub("TC", "5-TC", target_merged$V3)
        target_merged$V3 = gsub("TG", "6-TG", target_merged$V3)
        target_merged$V3 = gsub("TA", "4-TA", target_merged$V3)
        target_merged$V3 = gsub("CA", "1-CA", target_merged$V3)
        target_merged$V3 = gsub("CG", "2-CG", target_merged$V3)
        target_merged$V3 = gsub("CT", "3-CT", target_merged$V3)

        target_merged = target_merged[order(target_merged$V3),]

	x = target_merged[,1] 
	
	barplot(x, xlim = c(1,96*1.5), ylim = c(0, max(0.000002, x)*1.5), space = 0.5, col = c(rep("blue",16),rep("black",16),rep("red",16),rep("grey",16),rep("green",16),rep("tan",16)), xaxt = "n", main = title_figure)
	text(c(1:length(x))*1.5+0.6,y= - max(0.000002, x) * 0.05,adj = 0, labels = rownames(target_merged), cex=0.8,srt = 90, xpd = TRUE, pos = 2)
    text(x = c(8,24,40,56,72,88)*1.5, y = max(0.000002*1.45, max(x)*1.45), labels = c("C->A","C->G","C->T","T->A","T->C","T->G"), cex=1.2)
		
	rect(0*1.5+0.2,max(0.00002, x)*1.4, 16*1.5-0.2, max(0.000002, x)*1.3, col = "blue", border = NA)
	rect(16*1.5+0.2,max(0.00002, x)*1.4, 32*1.5-0.2, max(0.000002, x)*1.3, col = "black", border = NA)
	rect(32*1.5+0.2,max(0.00002, x)*1.4, 48*1.5-0.2, max(0.000002, x)*1.3, col = "red", border = NA)
	rect(48*1.5+0.2,max(0.00002, x)*1.4, 64*1.5-0.2, max(0.000002, x)*1.3, col = "grey", border = NA)
	rect(64*1.5+0.2,max(0.00002, x)*1.4, 80*1.5-0.2, max(0.000002, x)*1.3, col = "green", border = NA)
	rect(80*1.5+0.2,max(0.00002, x)*1.4, 96*1.5-0.2, max(0.000002, x)*1.3, col = "tan", border = NA)
		
	#abline( h = 0, lty = 1, col="black");
	#abline( h = 1, lty = 2, col="black");
	#abline( h = x[1], lty = 2, col="blue");
	#abline( h = x[2], lty = 2, col="red");

	if (length(x[x > sig_threshold(x)[2]]) > 0){
	#	id = which(x > sig_threshold(x)[2])
	#	text((c(1:length(x))*1.5+0.6)[id],y= max(0.000002*0.6, max(x)*1.25), adj = 0, labels = names(x)[id], cex=0.8,srt = 90, xpd = TRUE, pos = 2, col = "red")
	}
	return (x) 
}

latent_sbs1536_summary <- function (target){
	target_merged = tapply(target, label_raw$V2, mean)
	target_merged = as.data.frame(target_merged)
	names(target_merged) = "V1"
	target_merged$V2 = NA
	for (k in 1:96){
		target_merged$V2[k] = paste0(strsplit(rownames(target_merged),"")[[k]][2], strsplit(rownames(target_merged),"")[[k]][6])
	}
		target_merged$V3 = target_merged$V2
        target_merged$V3 = gsub("TC", "5-TC", target_merged$V3)
        target_merged$V3 = gsub("TG", "6-TG", target_merged$V3)
        target_merged$V3 = gsub("TA", "4-TA", target_merged$V3)
        target_merged$V3 = gsub("CA", "1-CA", target_merged$V3)
        target_merged$V3 = gsub("CG", "2-CG", target_merged$V3)
        target_merged$V3 = gsub("CT", "3-CT", target_merged$V3)
        target_merged = target_merged[order(target_merged$V3),]
		x = target_merged[,1] 
		return (x) 
}

merged_matrix = as.data.frame(matrix(NA, nrow = 96, ncol = nrow(latent)))
rownames(merged_matrix) = names(latent_sbs1536_summary(latent[1,]))

pdf(paste0(outdir,"/SBS_latents.pdf"), 18, 10)
par(mfrow = c(3,2));
par(mar=c(5,3,3,3));
for (i in 1:nrow(latent)){
	latent_sbs1536_barplot(latent[i,], paste0("D-SBS-Latent ",i))
	merged_matrix[,i] = latent_sbs1536_summary(latent[i,])
}
dev.off()

pdf(paste0(outdir,"/SBS_signatures.pdf"), 18, 10)
par(mfrow = c(3,2));
par(mar=c(5,3,3,3));
for (i in 1:nrow(signature)){
	latent_sbs1536_barplot(signature[i,], paste0("D-SBS-Signature ",i))
}
dev.off()
