|test_byteenlog.cmd

print byteen reading memdone=000, expect validnew=0
l byteen[0]
l byteen[1]
l byteen[2]
l byteen[3]
l reading 
l memdone
s 1
assert validnew 0


print byteen reading memdone=001, expect validnew=0
l byteen[0]
l byteen[1]
h byteen[2]
h byteen[3]
l reading 
h memdone
s 1
assert validnew 0

print byteen reading memdone=010, expect validnew=0
h byteen[0]
h byteen[1]
h byteen[2]
l byteen[3]
h reading 
l memdone
s 1
assert validnew 0

print byteen reading memdone=011, expect validnew=1
h byteen[0]
l byteen[1]
h byteen[2]
l byteen[3]
h reading 
h memdone
s 1
assert validnew 1

print byteen reading memdone=100, expect validnew=0
h byteen[0]
h byteen[1]
h byteen[2]
h byteen[3]
l reading 
l memdone
s 1
assert validnew 0

print byteen reading memdone=101, expect validnew=1
h byteen[0]
h byteen[1]
h byteen[2]
h byteen[3]
l reading 
h memdone
s 1
assert validnew 1

print byteen reading memdone=110, expect validnew=0
h byteen[0]
h byteen[1]
h byteen[2]
h byteen[3]
h reading 
l memdone
s 1
assert validnew 0

print byteen reading memdone=111, expect validnew=1
h byteen[0]
h byteen[1]
h byteen[2]
h byteen[3]
h reading 
h memdone
s 1
assert validnew 1
