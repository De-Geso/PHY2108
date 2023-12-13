#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 30 09:53:30 2023

@author: bfriesen
"""

import keras
from keras.datasets import mnist
import matplotlib.pyplot as plt
import numpy as np
from sklearn import metrics
from sklearn.cluster import DBSCAN

start_time = time()
print(start_time)

# Import our data
(x_train,y_train),(x_test,y_test)=digits.load_data()
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

db = DBSCAN(eps=1, min_samples=5).fit(X)
labels = db.labels_

# Number of clusters in labesls, ignoring noise if present.
n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)
n_noise_ = list(labels).count(-1)

print("Estimated number of clusters: %d" % n_clusters_)
print("Estimated number of noise points: %d" % n_noise_)

print("Runtime:", time()-start_time)