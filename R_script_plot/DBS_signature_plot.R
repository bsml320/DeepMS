library(RColorBrewer)
mycol <- c(brewer.pal(12,"Set3")[c(-2,-12)],brewer.pal(8,"Set2"),brewer.pal(9,"Set1"),brewer.pal(12,"Paired"))
mycol <- mycol[-14]

setwd("./DeepMS/R_script_plot/")

outdir = "."

latents = "DBS_latents.tsv"
signatures = "DBS_signatures.tsv"

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


latent_dbs_barplot <- function (x, title_figure){
	barplot(x, xlim = c(1,length(x)*1.5), ylim = c(0, max(0.00002, x)*1.5), space = 0.5, col = mycol[ c(rep(1,9), rep(2,6),rep(3,9),rep(4,6),rep(5,9),rep(6,6),rep(7,6),rep(8,9),rep(9,9),rep(10,9))], xaxt = "n" , main = title_figure)
	text(c(1:length(x))*1.5+0.6,y= - max(0.00002, x) * 0.05,adj = 0, labels = names(x), cex=0.8,srt = 90, xpd = TRUE, pos = 2)
	text(c(4.5,12,19.5,27,34.5,42,48,55.5,64.5,73.5)*1.5, max(0.00002*1.4, max(x)*1.45), labels = c("AC->NN","AT->NN","CC->NN","CG->NN","CT->NN","GC->NN","TA->NN","TC->NN","TG->NN","TT->NN"), cex=1.2)	
	rect(0*1.5+0.2,max(0.00002, x)*1.4, 9*1.5-0.2, max(0.00002, x)*1.3, col = mycol[1], border = NA)
	rect(9*1.5+0.2,max(0.00002, x)*1.4, 15*1.5-0.2, max(0.00002, x)*1.3, col = mycol[2], border = NA)
	rect(15*1.5+0.2,max(0.00002, x)*1.4, 24*1.5-0.2, max(0.00002, x)*1.3, col = mycol[3], border = NA)
	rect(24*1.5+0.2,max(0.00002, x)*1.4, 30*1.5-0.2, max(0.00002, x)*1.3, col = mycol[4], border = NA)
	rect(30*1.5+0.2,max(0.00002, x)*1.4, 39*1.5-0.2, max(0.00002, x)*1.3, col = mycol[5], border = NA)
	rect(39*1.5+0.2,max(0.00002, x)*1.4, 45*1.5-0.2, max(0.00002, x)*1.3, col = mycol[6], border = NA)
	rect(45*1.5+0.2,max(0.00002, x)*1.4, 51*1.5-0.2, max(0.00002, x)*1.3, col = mycol[7], border = NA)
	rect(51*1.5+0.2,max(0.00002, x)*1.4, 60*1.5-0.2, max(0.00002, x)*1.3, col = mycol[8], border = NA)
	rect(60*1.5+0.2,max(0.00002, x)*1.4, 69*1.5-0.2, max(0.00002, x)*1.3, col = mycol[9], border = NA)
	rect(69*1.5+0.2,max(0.00002, x)*1.4, 78*1.5-0.2, max(0.00002, x)*1.3, col = mycol[10], border = NA)

	#abline( h = 0, lty = 1, col="black");
	#abline( h = 1, lty = 2, col="black");
	#abline( h = x[1], lty = 2, col="blue");
	#abline( h = x[2], lty = 2, col="red");

	if (length(x[x > sig_threshold(x)[2]]) > 0){
	#	id = which(x > sig_threshold(x)[2])
	#	text((c(1:length(x))*1.5+0.6)[id],y= max(0.00002*0.6,max(x)*1.2), adj = 0, labels = names(x)[id],cex=0.8,srt = 90,xpd = TRUE, pos = 2, col = "red")
	}	
}

pdf(paste0(outdir,"/DBS_latents.pdf"), 18, 10)
par(mfrow = c(3,2));
par(mar=c(5,3,3,3));
for (i in 1:nrow(latent)){
	latent_dbs_barplot(latent[i,], paste0("D-DBS-Latent ",i))
}
dev.off()

pdf(paste0(outdir,"/DBS_signatures.pdf"), 18, 10)
par(mfrow = c(3,2));
par(mar=c(5,3,3,3));
for (i in 1:nrow(signature)){
	latent_dbs_barplot(signature[i,], paste0("D-DBS-Signature ",i))
}
dev.off()
