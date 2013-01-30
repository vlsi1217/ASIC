|test_mux2_zip.cmd

print s=0, expect s_out=0, sb_out=1
l s
s 1
assert s_out  0
assert sb_out 1

print s=1, expect s_out=1, sb_out=0
h s
s 1
assert s_out  1
assert sb_out 0
