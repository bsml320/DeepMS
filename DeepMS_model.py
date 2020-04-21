# -*- coding: utf-8 -*-
import sys
import subprocess
import os
import numpy as np
import pandas as pd
np.random.seed(56)  # for reproducibility
 
from keras.models import Model 
from keras.layers import Dense, Input, Dropout
from keras import regularizers

#============================================
output_file = sys.argv[1]

latent_dim = int(sys.argv[2])

batch_size_n = int(sys.argv[3])

learning_rate = float(sys.argv[4])

noise_factor = float(sys.argv[5])
#============================================

#output_file = "matrix_top10k_markers"

#os.mkdir("AE_"+output_file)

mf_file = os.path.join('', output_file)
mf_df = pd.read_table(mf_file, index_col=0)

print(mf_df.shape)

output_file = (str(output_file)+"_"+str(latent_dim)+"_"+str(batch_size_n)+"_"+str(learning_rate)+"_"+str(noise_factor))

if os.path.exists("DeepMS_"+output_file):
        cmd = 'rm -r '+"DeepMS_"+output_file
        print(cmd)
        subprocess.call(cmd, shell=True)

os.mkdir("DeepMS_"+output_file)

np.random.seed(56)

test_set_percent = 0.2

x_test = mf_df.sample(frac=test_set_percent)
#x_test = mf_df
x_train = mf_df.drop(x_test.index)
#x_train = mf_df
x_train_noisy = x_train + noise_factor * np.random.normal(loc=0.0, scale=1.0, size = x_train.shape)

x_test_noisy = x_test + noise_factor * np.random.normal(loc=0.0, scale=1.0, size = x_test.shape)

x_train_noisy = np.clip(x_train_noisy, 0., 1.)

x_test_noisy = np.clip(x_test_noisy, 0., 1.)

original_dim = mf_df.shape[1]

epochs_n = 50

# Compress to 100 dim
encoding_dim = latent_dim
 
# this is our input placeholder
input_dim = Input(shape=(original_dim,))
 
# encode
encoder_output = Dense(encoding_dim, activation = "relu", activity_regularizer = regularizers.l1(1e-12))(input_dim)

# decode
decoded = Dense(original_dim, activation = "softmax")(encoder_output)
 
# autoencoder model
autoencoder = Model(inputs = input_dim, outputs = decoded)
 
# compile autoencoder
autoencoder.compile(optimizer='adam', loss='mse')
 
# training
hist = autoencoder.fit(x_train_noisy, x_train, epochs=epochs_n, batch_size=batch_size_n, shuffle=True, validation_data=(x_test_noisy, x_test))
history_df = pd.DataFrame(hist.history)

loss_file = os.path.join("DeepMS_"+output_file, 'Model_evaluation_'+output_file+'.txt')
history_df.to_csv(loss_file, sep="\t")

# encoder model
encoder = Model(inputs = input_dim, outputs = encoder_output)

encoded_df = encoder.predict_on_batch(mf_df)
encoded_df = pd.DataFrame(encoded_df, index = mf_df.index)

encoded_df.index.name = 'sample_id'
encoded_df.columns.name = 'sample_id'

encoded_df.columns = encoded_df.columns + 1
encoded_file = os.path.join("DeepMS_"+output_file, 'Latents_'+output_file+'.tsv')
encoded_df.to_csv(encoded_file, sep='\t')

# create a placeholder for an encoded (32-dimensional) input

encoded_input = Input(shape=(encoding_dim,))

# retrieve the last layer of the autoencoder model
decoder_layer = autoencoder.layers[-1]
# create the decoder model
decoder = Model( encoded_input, decoder_layer(encoded_input))

#autoencoder.compile(optimizer='adadelta', loss='binary_crossentropy')
weights = []
for layer in encoder.layers:
        weights.append(layer.get_weights())

#weight_layer_df = pd.DataFrame(weights[1][0], columns=mf_df.columns, index=range(1, latent_dim+1))
weight_layer_df = pd.DataFrame(np.transpose(weights[1][0]), columns=mf_df.columns, index=range(1, latent_dim+1))
weight_layer_df.index.name = 'encodings'

weight_file = os.path.join("DeepMS_"+output_file, 'Weights_encoder_'+output_file+'.tsv')
weight_layer_df.to_csv(weight_file, sep='\t')

#========================
weights = []
for layer in decoder.layers:
        weights.append(layer.get_weights())

#weight_layer_df = pd.DataFrame(weights[1][0], columns=mf_df.columns, index=range(1, latent_dim+1))
weight_layer_df = pd.DataFrame(weights[1][0], columns=mf_df.columns, index=range(1, latent_dim+1))
weight_layer_df.index.name = 'decodings'

weight_file = os.path.join("DeepMS_"+output_file, 'Weights_decoder_'+output_file+'.tsv')
weight_layer_df.to_csv(weight_file, sep='\t')

if os.path.exists("DeepMS_"+output_file+"_decoder"):

        cmd = 'rm -r '+"DeepMS_"+output_file+"_decoder"

        print(cmd)
        subprocess.call(cmd, shell=True)
	
