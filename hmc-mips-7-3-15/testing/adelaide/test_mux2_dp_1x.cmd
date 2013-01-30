|test_mux2_dp_1x.cmd

print s d0 d1 = 000, expect y=0
l s
h sb
l d0
l d1
s 1
assert y 0

print s d0 d1 = 001, expect y=0
l s
h sb
l d0
h d1
s 1
assert y 0

print s d0 d1 = 010, expect y=1
l s
h sb
h d0
l d1
s 1
assert y 1

print s d0 d1 = 011, expect y=1
l s
h sb
h d0
h d1
s 1
assert y 1

print s d0 d1 = 100, expect y=0
h s
l sb
l d0
l d1
s 1
assert y 0

print s d0 d1 = 101, expect y=1
h s
l sb
l d0
h d1
s 1
assert y 1

print s d0 d1 = 110, expect y=0
h s
l sb
h d0
l d1
s 1
assert y 0

print s d0 d1 = 111, expect y=1
h s
l sb
h d0
h d1
s 1
assert y 1