import random
import datetime
import time
import sys

codeRange = range(ord('a'),ord('z'))
alphaRange = [chr(x) for x in codeRange]
alphaMax = len(alphaRange)
daysMax = 42003
theDay = datetime.date(1900,1,1)

def genRandomName(nameLength):
    global alphaRange,alphaMax
    length = random.randint(1, nameLength)
    name = ''
    for i in range(length):
        name += alphaRange[random.randint(0,alphaMax-1)]
    return name

def genRandomDay():
    global daysMax,theDay
    mDays = random.randint(0,daysMax)
    mDate = theDay + datetime.timedelta(days=mDays)
    return mDate.isoformat()

def genData():
    return random.randint(0,daysMax)

def genRandomSex():
    return random.randint(0,1)
                                                               
def genDataBase1(fileName,dataCount):
    outp = open(fileName,'w')
    i = 0                                                                     
    while i<dataCount:
	a1=genData()
	a2=genRandomName(14)
	a3=genRandomName(14)
	a4=genData()
	a5=genData()
	a6=genData()
	a7=genData()
	a8=genData()
	a9=genRandomDay()
	a10=genRandomDay()
	a11=genData()
	a12=genData()
	a13=genData()
	a14=genData()
	a15=genRandomDay()
	a16=genRandomDay()
	a17=genRandomDay()
	a18=genRandomDay()
	a19=genData()
	a20=genData()
	a21=random.random()
	a22=genData()
	a23=genRandomDay()
	a24=genRandomDay()
	a25=genRandomDay()
	a26=genRandomName(14)
	a27=genData()
	a28=genRandomDay()
	a29=genRandomDay()
	a30=genData()
	a31=random.random()
	a32=random.random()
	a33=genData()
	a34=random.random()
	a35=random.random()
	a36=random.random()
	a37=genData()
	a38=genData()
	a39=genData()
	a40=random.random()
	a41=genData()
	a42=genData()
	a43=random.random()
	a44=genData()
	a45=genData()
	a46=genRandomDay()
	a47=genData()
	a48=genData()
	a49=genRandomName(14)
	a50=genRandomDay()
	a51=genData()
	a52=genData()
	a53=genRandomDay()
	a54=genData()
	a55=genRandomDay()
	a56=genData()
	a57=genRandomName(14)
	a58=genData()
	a59=genData()
	a60=genRandomName(14)
	a61=genData()
	a62=genRandomName(14)
	a63=genData()
	a64=genData()
	a65=genRandomName(14)
	a66=genRandomName(14)
	a67=genRandomName(14)
	a68=genRandomName(14)
	a69=genRandomName(14)
	a70=genRandomName(14)
	a71=genRandomName(14)
	a72=genRandomDay()
	a73=genRandomName(14)
	a74=genData()
	a75=genRandomDay()
	a76=genRandomName(14)
	a77=genData()
	a78=genData()
	a79=genData()
	a80=genRandomName(14)
	a81=genRandomName(14)
	a82=genRandomName(14)
	a83=genRandomName(14)
	a84=genRandomName(14)
	a85=genRandomName(14)

        mLine="%d %s %s %d %d %d %d %d %s %s %d %d %d %d %s %s %s %s %d %d %.2f %d %s %s %s %s %d %s %s %d %.2f %.2f %d %.2f %.2f %.2f %d %d %d %.2f %d %d %.2f %d %d %s %d %d %s %s %d %d %s %d %s %d %s %d %d %s %d %s %d %d %s %s %s %s %s %s %s %s %s %d %s %s %d %d %d %s %s %s %s %s %s\n"%(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31,a32,a33,a34,a35,a36,a37,a38,a39,a40,a41,a42,a43,a44,a45,a46,a47,a48,a49,a50,a51,a52,a53,a54,a55,a56,a57,a58,a59,a60,a61,a62,a63,a64,a65,a66,a67,a68,a69,a70,a71,a72,a73,a74,a75,a76,a77,a78,a79,a80,a81,a82,a83,a84,a85)
        outp.write(mLine)
        i += 1
    outp.close()
if __name__ == "__main__":
    dataCount = int(sys.argv[1])
    random.seed()
    start = time.time()
    genDataBase1(sys.argv[2],dataCount)
    end = time.time()
    print('use time:%d'%(end-start))
    print('Ok')
