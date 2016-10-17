import math
import numpy as np
from matplotlib import pyplot as plt


# Gets image data from filename
def getImageData():
    with open("train-images-idx3-ubyte", 'rb') as fp:
        magicNum = fp.read(4)
        numSamples = int.from_bytes(fp.read(4), byteorder="big")
        numRows = int.from_bytes(fp.read(4), byteorder="big")
        numCols = int.from_bytes(fp.read(4), byteorder="big")

        data = np.zeros((numSamples, numRows, numCols), dtype=np.uint8)

        for inds in range(0, numSamples):
            for indr in range(0, numRows):
                for indc in range(0, numCols):
                    data[inds, indr, indc] = int.from_bytes(fp.read(1), byteorder="big")

    return scaleData(data)

def showImage(data, num):
    numSamples = np.shape(data)[0]
    picData = data.reshape(numSamples, 8, 8, 2)

    print(picData[num, :,:, 0])

    plt.imshow(picData[num,:,:,0], interpolation="nearest")
    plt.show()
    print("Label: " + str(picData[num,0,0,1]))


def getLabelData():
    with open("train-labels-idx1-ubyte", 'rb') as fp:
        magicNum = fp.read(4)
        numSamples = int.from_bytes(fp.read(4), byteorder="big")

        data = np.zeros((numSamples), dtype=np.uint8)

        for ind in range(0, numSamples):
            data[ind] = int.from_bytes(fp.read(1), byteorder="big")

    return data

def combineData(images, labels):

    numSamples = np.shape(images)[0]

    # shape = numSamples x 64 x 2
    data = np.zeros((numSamples, 8 * 8, 2), dtype=np.uint8)

    data[:,:,0] = images
    data[:,0,1] = labels
    return data


# Resizes each image in dataset to 8x8 using nearest neighbors scaling
def scaleData(data):

    # Get dimensions of data
    (numSamples, numRows, numCols) = np.shape(data)

    # Images are flattened into vectors of lenth 8x8 = 64
    out = np.zeros((numSamples, 8 * 8), dtype=np.uint8)

    # Calculate scaling factor
    scale = (8/numRows, 8/numCols)

    for x in range(0, 8):
        for y in range(0, 8):
            out[:,x*8 + y] = data[:,round(x/scale[0]), round(y/scale[1])]

    return out

def getTrainData():
    images = getImageData()
    labels = getLabelData()

    data = combineData(images, labels)

    return data

# Rectified linear activation function
def reluFloat(x):
    return max(x, 0)

def reluFLoatPrime(x):
    if x >= 0:
        return 1
    return 0


def forward(inputs, weights):

    relu = np.frompyfunc(reluFloat, 1, 1)
    reluPrime = np.frompyfunc(reluFLoatPrime, 1, 1)

    w0 = weights[0]
    w1 = weights[1]
    w2 = weights[2]

    z0 = np.dot(inputs, w0)
    out0 = relu(z0)
    z1 = np.dot(out0, w1)
    out1 = relu(z1)
    z2 = np.dot(out1, w2)
    out2 = relu(z2)
    out = out2;
    return out

def backward(inputs, outputs, weights, labels):
    pass

def trainNet(data, batchSize, numEpochs):

    # ANN Hyperparameters
    # 3 layers:
    #  first: fully connected, 32 nodes
    #  second: fully connected 16 nodes
    #  output: fully connected 10 nodes
    numNodes0 = 32
    numNodes1 = 16
    numNodes2 = 10

    # Initialize synapse weights for three layers
    w0 = 2*np.random.random((64,numNodes0)) - 1
    w1 = 2*np.random.random((numNodes0,numNodes1)) - 1
    w2 = 2*np.random.random((numNodes1,numNodes2)) - 1

    # Number of batches
    numSamples = np.shape(data)[0]
    numBatches = int(numSamples/batchSize)

    # Get numpy ufunc
    relu = np.frompyfunc(reluFloat, 1, 1)
    reluPrime = np.frompyfunc(reluFLoatPrime, 1, 1)

    for epoch in range(numEpochs):
        for batchNum in range(numBatches):
            # Shuffle data
            np.random.shuffle(data)

            # Get batch (first batchSize samples from data)
            batch = data[0:batchSize,:,:]

            # Format label
            labels = np.zeros((batchSize, numNodes2))
            for ind in range(batchSize):
                labels[ind,batch[ind,0,1]] = 1

            # Format inputs
            inputs = batch[:,:,0].reshape(batchSize,64)

            # Forward pass
            # Annoyingly, np.dot is how numpy multiplies arrays as matrices
            z0 = np.dot(inputs, w0)
            out0 = relu(z0)
            z1 = np.dot(out0, w1)
            out1 = relu(z1)
            z2 = np.dot(out1, w2)
            out2 = relu(z2)
            out = out2;

            # Compute error
            errors = labels - out
            error = np.mean(errors, axis=0)

            # Backward pass
            delta2 = -error * reluPrime(z2)
            dJdW2 = np.dot(out1.T, delta2)
            delta1 = np.dot(delta2, w2.T) * reluPrime(z1)
            dJdW1 = np.dot(out0.T, delta1)
            delta0 = np.dot(delta1, w1.T) * reluPrime(z0)
            dJdW0 = np.dot(inputs.T, delta0)

            learningRate = 1;

            w0 -= learningRate*dJdW0;
            w1 -= learningRate*dJdW1;
            w2 -= learningRate*dJdW2;

        print("End of epoch " + str(epoch + 1) + "/" + str(numEpochs))

    costFunc = np.frompyfunc(lambda x: 0.5*x**2, 1, 1)
    cost = np.sum(costFunc(error))

    print("Cost is  " + str(cost))

    return w0, w1, w2

def numericalGradient(weights, inputs, outputs):
    e = 1e-4
    pass

def main():
    # This takes awhile (it loads over 45MB of data)
    trainData = getTrainData()
    print("Training data loaded.")

    numSamples = np.shape(testData)[0]

    # Chosen for convenience
    numEpochs = 1
    batchSize = 10

    # Train network
    weights = trainNet(trainData, batchSize, numEpochs)
    print("Network has been trained.")



if __name__ == "__main__":
    main()
