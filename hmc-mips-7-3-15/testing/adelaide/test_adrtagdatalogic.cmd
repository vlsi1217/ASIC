|test_adrtagdatalogic.cmd

print tagdata[19] adr[26]=00, expect temp1=1
l tagdata[19]
l adr[26]
s 2
assert temp1 1

print tagdata[19] adr[26]=01, expect temp1=0
l tagdata[19]
h adr[26]
s 2
assert temp1 0

print tagdata[19] adr[26]=10, expect temp1=0
h tagdata[19]
l adr[26]
s 2
assert temp1 0

print tagdata[19] adr[26]=11, expect temp1=1
h tagdata[19]
h adr[26]
s 2
assert temp1 1 

print temp1 valid=00, expect incache=0
l temp1
l valid
s 2
assert incache 0

print temp1 valid=01, expect incache=0
l temp1
h valid
s 2
assert incache 0

print temp1 valid=10, expect incache=0
h temp1
l valid
s 2
assert incache 0

print temp1 valid=11, expect incache=1
h temp1
h valid
s 2
assert incache 1

print adr[29] adr[27]=00, expect bypass=0
l adr[29]
l adr[27]
s 2 
assert bypass 0

print adr[29] adr[27]=01, expect bypass=0
l adr[29]
h adr[27]
s 2 
assert bypass 0

print adr[29] adr[27]=10, expect bypass=0
h adr[29]
l adr[27]
s 2 
assert bypass 1

print adr[29] adr[27]=11, expect bypass=1
h adr[29]
h adr[27]
s 2 
assert bypass 1


print incache rwb bypass_b=000, expect temp2=0
l incache
l rwb
l bypass_b
s 2
assert temp2 0

print incache rwb bypass_b=001, expect temp2=0 
l incache
l rwb
h bypass_b
s 2
assert temp2 0

print incache rwb bypass_b=010, expect temp2=0 
l incache
h rwb
l bypass_b
s 2
assert temp2 0
print incache rwb bypass_b=011, expect temp2=0 
l incache
h rwb
h bypass_b
s 2
assert temp2 0
print incache rwb bypass_b=100, expect temp2=0 
h incache
l rwb
l bypass_b
s 2
assert temp2 0

print incache rwb bypass_b=101, expect temp2=0 
h incache
l rwb
h bypass_b
s 2
assert temp2 0

print incache rwb bypass_b=110, expect temp2=0 
h incache
h rwb
l bypass_b
s 2
assert temp2 0

print incache rwb bypass_b=111, expect temp2=1 
h incache
h rwb
h bypass_b
s 2
assert temp2 1

print waiting memdone=00, expect temp3=0
l waiting
l memdone
s 2
assert temp3 0

print waiting memdone=01, expect temp3=0
l waiting
h memdone
s 2
assert temp3 0

print waiting memdone=10, expect temp3=0
h waiting
l memdone
s 2
assert temp3 0

print waiting memdone=11, expect temp3=1
h waiting
h memdone
s 2
assert temp3 1

print en_b reset temp2 temp3=0000, expect done=0
l en_b
l reset
l temp2
l temp3
s 2
assert done 0

print en_b reset temp2 temp3=0001, expect done=1
l en_b
l reset
l temp2
h temp3
s 2
assert done 1

print en_b reset temp2 temp3=0010, expect done=1
l en_b
l reset
h temp2
l temp3
s 2
assert done 1

print en_b reset temp2 temp3=0011, expect done=1
l en_b
l reset
h temp2
h temp3
s 2
assert done 1

print en_b reset temp2 temp3=0100, expect done=1
l en_b
h reset
l temp2
l temp3
s 2
assert done 1

print en_b reset temp2 temp3=0101, expect done=1
l en_b
h reset
l temp2
h temp3
s 2
assert done 1

print en_b reset temp2 temp3=0110, expect done=1
l en_b
h reset
h temp2
l temp3
s 2
assert done 1

print en_b reset temp2 temp3=0111, expect done=1
l en_b
h reset
h temp2
h temp3
s 2
assert done 1

print en_b reset temp2 temp3=1000, expect done=1
h en_b
l reset
l temp2
l temp3
s 2
assert done 1

print en_b reset temp2 temp3=1001, expect done=1
h en_b
l reset
l temp2
h temp3
s 2
assert done 1

print en_b reset temp2 temp3=1010, expect done=1
h en_b
l reset
h temp2
l temp3
s 2
assert done 1

print en_b reset temp2 temp3=1011, expect done=1
h en_b
l reset
h temp2
h temp3
s 2
assert done 1

print en_b reset temp2 temp3=1100, expect done=1
h en_b
h reset
l temp2
l temp3
s 2
assert done 1
 
print en_b reset temp2 temp3=1101, expect done=1
h en_b
h reset
l temp2
h temp3
s 2
assert done 1

print en_b reset temp2 temp3=1110, expect done=1
h en_b
h reset
h temp2
l temp3
s 2
assert done 1

print en_b reset temp2 temp3=1111, expect done=1
h en_b
h reset
h temp2
h temp3
s 2
assert done 1




















