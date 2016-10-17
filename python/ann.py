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
    plt.imshow(data[num,:,:,0], interpolation="nearest")
    plt.show()
    print("Label: " + str(data[num,0,0,1], "utf-8"))


def getLabelData():
    with open("train-labels-idx1-ubyte", 'rb') as fp:
        magicNum = fp.read(4)
        numSamples = int.from_bytes(fp.read(4), byteorder="big")

        data = np.zeros((numSamples), dtype=np.uint8)

        for ind in range(0, numSamples):
            data[ind] = int.from_bytes(fp.read(1), byteorder="big")

    return data

def combineData(images, labels):
    #images = getImagedata()
    #labels = getLabeldata()

    numSamples = np.shape(images)[0]

    data = np.zeros((numSamples, 8, 8, 2), dtype=np.uint8)

    data[:,:,:,0] = images
    data[:,0,0,1] = labels
    return data


# Resizes each image in dataset to 8x8 using nearest neighbors scaling
def scaleData(data):

    # Get dimensions of data
    (numSamples, numRows, numCols) = np.shape(data)

    # Initialize output
    out = np.zeros((numSamples, 8, 8), dtype=np.uint8)

    # Calculate scaling factor
    scale = (8/numRows, 8/numCols)

    for x in range(0, 8):
        for y in range(0, 8):
            out[:,x,y] = data[:,round(x/scale[0]), round(y/scale[1])]

    return out

def trainNet(data,):
    pass

def main():

    testImages = getImageData()
    testLabels = getLabelData()

    testData = combineData(testImages, testLabels)

    numSamples = np.shape(testData)[0]

    # Chosen for convenience
    numEpochs = 1
    batchSize = 10
    numBatches = numSamples / batchSize

    # Train each epoch
    for epoch in range(numEpochs):






        print("End of epoch " + str(epoch + 1) + "/" + str(numEpochs))



if __name__ == "__main__":
    main()
