def ConvertToBinary(file):
    read = open(dir_path, 'r')
    write = open(dir_path, 'w')
    lines = read.readlines()

    string = ""
    for line in lines:
        c = '0'
        c.






if __name__ == '__main__':
    file = raw_input("Enter the file name in relative to this directory: ")
    dir_path = os.path.dirname(os.path.realpath(__file__))
    ConvertToBinary(dir_path + "/" + file)