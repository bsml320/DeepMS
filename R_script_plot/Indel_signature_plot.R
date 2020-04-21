library(RColorBrewer)
mycol <- c(brewer.pal(12,"Set3")[c(-2,-12)],brewer.pal(8,"Set2"),brewer.pal(9,"Set1"),brewer.pal(12,"Paired"))
mycol <- mycol[-14]

setwd("./DeepMS/R_script_plot/")

outdir = "."

latents = "Indel_latents.tsv"
signatures = "Indel_signatures.tsv"

latent = read.table(paste0(outdir,"/",latents), head = T, row.names = 1)
signature = read.table(paste0(outdir,"/", signatures), head = T, row.names = 1)

dim(latent)
latent = t(latent)
colnames(latent) = gsub("\\.","-", colnames(latent))

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

indels = as.data.frame(t(matrix(NA, 4, ncol=length(colnames(latent)))))

for (i in 1:length(colnames(latent))){
	indels[i,1] = strsplit(colnames(latent)[i],"\\_")[[1]][1]
	indels[i,2] = strsplit(colnames(latent)[i],"\\_")[[1]][2]
	indels[i,3] = strsplit(colnames(latent)[i],"\\_")[[1]][3]
}

latent_indels_barplot <- function (x, title_figure){
	barplot(x, xlim = c(1,length(x)*1.5), ylim = c(max(0.00002, x)*(-0.05), max(0.00002, x)*1.5), space = 0.5, col = mycol[ c(rep(1,6), rep(2,6),rep(3,6),rep(4,6),rep(5,6),rep(6,6),rep(7,6),rep(8,6),rep(9,6),rep(10,6),rep(11,6),rep(12,6),rep(13,1),rep(14,2),rep(15,3),rep(16,5))], xaxt = "n" , main = title_figure)
	text(c(1:length(x))*1.5-0.4,y= - max(0.00002, x) * 0.02, adj = 0, labels = unlist(indels[3]), cex=0.8, srt = 0, xpd = TRUE, pos = 1)
	text(c(6,18)*1.5, max(0.00002*1.43, max(x)*1.43), xpd=T,labels = c("1 bp deletion", "1 bp insertion"), cex=1.0)
	text(c(36,60,78)*1.5, max(0.00002*1.48, max(x)*1.48), xpd=T,labels = c(">1bp deletions at repeats", ">1bp insertions at repeats", "Deletions with microhomology"), cex=1.0)	
	text(c(6,18,36,60,78)*1.5, -max(0.00002*1.48, max(x)*1.48)* 0.12, xpd=T, labels = c("Homopolymer length","Homopolymer length", "Number of repeat units", "Number of repeat units", "Microhomology length"), cex=1.0)
	text(c(36,60,78)*1.5, max(0.00002*1.41, max(x)*1.41), xpd=T,labels = c("(Deletion length)", "Insertion length", "Deletion length"), cex=1.0)
	rect(0*1.5+0.2,max(0.00002, x)*1.38, 6*1.5-0.2, max(0.00002, x)*1.3, col = mycol[1], border = NA)
	rect(6*1.5+0.2,max(0.00002, x)*1.38, 12*1.5-0.2, max(0.00002, x)*1.3, col = mycol[2], border = NA)
	rect(12*1.5+0.2,max(0.00002, x)*1.38, 18*1.5-0.2, max(0.00002, x)*1.3, col = mycol[3], border = NA)
	rect(18*1.5+0.2,max(0.00002, x)*1.38, 24*1.5-0.2, max(0.00002, x)*1.3, col = mycol[4], border = NA)
	rect(24*1.5+0.2,max(0.00002, x)*1.38, 30*1.5-0.2, max(0.00002, x)*1.3, col = mycol[5], border = NA)
	rect(30*1.5+0.2,max(0.00002, x)*1.38, 36*1.5-0.2, max(0.00002, x)*1.3, col = mycol[6], border = NA)
	rect(36*1.5+0.2,max(0.00002, x)*1.38, 42*1.5-0.2, max(0.00002, x)*1.3, col = mycol[7], border = NA)
	rect(42*1.5+0.2,max(0.00002, x)*1.38, 48*1.5-0.2, max(0.00002, x)*1.3, col = mycol[8], border = NA)
	rect(48*1.5+0.2,max(0.00002, x)*1.38, 54*1.5-0.2, max(0.00002, x)*1.3, col = mycol[9], border = NA)
	rect(54*1.5+0.2,max(0.00002, x)*1.38, 60*1.5-0.2, max(0.00002, x)*1.3, col = mycol[10], border = NA)
	rect(60*1.5+0.2,max(0.00002, x)*1.38, 66*1.5-0.2, max(0.00002, x)*1.3, col = mycol[11], border = NA)
	rect(66*1.5+0.2,max(0.00002, x)*1.38, 72*1.5-0.2, max(0.00002, x)*1.3, col = mycol[12], border = NA)
	rect(72*1.5+0.2,max(0.00002, x)*1.38, 73*1.5-0.2, max(0.00002, x)*1.3, col = mycol[13], border = NA)
	rect(73*1.5+0.2,max(0.00002, x)*1.38, 75*1.5-0.2, max(0.00002, x)*1.3, col = mycol[14], border = NA)
	rect(75*1.5+0.2,max(0.00002, x)*1.38, 78*1.5-0.2, max(0.00002, x)*1.3, col = mycol[15], border = NA)
	rect(78*1.5+0.2,max(0.00002, x)*1.38, 83*1.5-0.2, max(0.00002, x)*1.3, col = mycol[16], border = NA)	
	text(c(3,9,15,21,27,33,39,45,51,57,63,69,72.5,74,76.5,80.5)*1.5, max(0.00002*1.34, max(x)*1.34), xpd=T,labels = c("C","T","C","T","2","3","4","5+","2","3","4","5","2","3","4","5+"), cex=1.0)
}
 
pdf(paste0(outdir,"/Indel_latents.pdf"), 18, 10)
par(mfrow = c(3,2));
par(mar=c(5,3,3,3));
for (i in 1:nrow(latent)){
	latent_indels_barplot(latent[i,], paste0("D-Indel-Latent ",i))
}
dev.off()

pdf(paste0(outdir,"/Indel_signatures.pdf"), 18, 10)
par(mfrow = c(3,2));
par(mar=c(5,3,3,3));
for (i in 1:nrow(signature)){
	latent_indels_barplot(signature[i,], paste0("D-Indel-Signature ",i))
}
dev.off()
