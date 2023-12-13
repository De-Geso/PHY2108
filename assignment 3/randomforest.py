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
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix


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

rf = RandomForestClassifier(n_estimators=10)
rf.fit(X,Y)

pred = rf.predict(X_test)
print("Classification Report")
print(classification_report(Y_test, pred))
print("Confusion Report")
print(confusion_matrix(Y_test, pred))

fig = plt.figure()
plt.title(f'Confusion Matrix for MNIST using RandomForest (trees=10)',)
plt.imshow(confusion_matrix(Y_test, pred), interpolation='none', cmap=plt.cm.Blues)
plt.ylabel('True Label')
plt.xlabel('Classification')
fig.tight_layout()
plt.show()
