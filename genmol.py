import random
import csv

maxlen = 0

f = open("C:\\Users\\maxlm\\Desktop\\alcool.csv", "w", newline='')

# create the csv writer
writer = csv.writer(f)
writer.writerow(["Molecule","Alcool"])

for j in range(100):
    row = ["",False]
    k = random.randint(2,5)

    mol = ""

    for i in range(k):
        mol += "C"

    t = len(mol)
    m = ""
    for i in range(t):
        if t == 4:
            if random.randint(0,1) == 1:
                m = "CH(CH3)3"
                break
        elif t == 5:
            if random.randint(0,1) == 1:
                m = "CH3CH2CH(CH3)2"
                break
        if i == 0 or i == t - 1 :
            m+= "CH3"
        else:
            m+="CH2"
    mol = m
    # groupement C=O
    if random.randint(0,1) == 1:
        pos = -1
        for k in range(len(mol)):
            if mol[k] == 'H':
                if mol[k+1] in ['2','3'] and random.randint(0,1)==1:
                    pos = k
                    
                    break
        if pos != -1 :
            if mol[pos+1] == '2':
                mol = mol[0:pos]+'(O)'+mol[pos+2:len(mol)]
            elif mol[pos+1] == '3':
                mol = mol[0:pos]+'(O)H'+mol[pos+2:len(mol)]
    #groupement C-OH
    if random.randint(0,1) == 1:
        pos = -1
        for k in range(len(mol)):
            if mol[k] == 'H'and random.randint(0,1) == 1:
                pos = k
                break
        if pos != -1  and random.randint(0,5)<=4:
            if len(mol) > pos + 1:
                if mol[pos+1] == '2':
                    mol = mol[0:pos]+'HOH'+mol[pos+2:len(mol)]
                elif mol[pos+1] == '3':
                    mol = mol[0:pos]+'H2OH'+mol[pos+2:len(mol)]
                else:
                    mol = mol[0:pos]+'OH'+mol[pos+1:len(mol)]
            else:
                    mol = mol[0:pos]+'OH'+mol[pos+1:len(mol)]
            row[1] = True
        elif pos != -1:
            if len(mol) > pos + 1:
                if mol[pos+1] == '2':
                    mol = mol[0:pos]+'HOOH'+mol[pos+2:len(mol)]
                elif mol[pos+1] == '3':
                    mol = mol[0:pos]+'H2OOH'+mol[pos+2:len(mol)]
                else:
                    mol = mol[0:pos]+'OOH'+mol[pos+1:len(mol)]
            else:
                mol = mol[0:pos]+'OOH'+mol[pos+1:len(mol)]
    row[0] = mol

    if len(mol) > maxlen:
        maxlen = len(mol)
    # write a row to the csv file
    writer.writerow(row)

# close the file
f.close()

print(maxlen)
