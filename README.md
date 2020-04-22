# DeepMS (v1.0)
# 1. DeepMS introduction
Millions of somatic mutations have recently been discovered in cancer genomes. These mutations in cancer genomes occur due to internal and external mutagenesis forces. Decoding the mutational processes by examining their unique patterns has successfully revealed many known and novel signatures from whole exome data, but many still remain undiscovered. Here, we developed a deep learning approach, DeepMS, to decompose mutational signatures using 52,671,908 somatic mutations from 2780 highly curated cancer genomes with whole genome sequencing (WGS) in 37 cancer types/subtypes. With rigorous model training and comparison, we characterized 54 signatures for single base substitutions (SBS), 11 for doublet base substitutions (DBS) and 16 for small insertions and deletions (Indel). Compared to the previous methods, DeepMS could discover 37 SBS, 5 DBS and 9 Indel new signatures, many of which represent associations with DNA mismatch or base excision repair and cisplatin therapy mechanisms. The first deep learning model DeepMS on WGS somatic mutational profiles enable us identify more comprehensive context-based mutational signatures than traditional NMF approaches.

# 2. Usage
## 2.1 Download  
### Requirements
DeepMS relies on python (>= 2.7), TensorFlow (>=1.15), keras (>=2.31).
### To download the codes, please do:
  `> git clone https://github.com/bsml320/DeepMS.git  `  
  `> cd DeepMS  `
## 2.2 Input data
DeepMS deals mutation frequency matrix directly. For convenience, we provide the normorlized somatic mutations data from hole genome sequencing (WGS) of tumor samples by International Cancer Genome Consortium (ICGC) Pan-Cancer Analysis of Whole Genomes (PCAWG) working group. Each matrix was formatted as mutation types on rows and samples on columns, i.e., M = {mij}, i = 1,…K, j = 1,…N, where mij represented the frequency of mutation type i in sample j, K was the total number of mutation types (KSBS = 1536, KDBS = 78, KIndel = 84), and N was sample size (N = 2780). User can download them from original paper:  
  `>  wget https://dcc.icgc.org/api/v1/download?fn=/PCAWG/mutational_signatures/Input_Data_PCAWG7_23K_Spectra_DB/Mutation_Catalogs_--_Spectra_of_Individual_Tumours/WGS_PCAWG_2018_02_09.zip  `  
  `>  unzip -d WGS_PCAWG *WGS_PCAWG_2018_02_09.zip`  
  `>  rm *WGS_PCAWG_2018_02_09.zip`  
&#8194;&#8194;Then, user can preprocess these data by using our preprocess scripts.   
  `>  Rscript Preprocess/SBS_preprocess.R  `     
  `>  Rscript Preprocess/DBS_preprocess.R  `  
  `>  Rscript Preprocess/Indel_preprocess.R  `  
   
## 2.3 DeepMS model
DeepMS utilize the Denoising Sparse Auto-Encoder (DSAE) model with three layers: an input layer, a latent layer, and an output layer. The input layer takes the modified mutation frequency matrix (i.e., normalized mutation frequency matrix with random noise, denoted by X) as input; the latent layer represents the compressed representation of the input matrix after encoding; and the output layer represents the reconstructed mutation frequency matrix. The encoding process includes a linear transformation of the input matrix followed by a nonlinear Rectified Linear Units (ReLU) transformation, Y=relu(W_eX+b_e), where X^(∈K×N) is the modified mutational profiles, Y^(∈K×L) is the latent matrix, W_e^(∈N×L) is the weight matrix, and b_e is the hidden bias vector during the encoding process. The decoding process aims at reconstructing the input by transforming the latent matrix Y using the decoding weight matrix W_d and the hidden bias vector b_d, followed by applying a Softmax classification. We defined the loss function L_H based on the difference between the input matrix (X) and the reconstructed mutational profiles on the output layer (Z). L_H, also called the reconstruction error, takes the format of mean squared error (MSE). To avoid flat signatures, we further included a L1 regularization to minimize L_H.  
&#8194;&#8194;Several parameters in the model could impact the performance, such as the latent layer dimension, batch size, learning rate and noisy factor. To reach the appropriate performance of the model, parameter optimization is necessary. We provide four external parameters for user convenience.    
&#8194;&#8194;Users can repeat our result in our origial study by using below paramters, corresponding to latent layer dimension, batch size, learning rate and noisy factor.  
 `> python ./DeepMS_model.py WGS_PCAWG.SBS.txt 200 32 1e-4 0  `  
 `> python ./DeepMS_model.py WGS_PCAWG.DBS.txt 35 32 1e-4 0.01  `  
 `> python ./DeepMS_model.py WGS_PCAWG.Indel.txt 42 32 1e-4 0   `  
&#8194;&#8194;Some slight difference would happen when different TensorFlow and keras version are used.   
&#8194;&#8194;We further merge similar latent layers to representative mutational signatures.    
 &#8194;&#8194;&#8194;&#8194; ![SBS](https://github.com/bsml320/DeepMS/tree/master/R_script_plot/SBS_signatures.pdf)    
 &#8194;&#8194;&#8194;&#8194; ![DBS](https://github.com/bsml320/DeepMS/tree/master/R_script_plot/DBS_signatures.pdf)   
 &#8194;&#8194;&#8194;&#8194; ![Indel](https://github.com/bsml320/DeepMS/tree/master/R_script_plot/Indel_signatures.pdf)   
## 2.4 Mutational signatures plot
We provide the final results in our manuscript and R codes (in folder R_script_plot) to repeat the figures in our original manuscript. These R scripts (SBS, DBS and Indel) rely on necessary package, such as RColorBrewer.   
Please remember cite our manuscript (Pei G, 2020) even you used the R codes for mutational signatures plotting.

## Citation
Pei G, Hu R, Dai Y, Zhao Z, Jia P. Decoding whole-genome mutational signatures in 37 human pan-cancers by denoising sparse autoencoder neural network. 2020. Under review.
