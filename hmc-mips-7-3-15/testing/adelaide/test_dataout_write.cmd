|test_dataout_write.cmd

print rwb_b data=00, expect memdata=x
l rwb_b
l data[0]
s 2
assert memdata[0] x

print rwb_b data=01, expect memdata=x
l rwb_b
h data[0]
s 2
assert memdata[0] x

print rwb_b data=10, expect memdata=0
h rwb_b
l data[0]
s 2
assert memdata[0] 0

print rwb_b data=11, expect memdata=1
h rwb_b
h data[0]
s 2
assert memdata[0] 1
