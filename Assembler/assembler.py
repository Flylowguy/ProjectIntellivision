#this assembler is compliant with the ISA completed on 11/25/2105
# By Will Preachuk, Levi Amen and Cameron Johnson
# This assembler will take a file and then assemble it in two passes into fileName.o
# using the command line command (On CSE)
# python assembler.py fileName.s
#NOTE: Since Python Syntax is indent based It is reccommended that ANY editing be done using IDLE 
#the built in python editor. This assembler is being written in Python 3.4
 
# TODO, will be able to add source files as well (IE other files like for stacking)
import sys
import re
#These are file wide constants/global identifiers
global Rtype = {'add' = '00000',
                'sub' = '00000',
                'and' = '00000',
                'or' = '00000',
                'xor' = '00000',
                'sll' = '00100',
                'cmp' = '00101',
                'jr' = '00110'}
global opx = {'add' = '0000000',
              'sub' = '0000001',
              'and' = '0000011',
              'or' = '0000010',
              'xor' = '0000100'}
global Dtype = {'lw' = '00111',
                'sw' = '01001',
                'addi' = '01000',
                'si' = '01010'}
global Btype = {'b' = '01011',
                'bal' = '01100'}
global Jtype = {'j' = '01101',
                'jal' = '01110',
                'li' = '01111'}
global reg = {}
temp = ''
for i in range(0,31): # this loop creates a list of all the registers (for identification)
    temp = 'r' + str(i)
    reg[temp] = '{0:05b}'.format(i)
global knownSymbols = [Rtype,Dtype,Btype,Jtype]#list containing all known/predefined symbols



#TODO helper method for firt pass
# Creates symbol table
def pass1(fileName):
    symbolTable = {} #a dictionary(IE Key=> value where keys can be anything)
    myfile = open(fileName,'r')
    lineArgs = []
    count = 0
    for line in myfile:
        count++
        lineArgs = re.split('[ ,]',line)# splits a line by a regex
        # if not a recognized sybol make an entry in the SymbolTable
        #this will only find where the actual labels are, not where they are in
        #other insturctions. Only where labels begin.
        inSet = False
        for L in knownSymbols: #goes through each dict of Known symbols
            if(lineArgs[0] in L):# if item in dict
                inSet = True
        if(!inSet):
            symbolTable[lineArgs[0]] = count 
    myfile.close()
    return symbolTable
# TODO helper method for second pass
# takes in symbol table of pass1 and uses it to create the .o file
# IE Fully assembles it.
def pass2(fileName, sybolTable): 
    myfile  = open(fileName, "r")
    nl = len(fileName)
    outName = fileName[:nl-1]+".o" #creates new file for write out.
    outfile = open(outName,"w")
    #todo process the information and create the binary instructions to the out file.
    
    


#TODO call that will asseble the whole file
def assemble():
    for i in range(1,len(sys.argv)-1):# for each given file
        pass2(sys.argv[i], pass1(sys.argv[i])) # assemble that file!
    return 0 # ends the function

#Main function
def main():
    assemble() # assembles all given files given the params below
    return 0 # ends the main
    
