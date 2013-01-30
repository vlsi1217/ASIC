| Rob
| 5 Mar 2007

print ***SRAM Bit Test***
print -----------------------------------------
print 1: Data initialised to 0. ie, Q=0.
print 2: Read the data value. Expect bit=0.
print 3: Write a 1 to SRAM when Q = 0. Expect Q=1.
print 4: Read the data value. Expect bit=1.
print 5: Write a 0 to SRAM when Q = 1. Expect Q=0.
print 6: Read the data value. Expect bit=0.
print ------------------------------------------
print .
print .

stepsize 1

print Step 1: Initialise...
print Q->0(initialise), word->0(initially), bit, bit_b both floating
l Q
l word
s 1
print success

print Step2: Read data value...
print word->1, should get bit=1, bit_b=0
|------
|*Here bitlines need to be high and floating
|*Then when word is set high the value of can be read
|*by examining the 'bit' line.
|------
h word
s 1
assert bit 0
assert bit_b 1
| restore word to low
l word
s 1
print success

print Step 3: Write 1 to SRAM...
print bit->1, bit_b->0, word->1
|------
|*Here bit is set to high and floats.
|*bit_b is driven low by the writedriver (do this manually here)
|*Q is also floating.
|*Then when word is set high the value will be established @ Q
|------
h bit
l bit_b
s 0.5
x bit
x Q
s 0.5
h word
s 0.5
assert Q 1
| restore word to low
s 0.5
l word
s 0.5
print success

print Step 4: Read the SRAM value...
print bit->1 and floats, bit_b->1, word->1
|*procedure the same as previous read
|---------------
h bit
h bit_b
s 0.5
x bit
s 0.5
h word
s 0.5
assert bit 1
| restore word to low
s 0.5
l word
s 0.5
print success

print Step 5: Write a 0 to SRAM...
print bit->0, bit_b->1, word->1, expect Q->0
|*Same procedure as previous write.
|--------------
l bit
h bit_b
s 0.5
h word
s 0.5
assert Q 0
assert Qb 1
s 0.5
| restore word to low
s 0.5
l word
s 0.5
print success


print Step 6: Read the data value
print bit->1 and floats, bit_b->1, word->1
h bit
h bit_b
s 0.5
x bit
s 0.5
h word
s 0.5
assert bit 0
| restore word to low
s 0.5
l word
s 0.5
print success
