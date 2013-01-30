|test_dataout.cmd

print waiting cacheline memdata=000, expect readdata=0
l waiting 
l cacheline[0]
l memdata[0]
s 2
assert readdata[0] 0

print waiting cacheline memdata=001, expect readdata=0
l waiting 
l cacheline[0]
h memdata[0]
s 2
assert readdata[0] 0

print waiting cacheline memdata=010, expect readdata=1
l waiting 
h cacheline[0]
l memdata[0]
s 2
assert readdata[0] 1

print waiting cacheline memdata=011, expect readdata=1
l waiting 
h cacheline[0]
h memdata[0]
s 2
assert readdata[0] 1

print waiting cacheline memdata=100, expect readdata=0
h waiting 
l cacheline[0]
l memdata[0]
s 2
assert readdata[0] 0

print waiting cacheline memdata=101, expect readdata=1
h waiting 
l cacheline[0]
h memdata[0]
s 2
assert readdata[0] 1

print waiting cacheline memdata=110, expect readdata=0
h waiting 
h cacheline[0]
l memdata[0]
s 2
assert readdata[0] 0

print waiting cacheline memdata=111, expect readdata=1
h waiting 
h cacheline[0]
h memdata[0]
s 2
assert readdata[0] 1

print rwb readdata=00, expect data=x
l rwb
l readdata[0]
s 2
assert data[0] x

print rwb readdata=01, expect data=x
l rwb
h readdata[0]
s 2
assert data[0] x

print rwb readdata=10, expect data=0
h rwb
l readdata[0]
s 2
assert data[0] 0

print rwb readdata=11, expect data=1
h rwb
h readdata[0]
s 2
assert data[0] 1





