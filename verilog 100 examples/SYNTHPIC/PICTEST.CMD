| The Synthetic PIC
|
| This is just my Command file for Viewlogic's VIEWSIM.  These commands allow
| me to view a nice Viewtrace plot all all the signals I need to monitor.
| This is particular to ViewLogic's simulation environment, and you need to do
| whatever is appropriate to your environment.  This *could* have been done purely
| in VHDL, but I find the ViewTrace tool to be succinct and efficient.
|
|
|
| Define vectors and aliases for signals of interest.
|
vector PC       pictest\piccpu1\PC.[10:0]
vector PCPLUS1  pictest\piccpu1\PCPLUS1.[10:0]
vector INST     pictest\piccpu1\INST.[11:0]
vector W        pictest\piccpu1\W.[7:0]
vector STATUS   pictest\piccpu1\STATUS.[7:0]
vector R10      pictest\piccpu1\regs\R10.[7:0]
vector R11      pictest\piccpu1\regs\R11.[7:0]
vector R12      pictest\piccpu1\regs\R12.[7:0]
vector STACK1   pictest\piccpu1\STACK1.[7:0]
vector STACK2   pictest\piccpu1\STACK2.[7:0]
vector STACKLEVEL    pictest\piccpu1\STACKLEVEL.[1:0]
vector FSEL     pictest\piccpu1\FSEL.[4:0]
vector FWE      pictest\piccpu1\FWE
vector ALUZ     pictest\piccpu1\ALUZ
vector ALUCOUT  pictest\piccpu1\ALUCOUT
vector FIN      pictest\piccpu1\FIN.[4:0]
vector FOUT     pictest\piccpu1\FOUT.[4:0]

vector ALUA     pictest\piccpu1\ALUA.[7:0]
vector ALUB     pictest\piccpu1\ALUB.[7:0]
vector ALUOP    pictest\piccpu1\ALUOP.[3:0]
vector ALUOUT   pictest\piccpu1\ALUOUT.[7:0]

vector STATUS_C  pictest\piccpu1\STATUS.0
vector STATUS_Z  pictest\piccpu1\STATUS.2

vector PortA    pictest\TEST_PortA.[7:0]
vector PortB    pictest\TEST_PortB.[7:0]

| Display a ViewTrace ineractive waveform.
|
wave pictest.wfm    pictest\TEST_Clk +
						  pictest\piccpu1\Q1 pictest\piccpu1\Q2 pictest\piccpu1\Q3 pictest\piccpu1\Q4 +
						  pictest\TEST_MRST +
						  PC PCPLUS1 +
                    STACK1 STACK2 STACKLEVEL +
						  INST W STATUS PortA FSEL FWE FIN FOUT +
						  ALUA ALUB ALUOP ALUOUT ALUZ ALUCOUT +
						  STATUS_Z STATUS_C +
                    PortA PortB +
						  R10 R11 R12
