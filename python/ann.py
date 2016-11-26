"""
100 epochs, [64 32 16 10], batch size 600 takes ~38 minutes on my desktop
30 epochs, [64 100 10], batch size 10 takes ~27 minutes
"""
import random
import numpy as np

from format_data import *

class Network:
    def __init__(self, sizes):
        """sizes is a list of the number of neurons in each layer in the
        network."""

        self.sizes = sizes
        self.numLayers = len(sizes)
        self.biases = [np.random.randn(y,1) for y in sizes[1:]]
        self.weights = [np.random.randn(y,x) for x, y in zip(sizes[:-1], sizes[1:])]

        # Normalize weights and biases to [0,1]
        for w,b in zip(self.weights, self.biases):
            w -= w.min()
            w /= w.max()
            b -= b.min()
            b /= b.max()


    def feedForward(self, a):
        """For input a, return output of network."""

        for b, w in zip(self.biases, self.weights):
            a = activate(np.dot(w,a) + b)
        return a

    def SGD(self, trainingData, epochs, batchSize, eta):
        """Performs batch stochastic gradient descent."""

        n = len(trainingData)
        for epoch in range(epochs):
            random.shuffle(trainingData)
            batches = [trainingData[k:k + batchSize] for k in range(0, n, batchSize)]
            for batch in batches:
                self.updateBatch(batch, eta)
            print("Epoch " + str(epoch) + " complete")

    def updateBatch(self, batch, eta):
        """Updates network's biases and weights by applying gradient descent
        using backpropogation to a batch of inputs.  batch is a list of tuples
        (x,y)."""

        batchSize = len(batch)

        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]

        for x, y in batch:
            delta_nabla_b, delta_nabla_w = self.backprop(x, y)
            nabla_b = [nb+dnb for nb, dnb in zip(nabla_b, delta_nabla_b)]
            nabla_w = [nw+dnw for nw, dnw in zip(nabla_w, delta_nabla_w)]

        # Update weights and biases
        self.weights = [w-(eta/batchSize)*nw for w, nw in zip(self.weights, nabla_w)]
        self.biases = [b-(eta/batchSize)*nb for b, nb in zip(self.biases, nabla_b)]

    def backprop(self, x, y):
        """Return a tuple (nabla_b, nabla_w) representing the gradient of the
        cost function."""

        # Ensure orientation of vectors x and y
        #x = x.reshape(len(x), 1)
        #y = y.reshape(len(y), 1)

        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]

        # Forward pass
        activation = x
        activations = [x]

        zs = []

        for b,w in zip(self.biases, self.weights):
            z = np.dot(w, activation) + b
            zs.append(z)
            activation = activate(z)
            activations.append(activation)

        # Backward pass
        delta = self.costDerivative(activations[-1], y) * activatePrime(zs[-1])
        nabla_b[-1] = delta
        nabla_w[-1] = np.dot(delta, activations[-2].T)

        # Work backwards from end of network, apply chain rule
        for l in range(2, self.numLayers):
            z = zs[-l]
            delta = np.dot(self.weights[-l+1].T, delta) * activatePrime(z)
            nabla_b[-l] = delta
            nabla_w[-l] = np.dot(delta, activations[-l-1].T)

        # Reverse lists:
        #nabla_b = nabla_b[::-1]
        #nabla_w = nabla_w[::-1]
        return (nabla_b, nabla_w)


    def evaluate(self, testData):
        pass

    def costDerivative(self, outputActivations, y):
        return outputActivations - y

### Other functions

def sigmoidFloat(z):
    return 1.0/(1.0 + np.exp(-z))

def sigmoidPrimeFloat(z):
    return sigmoidFloat(z)*(1 - sigmoidFloat(z))

sigmoid = np.frompyfunc(sigmoidFloat, 1, 1)
sigmoidPrime = np.frompyfunc(sigmoidPrimeFloat, 1, 1)

def reluFloat(z):
    return max(0,z)

def reluPrimeFloat(z):
    if z > 0:
        return 1
    return 0

relu = np.frompyfunc(reluFloat, 1, 1)
reluPrime = np.frompyfunc(reluPrimeFloat, 1, 1)

# Choose activation function

activate = sigmoid
activatePrime = sigmoidPrime
#activate = relu
#activatePrime = reluPrime

def test(data):
    # Architecture:
    # input layer: 64
    # layer 0: 32
    # layer 1: 16
    # layer 2: 10
    #sizes = [64, 32, 16, 10]
    sizes = [64, 100, 10]
    ANN = Network(sizes)

    numEpochs = 1
    batchSize = 100
    learningRate = 1.0

    # Halve data set for faster testing
    data = data[:int(len(data)/2)]

    x = data[0][0]
    y = data[0][1]

    yhat = ANN.feedForward(x)
    print(y - yhat)

    timeFunc(ANN.SGD, data, numEpochs, batchSize, learningRate)

    yhat = ANN.feedForward(x)
    print(y - yhat)



    return ANN
