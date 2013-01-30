|test_mux2_1x_32.cmd

print s sbb sb d0 d1 = 00100, expect y=0
l s
l sbb
h sb
l d0[0]
l d1[0]
s 1
assert y[0] 0

print s sbb sb d0 d1 = 00101, expect y=0
l s
l sbb
h sb
l d0[0]
h d1[0]
s 1
assert y[0] 0

print s sbb sb d0 d1 = 00110, expect y=1
l s
l sbb
h sb
h d0[0]
l d1[0]
s 1
assert y[0] 1

print s sbb sb d0 d1 = 00111, expect y=1
l s
l sbb
h sb
h d0[0]
h d1[0]
s 1
assert y[0] 1

print s sbb sb d0 d1 = 11000, expect y=0
h s
h sbb
l sb
l d0[0]
l d1[0]
s 1
assert y[0] 0

print s sbb sb d0 d1 = 11001, expect y=1
h s
h sbb
l sb
l d0[0]
h d1[0]
s 1
assert y[0] 1

print s sbb sb d0 d1 = 11010, expect y=0
h s
h sbb
l sb
h d0[0]
l d1[0]
s 1
assert y[0] 0

print s sbb sb d0 d1 = 11011, expect y=1
h s
h sbb
l sb
h d0[0]
h d1[0]
s 1
assert y[0] 1