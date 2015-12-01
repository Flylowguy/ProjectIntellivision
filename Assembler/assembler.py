#this assembler is compliant with the ISA completed on 11/25/2105
# By Will Preachuk, Levi Amen and Cameron Johnson
# This assembler will take a file and then assemble it in two passes into fileName.o
# using the command line command (On CSE)
# python assembler.py fileName.s
#NOTE: Since Python Syntax is indent based It is reccommended that ANY editing be done using IDLE 
#the built in python editor. This assembler is being written in Python 3.4

import sys
import re
#These are file wide constants/global identifiers
Rtype = {'add' : '00000',
         'sub' : '00000',
         'and' : '00000',
         'or' : '00000',
         'xor' : '00000',
         'sll' : '00100',
         'cmp' : '00101',
         'jr' : '00110'}
opx = {'add' : '0000000',
              'sub' : '0000001',
              'and' : '0000011',
              'or' : '0000010',
              'xor' : '0000100',
              'sll' : '0000000',
                'cmp' : '0000000',
                'jr' : '0000000'}
Dtype = {'lw' : '00111',
                'sw' : '01001',
                'addi' : '01000',
                'si' : '01010'}
Btype = {'b' : '01011',
                'bal' : '01100'}
Jtype = {'j' : '01101',
                'jal' : '01110',
                'li' : '01111'}
Cond = { '' : '0000',
                'al' :'0000',
                'nv' :'0001',
                'eq' :'0010',
                'ne' :'0011',
                'vs' :'0100',
                'vc' :'0101',
                'mi' :'0110',
                'pl' :'0111',
                'cs' :'1000',
                'cc' :'1001',
                'hi' :'1010',
                'ls' :'1011',
                'gt' :'1100',
                'lt' :'1101',
                'ge' :'1110',
                'le' :'1111'
                }
reg = {}
temp = ''
for i in range(0,31): # this loop creates a list of all the registers (for identification)
    temp = 'r' + str(i)
    reg[temp] = '{0:05b}'.format(i)
    temp = ''
knownSymbols = [Rtype,Dtype,Btype,Jtype]#list containing all known/predefined symbols



#TODO helper method for firt pass
# Creates symbol table
def pass1(fileName):
    symbolTable = {} #a dictionary(IE Key=> value where keys can be anything)
    myfile = open(fileName,'r')
    lineArgs = []
    count = 0
    for line in myfile:
        count +=1
        lineArgs = re.split('[ ,]',line)# splits a line by a regex
        # if not a recognized sybol make an entry in the SymbolTable
        #this will only find where the actual labels are, not where they are in
        #other insturctions. Only where labels begin.
        inSet = False
        for L in knownSymbols: #goes through each dict of Known symbols
            if(lineArgs[0] in L):# if item in dict
                inSet = True
        if( not inSet):
            symbolTable[lineArgs[0]] = count 
    myfile.close()
    return symbolTable
# TODO helper method for second pass
# takes in symbol table of pass1 and uses it to create the .o file
# IE Fully assembles it.
def pass2(fileName, symbolTable): 
    myfile  = open(fileName, 'r')
    nl = len(fileName)
    outName = fileName[:nl-1]+'.o' #creates new file for write out.
    outfile = open(outName,'w')
    count = 0
    outLine = ""
    for line in myfile:
        count += 1
        lineArgs = re.split('[ ,]',line);
        if(lineArgs[0] in symbolTable):
            if(lineArgs[1] in Rtype):
                if(lineArgs[1] == 'jr'):
                    #jr al r30
                    outLine = reg[lineArgs[3]] + '00000'+'00000' + opx[lineArgs[1]] + '0'
                else:
                    outLine = reg[lineArgs[4]] + reg[lineArgs[5]] + reg[lineArgs[3]] + opx[lineArgs[1]]
                    if(lineArgs[1] == 'cmp'): #Sets the s bit
                        outLine += '1'
                    else:
                        outLine += '0'
                outLine += Cond[lineArgs[2]] + Rtype[lineArgs[1]]
            elif(lineArgs[1] in Dtype):
                #for lw and sw there MUST be a 0 in front
                #label lw al r3,0(r4)
                
                if(Dtype[lineArgs[1]] == 'lw' or Dtype[lineArgs[1]] == 'sw'  ):
                    process = re.split('[(]',lineArgs[4][:len(lineArgs[4]-1)])
                    outLine = reg[process[1]] + reg(lineArgs[3]) + '{0:012b}'.format(process[0])
                    outLine += '0'
                    outLine += Cond[lineArgs[2]] + Dtype[lineArgs[1]]
                elif(Dtype[lineArgs[1]] == 'addi'):
                    #label addi al r3,r2,100
                    outLine = reg[lineArgs[4]] + reg[lineArgs[3]] + '{0:012b}'.format(lineArgs[5])
                    outLine += '0'
                    outLine += Cond[lineArgs[2]] + Dtype[lineArgs[1]]
    
                # Are we even doing SI?
            else: # If not any of these, make it a no op
                outLine = '0' * 32
            
        else:
            #npote conditionals will be the last thing on the assembler to be read
            # ex: add al r3,r0,r2  for the ease of reading
            # for the normal execution have two spaces twixt the instruction and the registers
            #ex: add  r3,r0,r2 for a normal command (always)            
            if(lineArgs[0] in Rtype):
                if(lineArgs[0] == 'jr'):
                    #jr al r30
                    outLine = reg[lineArgs[2]] + '00000'+'00000' + opx[lineArgs[0]] + '0' 
                    
                else:
                    outLine = reg[lineArgs[3]] + reg[lineArgs[4]] + reg[lineArgs[2]] + opx[lineArgs[0]]
                    if(lineArgs[0] == 'cmp'): #Sets the s bit
                        outLine += '1'
                    else:
                        outLine += '0'

                outLine += Cond[lineArgs[1]] + Rtype[lineArgs[0]]
            elif(lineArgs[0] in Dtype):
                #for lw and sw there MUST be a 0 in front
                #lw al r3,0(r4)
                
                if(Dtype[lineArgs[0]] == 'lw' or Dtype[lineArgs[0]] == 'sw'  ):
                    process = re.split('[(]',lineArgs[3][:len(lineArgs[3]-1)])
                    outLine = reg[process[1]] + reg(lineArgs[2]) + '{0:012b}'.format(process[0])
                    outLine += '0'
                    outLine += Cond[lineArgs[1]] + Dtype[lineArgs[0]]
                elif(Dtype[lineArgs[0]] == 'addi'):
                    #addi al r3,r2,100
                    outLine = reg[lineArgs[3]] + reg[lineArgs[2]] + '{0:012b}'.format(lineArgs[4])
                    outLine += '0'
                    outLine += Cond[lineArgs[1]] + Dtype[lineArgs[0]]
    
                # Are we even doing SI?
            elif(lineArgs[0] in Btype):
                #b al LABEL or Number
                #bal al Label or Number
                if(lineArgs[2] in symbolTable):
                    outLine = '{0:023b}'.format(symbolTable[lineArgs[2]])
            #elif(lineArgs[0] in Jtype): TODO J types
            else: # If the command is blank or not recognized then introduce a NO OP
                outLine = '0' * 32

        outfile.write(str(hex(int(outLine,2)))[2:]+'\n')#converts the binary to int, the int to it's hex rep then removes the beginning 0x
        
        
    
    


#TODO call that will asseble the whole file
def assemble():
    for i in range(1,len(sys.argv)-1):# for each given file
        pass2(sys.argv[i], pass1(sys.argv[i])) # assemble that file!
    return 0 # ends the function

#Main function
def main():
    assemble() # assembles all given files given the params below
    return 0 # ends the main
    
