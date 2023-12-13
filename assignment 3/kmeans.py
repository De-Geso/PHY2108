#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 28 16:37:42 2023

@author: bfriesen
"""
def kmeans (X,Y,k,init):
    means = init
    update_size = 1.
    print(len(X), len(X[0]))
    
    while (np.linalg.norm(update_size) > 10**-1):
        new_means = np.zeros_like(means)
        n_cluster = np.zeros(k)

        # Measure the distances to start clustering.
        for i in range(len(X)):
            # Initialize with distance between 0th mean and ith image.
            min_distance = np.linalg.norm(np.subtract(X[i], means[0]))
            min_k = 0
            # Compare distance to each mean.
            for j in range(k):
                # Measure distance from jth mean to ith image.
                distance = np.linalg.norm(np.subtract(X[i], means[j]))
                # Update closest mean
                if distance < min_distance:
                    min_distance = distance
                    min_k = j
            
            # Add the vector to the sum of all vectors in that cluster.
            new_means[min_k,:] = new_means[min_k,:] + X[i]
            n_cluster[min_k] += 1
        
        
        # Calculate new means
        for i in range(k):
            new_means[i,:] = new_means[i,:]/(n_cluster[i])
        
        # Update the difference between the old means and the new means.
        update_size = np.linalg.norm(np.subtract(means, new_means))
        print(n_cluster)
        print(update_size)
        
        means = new_means
    return means


def plot_kmeans(means):
    # I hate Python
    images = np.copy(means)
    images = images.reshape(k,28,28)
    print(np.amax(means))
    images *= 255
    print(np.amax(means))
    images = images.astype(np.uint8)

    fig, axs = plt.subplots(2,5)
    plt.gray()
    fig.suptitle('Cluster Centroids')
    for i, ax in enumerate(axs.flat):
        ax.set_title(f'Cluster {i}')
        ax.matshow(images[i])
        ax.axis('off')
    fig.tight_layout()
    fig.show()
    return


def test_kmeans(X,Y,means):
    counts = np.zeros([k,k], dtype=int)
    cluster_value = np.zeros(k, dtype=int)
    for i in range(len(Y)):
        min_distance = 1000000
        min_k = 0
        for j in range(k):
            # Measure distance from jth mean to ith image.
            distance = np.linalg.norm(np.subtract(X[i], means[j]))
            # Update closest mean
            if distance < min_distance:
                min_distance = distance
                min_k = j
        counts[Y[i],min_k] += 1
    print(counts)

    # Guess the value that each cluster is supposed to be.
    for i in range(k):
        cluster_value[i] = counts[:,i].argmax()
    print(cluster_value)

    correct = 0
    for i in range(k):
        correct += counts[cluster_value[i],i]
    accuracy = np.sum(correct)/len(Y)
    
    fig = plt.figure()
    plt.title(f'Confusion Matrix for MNIST using k-means (k={k})',)
    plt.imshow(counts, interpolation='none', cmap=plt.cm.Blues)
    plt.ylabel('True Label')
    plt.xlabel('Cluster')
    fig.tight_layout()
    plt.show()
    print(f'Accuracy of k-means clustering (k={k}):', accuracy)
    return counts


import keras
from keras.datasets import mnist
import matplotlib.pyplot as plt
import numpy as np

# Import our data
(x_train,y_train),(x_test,y_test)=mnist.load_data()
# We want to use one dimensional arrays for clustering. Turn our 28x28 pixel
# pictures into 784 long vectors.
X = x_train.reshape(len(x_train),-1)
X_test = x_test.reshape(len(x_test),-1)
# Normalize our data, so that it goes from 0 to 1, instead of 0 to 255.
X = X.astype(float) / 255
X_test = X_test.astype(float) / 255
# This is just a list of what the numbers actually are.
Y = y_train 
Y_test = y_test


# K-means part of the program.
# Number of clusters. 10 for 10 digits.
k = 10
# Make an initial guess.
init = np.zeros([k, len(X[0])])
for i in range(k):
    init[i,:]=X[np.random.randint(len(X))]
    
# Run the kmeans algorithm
kmeans_means = kmeans(X, Y, k, init)
# Plot the k means images
plot_kmeans(kmeans_means)
# Calculate the accuracy
kmeans_counts = test_kmeans(X_test, Y_test, kmeans_means)
