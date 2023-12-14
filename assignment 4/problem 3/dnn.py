import matplotlib.pyplot as plt
import numpy as np

import keras.models as km
import keras.layers as kl
import keras.utils as ku
import tensorflow as tf

from sklearn import datasets
from sklearn.preprocessing import StandardScaler


# Make the neural network model
def get_feedforward_neural_network(numnodes):
	model = km.Sequential()
	# Hidden layer
	model.add(kl.Dense(numnodes, input_dim=2, activation='sigmoid'))
	# Output layer
	model.add(kl.Dense(1, activation='sigmoid'))
	return model


def plot_accuracy_loss():
	fig, ax = plt.subplots(ncols=2, figsize=(12,4))
	ax[0].plot(ffNN_fit.history['accuracy'], label='training accuracy')
	ax[0].plot(ffNN_fit.history['val_accuracy'], label='validation accuracy')
	ax[1].plot(ffNN_fit.history['loss'], label='training loss')
	ax[1].plot(ffNN_fit.history['val_loss'], label='validation loss')
	ax[0].set_xlabel('Epoch')
	ax[1].set_xlabel('Epoch')
	ax[0].set_ylabel('Accuracy')
	ax[1].set_ylabel('Loss')
	ax[0].legend()
	ax[1].legend()
	
	fig.suptitle(f'n_train={n_train}, n_neurons={n_nodes}')
	fig.tight_layout()
	fig.savefig(f'plots/acc_loss_ntrain={n_train}_nneurons={n_nodes}.pdf')


def plot_data():
	y_predict = ffNN.predict(x_test)
	y_predict = np.round(y_predict, 0)
	fig, ax = plt.subplots()
	ax.scatter(x[:,0], x[:,1], c=y, cmap='Pastel1', marker='.')
	ax.scatter(x_test[:,0], x_test[:,1], c=y_predict, cmap='Set1', marker='o')
	
	fig.suptitle(f'n_train={n_train}, n_neurons={n_nodes}')
	fig.tight_layout()
	fig.savefig(f'plots/points_ntrain={n_train}_nneurons={n_nodes}.pdf')


# Hyperparameters of datasets and model
n_train = 20000
n_test = 100
n_nodes = 100
n_epochs = 100

noisy_circles_train = datasets.make_circles(
	n_samples=n_train, factor=0.5, noise=0.05
)
noisy_circles_test = datasets.make_circles(
	n_samples=n_test, factor=0.5, noise=0.05
)

x, y = noisy_circles_train
x_test, y_test = noisy_circles_test

# Normalize dataset for easier parameter selection
x = StandardScaler().fit_transform(x)
x_test = StandardScaler().fit_transform(x_test)

ffNN = get_feedforward_neural_network(n_nodes)
ffNN.compile(optimizer='sgd', loss='binary_crossentropy', metrics=['accuracy'])
ffNN_fit = ffNN.fit(x, y, epochs=n_epochs, verbose=1, validation_data=(x_test, y_test))

plot_accuracy_loss()
plot_data()


# Predictions, bias, and variance
# Compute predictions
y_predict = np.zeros(n_test)
y_predict = ffNN.predict(x_test)

y_error = np.zeros(n_test)
y_var = np.zeros(n_test)

means = np.zeros(2)
counts = np.zeros(2)
for i in range(n_test):
	j = y_test[i]
	y_error[i] = (y_test[i] - y_predict[i])**2
	counts[j] += 1
	means[j] += y_predict[i]
	
means /= counts

y_var = 0
y_bias = 0
for i in range(n_test):
	j = y_test[i]
	y_var += (y_predict[i] - means[j]) ** 2
	y_bias += (y_test[i] - means[j]) ** 2
	
y_var /= n_test
y_bias /= n_test
y_var = np.mean(y_var)

print(f'{np.mean(y_error)} (error) = {np.mean(y_bias)}(bias^2) + '
	f'{np.mean(y_var)}(var)'
	)
	
print(f'{n_train}', f'{n_nodes}', f'{y_bias}', f'{y_var}', file=open('data.dat', 'a'))
