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
            if(lineArgs[0] in L or lineArgs[0] == 'nop'):# if item in dict
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
    outName = fileName[:nl-2]+'.o' #creates new file for write out.
    outFile = open(outName,'w')
    count = 0
    outLine = ""
    for cline in myfile:
        count += 1
        line = cline.replace('\n','')
        lineArgs = re.split('[ ,]',line)
        if(lineArgs[0] in symbolTable):
            if(lineArgs[1] in Rtype):
                if(lineArgs[1] == 'jr'):
                    #jr al r30
                    outLine = reg[lineArgs[3]] + '00000'+'00000' + opx[lineArgs[1]] + '0'
                elif(lineArgs[0] == 'cmp'):
                    #cmp al r3,r4
                    outLine = reg[lineArgs[3]] + reg[lineArgs[4]] + reg['r0'] + opx[lineArgs[1]]
                    if(lineArgs[1] == 'cmp'): #Sets the s bit
                        outLine += '1'
                    else:
                        outLine += '0'
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
                
                if(lineArgs[1] == 'lw' or lineArgs[1] == 'sw'  ):
                    process = re.split('[()]',lineArgs[4][:len(lineArgs[4])-1])
                    outLine = reg[process[1]] + reg[lineArgs[3]] + binaryChange(int(process[0]),12)
                    outLine += '0'
                    outLine += Cond[lineArgs[2]] + Dtype[lineArgs[1]]
                elif(lineArgs[1] == 'addi'):
                    #label addi al r3,r2,100
                    outLine = reg[lineArgs[4]] + reg[lineArgs[3]] + binaryChange(int(lineArgs[5]),12)
                    outLine += '0'
                    outLine += Cond[lineArgs[2]] + Dtype[lineArgs[1]]
    
            elif(lineArgs[1] in Btype):
                #symb: b al LABEL or Number
                #symb: bal al Label or Number
                if(lineArgs[3] in symbolTable):
                    jumper = symbolTable[lineArgs[3]]
                    jumper = jumper - count -1
                    outLine = binaryChange(jumper,23)
                    outLine += Cond[lineArgs[2]] + Btype[lineArgs[1]]
                else:
                    outLine = binaryChange(int(lineArgs[3]),23)
                    outLine += Cond[lineArgs[2]] + Btype[lineArgs[1]]
            elif(lineArgs[1] in Jtype):
                if(lineArgs[2] in symbolTable):
                    jumper = symbolTable[lineArgs[2]]
                    jumper = jumper - count -1
                    outLine = binaryChange(jumper,27)
                    outLine += Jtype[lineArgs[1]]
                else:
                    outLine = binaryChange(lineArgs[2],27)
                    outLine += Jtype[lineArgs[1]]
            elif(lineArgs[1] == 'nop'):
                outLine = '0' * 32

            else: # If not any of these, make it a no op
                outLine = '0' * 32
            
        else:
            #note conditionals will be the last thing on the assembler to be read
            # ex: add al r3,r0,r2  for the ease of reading
            # for the normal execution have two spaces twixt the instruction and the registers
            #ex: add  r3,r0,r2 for a normal command (always)            
            if(lineArgs[0] in Rtype):
                if(lineArgs[0] == 'jr'):
                    #jr al r30
                    outLine = reg[lineArgs[2]] + '00000'+'00000' + opx[lineArgs[0]] + '0'
                elif(lineArgs[0] == 'cmp'):
                    #cmp al r3,r4
                    outLine = reg[lineArgs[2]] + reg[lineArgs[3]] + reg['r0'] + opx[lineArgs[0]]
                    if(lineArgs[0] == 'cmp'): #Sets the s bit
                        outLine += '1'
                    else:
                        outLine += '0'
                    
                else:
                    #ex: add al r3,r0,r2 for a normal command (always)
                    outLine = reg[lineArgs[3]] + reg[lineArgs[4]] + reg[lineArgs[2]] + opx[lineArgs[0]]
                    if(lineArgs[0] == 'cmp'): #Sets the s bit
                        outLine += '1'
                    else:
                        outLine += '0'

                outLine += Cond[lineArgs[1]] + Rtype[lineArgs[0]]
            elif(lineArgs[0] in Dtype):
                #for lw and sw there MUST be a 0 in front
                #lw al r3,0(r4)
                
                if(lineArgs[0] == 'lw' or lineArgs[0] == 'sw'  ):
                    process = re.split('[()]',lineArgs[3][:len(lineArgs[3])-1])
                    outLine = reg[process[1]] + reg[lineArgs[2]] + binaryChange(int(process[0]),12)
                    outLine += '0'
                    outLine += Cond[lineArgs[1]] + Dtype[lineArgs[0]]
                elif(lineArgs[0] == 'addi'):
                    #addi al r3,r2,100
                    outLine = reg[lineArgs[3]] + reg[lineArgs[2]] + binaryChange(int(lineArgs[4]),12)
                    outLine += '0'
                    outLine += Cond[lineArgs[1]] + Dtype[lineArgs[0]]
    
                
            elif(lineArgs[0] in Btype):
                #b al LABEL or Number
                #bal al Label or Number
                if(lineArgs[2] in symbolTable):
                    jumper = symbolTable[lineArgs[2]]
                    jumper = jumper - count -1
                    outLine = binaryChange(jumper,23)
                    outLine += Cond[lineArgs[1]] + Btype[lineArgs[0]]
                else:
                    outLine = binaryChange(lineArgs[2],23)
                    outLine += Cond[lineArgs[1]] + Btype[lineArgs[0]]
            elif(lineArgs[0] in Jtype):
                if(lineArgs[1] in symbolTable):
                    jumper = symbolTable[lineArgs[1]]
                    jumper = jumper - count -1
                    outLine = binaryChange(jumper,27)
                    outLine += Jtype[lineArgs[0]]
                else:
                    outLine = binaryChange(lineArgs[1],27)
                    outLine += Jtype[lineArgs[0]]
            elif(lineArgs[0] == 'nop'):
                outLine = '0' * 32
            else: # If the command is blank or not recognized then introduce a NO OP
                outLine = '0' * 32
        print(outLine)
        outPrinter = str(hex(int(outLine,2)))[2:]
        if(len(outPrinter) <8):
            outPrinter = '0'*(8-len(outPrinter)) + outPrinter
        print(outPrinter)
        outFile.write(outPrinter+'\n')#converts the binary to int, the int to it's hex rep then removes the beginning 0x
    print(fileName +' is done assembling\n')
    myfile.close()
    outFile.close()

    
def binaryChange(number,leng):
    number = int(number)
    ret = ''
    nuStr = ''
    if(number >=0):
        nuStr = '{0:0'+str(leng)+'b}'
        ret = nuStr.format(number)
        return ret
    else:
        number = -1*number
        nuStr = str(bin(number))
        nuStr = nuStr[2:]
        nuStr = '0' *(leng-len(nuStr)) + nuStr
        negStr = ''
        for i in nuStr:
            if(i == '0'):
                negStr += '1'
            else:
                negStr += '0'
        negStr = bin(int(negStr,2)+1)
        return str(negStr)[2:]
    
        
        
    
#TODO call that will asseble the whole file
def assemble(fileName):
    pass2(fileName,pass1(fileName)) # assemble that file!
    return # ends the function

