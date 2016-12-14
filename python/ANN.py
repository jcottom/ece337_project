#!/usr/bin/env python


import numpy as np
import os
import time


import convert_fixed_point
import FixedToBinary

fileType = "8x8"

#class containing methods for ANN computations and parameters for the size of the network
class Neural_Network(object):
    def __init__(self):
        #Define Hyperparameters - layer sizes
        self.inputLayerSize = 64
        self.hiddenLayer1Size = 16
        self.hiddenLayer2Size = 8
        self.outputLayerSize = 10

        #if there are weights already trained, load them from the file
        layerSize, w1, w2, w3 = LoadWeightFromFile()
        if (layerSize == None or layerSize[1] != self.hiddenLayer1Size or layerSize[2] != self.hiddenLayer2Size or layerSize[3] != self.outputLayerSize):
            #Weights (parameters)
            self.W1 = np.random.randn(self.inputLayerSize,self.hiddenLayer1Size)
            self.W2 = np.random.randn(self.hiddenLayer1Size,self.hiddenLayer2Size)
            self.W3 = np.random.randn(self.hiddenLayer2Size, self.outputLayerSize)
        else:
            self.W1 = w1
            self.W2 = w2
            self.W3 = w3

    #forward propagation, calculates the output of the ANN
    def forward(self, X):
        self.x = X
        #Propogate inputs though network
        self.z2 = np.dot(X, self.W1)
        self.a2 = self.sigmoid(self.z2)
        self.z3 = np.dot(self.a2, self.W2)
        self.a3 = self.sigmoid(self.z3)
        self.z4 = np.dot(self.a3, self.W3)
        self.yHat = self.sigmoid(self.z4)
        return self.yHat

    #same as forward just returning all layer outputs
    def forwardReturnAll(self, X):
        #Propogate inputs though network
        self.z2 = np.dot(X, self.W1)
        self.a2 = self.sigmoid(self.z2)
        self.z3 = np.dot(self.a2, self.W2)
        self.a3 = self.sigmoid(self.z3)
        self.z4 = np.dot(self.a3, self.W3)
        yHat = self.sigmoid(self.z4)
        return self.a2, self.a3, yHat

    #sigmoid activation function
    def sigmoid(self, z):
        return 1/(1+np.exp(-z))

    #derivative of sigmoid
    def sigmoidPrime(self,z):
        #Gradient of sigmoid
        return np.exp(-z)/((1+np.exp(-z))**2)

    #Error function to minimize
    def costFunction(self, X, y):
        #Compute cost for given X,y, use weights already stored in class.
        self.yHat = self.forward(X)
        temp = y - self.yHat
        J = 0.5*sum(temp**2)
        return J

    #derivative of cost function
    def costFunctionPrime(self, X, y):
        #Compute derivative with respect to W, W2 and W3 for a given X and y:
        self.yHat = self.forward(X)

        delta4 = np.multiply(-(y-self.yHat), self.sigmoidPrime(self.z4))
        dJdW3 = np.dot(self.a3.T, delta4)

        delta3 = np.dot(delta4, self.W3.T)*self.sigmoidPrime(self.z3)
        dJdW2 = np.dot(self.a2.T, delta3)

        delta2 = np.dot(delta3, self.W2.T)*self.sigmoidPrime(self.z2)
        dJdW1 = np.dot(X.T, delta2)

        return dJdW1, dJdW2, dJdW3

    #Helper Functions for interacting with other classes:
    def getParams(self):
        #Get W1 and W2 unrolled into vector:
        params = np.concatenate((self.W1.ravel(), self.W2.ravel(), self.W3.ravel()))
        return params

    #Sets the weights from a single array
    def setParams(self, params):
        #Set W1 and W2 using single paramater vector.
        W1_start = 0
        W1_end = self.hiddenLayer1Size * self.inputLayerSize
        self.W1 = np.reshape(params[W1_start:W1_end], (self.inputLayerSize , self.hiddenLayer1Size))
        W2_end = W1_end + self.hiddenLayer1Size*self.hiddenLayer2Size
        self.W2 = np.reshape(params[W1_end:W2_end], (self.hiddenLayer1Size, self.hiddenLayer2Size))
        W3_end = W2_end + self.hiddenLayer2Size*self.outputLayerSize
        self.W3 = np.reshape(params[W2_end:W3_end], (self.hiddenLayer2Size, self.outputLayerSize))

    #Returns the rate of change of each weight as single array
    def computeGradients(self, X, y):
        dJdW1, dJdW2, dJdW3 = self.costFunctionPrime(X, y)
        return np.concatenate((dJdW1.ravel(), dJdW2.ravel(), dJdW3.ravel()))

    #saves the weights to a file helper function
    def SaveWeights(self):
        SaveWeightsToFile([self.W1, self.W2, self.W3], [self.inputLayerSize, self.hiddenLayer1Size, self.hiddenLayer2Size, self.outputLayerSize])


#Class that trains the given neural network at specific learning Rate (learning rate is how big the steps are when incrementing weights)
class trainer(object):
    def __init__(self, N):
        #Make Local reference to network:
        self.N = N
        self.learningRate = 0.1

    #Returns the cost and the gradients
    def costFunctionWrapper(self, params, X, y):
        self.N.setParams(params)
        cost = self.N.costFunction(X, y)
        grad = self.N.computeGradients(X,y)
        return cost, grad

    #gets the cost and gradients from the input and expected output and then optimizes it by minimizing the error.
    def train(self, X, y):
        #Make an internal variable for the callback function:
        self.X = X
        self.y = y

        #Make empty list to store costs:
        self.J = []

        params0 = self.N.getParams()

        options = {'maxiter': 200, 'disp' : True}

        self.myOptimize(params0, X, y)

    #minimizes error the weights introduce as much as possible
    def myOptimize(self, params0, X, y):
        cost, grad = self.costFunctionWrapper(params0, X, y)
        while (np.any(np.greater(cost, 0.2))):
            params0 = params0 - self.learningRate * grad
            self.N.setParams(params0)
            cost, grad = self.costFunctionWrapper(params0, X, y)

#save the weights to a file so training does not need to be redone every time the program is used
def SaveWeightsToFile(list_weights, layerSizes):
    dir_path = os.path.dirname(os.path.realpath(__file__))
    # print(dir_path)
    fp = open(dir_path + "/shapeWeights" + fileType + ".txt", 'w')
    for item in layerSizes:
        fp.write(str(item) + "\n")
    for weights in list_weights:
        for row in weights:
            for item in row:
                temp = "%.9f" % item
                fp.write(temp + "\n")
    fp.close()

#Loads the weights from the weights file assuming training has already been performed
def LoadWeightFromFile():
    dir_path = os.path.dirname(os.path.realpath(__file__))
    dir_path = dir_path + "/shapeWeights" + fileType + ".txt"
    if (not os.path.isfile(dir_path)):
        return None, None, None, None
    fp = open(dir_path, 'r')
    lines = fp.readlines()
    fp.close()

    k = 0
    layerSize = []
    weights = []
    for line in lines:
        if (k < 4):
            line = line.strip('\n')
            layerSize.append(int(line))
        else:
            weights.append(float(line))
        k = k + 1


    W1 = []
    k = 0
    for i in range(0, layerSize[0]):
        temp = []
        for j in range(0, layerSize[1]):
            temp.append(weights[k])
            k = k + 1
        W1.append(temp)
    W1 = np.asarray(W1)

    W2 = []
    for i in range(0, layerSize[1]):
        temp = []
        for j in range(0, layerSize[2]):
            temp.append(weights[k])
            k = k + 1
        W2.append(temp)
    W2 = np.asarray(W2)

    W3 = []
    for i in range(0, layerSize[2]):
        temp = []
        for j in range(0, layerSize[3]):
            temp.append(weights[k])
            k = k + 1
        W3.append(temp)
    W3 = np.asarray(W3)

    return layerSize, W1, W2, W3

#Writes the output from each layer to a file in fixed_point format
def WriteArrayToFile(array, filename):
    dir_path = os.path.dirname(os.path.realpath(__file__))
    path = dir_path + "/testcases" + fileType + "/" + filename
    fp = open(path, 'w')
    for element in array:
        temp = "%.9f" % element
        fp.write(temp + "\n")
    fp.close()
    convert_fixed_point.ConvertToFixedPoint(path)
    os.remove(path) #removes the files that were generated for standard floating point, leaving just the fixed point

if __name__ == '__main__':
    choice2 = input("Is this 8x8 or 4x4 (1/0)?: ")
    choice = input("Are you training (1/0)?: ")
    size = 8
    if (choice2 ==  0):
        fileType = "4x4"
        size = 4

    start = time.time()
    lineCount = 0
    while lineCount < 540000:   #540000 is the number of lines in the file, will break out of loop if not training


        dir_path = os.path.dirname(os.path.realpath(__file__))
        fp = open(dir_path + "/MNISTdataset" + fileType + ".txt", 'r')
        lines2 = fp.readlines()
        fp.close()

        temp_final = []
        y_final = []
        k = 1


        k = 1
        current_tri = []                #format array correctly after reading in the array line by line
        for line in lines2:
            lineCount = lineCount + 1
            if (k % (size + 1) != 0):
                for item in line.split('\t')[0:size]:
                    current_tri.append(float(item))
            else:
                temp_final.append(np.asarray(current_tri))
                list_temp = []
                for item in line.split('\t')[0:10]:
                    list_temp.append(float(item))
                y_final.append(list_temp)
                current_tri = []

            if (k == (size + 1) * 10):
                break
            k = k + 1



        temp_final = np.asarray(temp_final)
        y_final = np.asarray(y_final)
        arr = np.asarray(temp_final)
        nn = Neural_Network()
        nn.inputLayerSize = size * size

        if (choice == 0):
            temp_final[0] = np.zeros(size * size)
            break

        print("before training:" + "  line count = " + str(lineCount))
        out = nn.forward(arr)
        t = trainer(nn)
        t.train(arr, np.asarray(y_final))
    print("after training:")
    out = nn.forward(arr)
    for i in range(1, 10):
        print("i = " + str(i) + ":")
        print(out[i])

    end = time.time()
    print("time = " + str(end - start))
    nn.SaveWeights()


    #testcase file generation
    k = 0
    for array in nn.x:
        name_temp = "t" + str(k) + "in.txt"
        name_temp2 = "t" + str(k) + "in_fixed.txt"
        WriteArrayToFile(array,name_temp)
        FixedToBinary.ConvertToBinary(os.path.dirname(os.path.realpath(__file__)) + "/testcases" + fileType + "/" + name_temp2)
        k = k + 1
    k = 0
    for array in nn.a2:
        WriteArrayToFile(array,"t" + str(k) + "lay1.txt" )
        k = k + 1
    k = 0
    for array in nn.a3:
        WriteArrayToFile(array,"t" + str(k) + "lay2.txt" )
        k = k + 1
    k = 0
    for array in nn.yHat:
        WriteArrayToFile(array,"t" + str(k) + "layOut.txt" )
        k = k + 1


