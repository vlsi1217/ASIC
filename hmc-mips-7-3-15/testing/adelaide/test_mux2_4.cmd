|test_mux2_4.cmd

print s d0 d1 = 000, expect y=0
l s
l d0[0]
l d1[0]
s 1
assert y[0] 0

print s d0 d1 = 001, expect y=0
l s
l d0[0]
h d1[0]
s 1
assert y[0] 0

print s d0 d1 = 010, expect y=1
l s
h d0[0]
l d1[0]
s 1
assert y[0] 1

print s d0 d1 = 011, expect y=1
l s
h d0[0]
h d1[0]
s 1
assert y[0] 1

print s d0 d1 = 100, expect y=0
h s
l d0[0]
l d1[0]
s 1
assert y[0] 0

print s d0 d1 = 101, expect y=1
h s
l d0[0]
h d1[0]
s 1
assert y[0] 1

print s d0 d1 = 110, expect y=0
h s
h d0[0]
l d1[0]
s 1
assert y[0] 0

print s d0 d1 = 111, expect y=1
h s
h d0[0]
h d1[0]
s 1
assert y[0] 1