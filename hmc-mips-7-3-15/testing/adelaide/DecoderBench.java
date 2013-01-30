import java.io.*;

public class DecoderBench
{
	public static void main(String[] args) throws Exception
	{
		PrintWriter writer = new PrintWriter(new BufferedWriter(new FileWriter("decoder_bench.cmd")));
		writer.println("stepsize 2ns");
		writer.println("vector a a[5] a[4] a[3] a[2] a[1] a[0]");
		writer.println("vector y y[63] y[62] y[61] y[60] y[59] y[58] y[57] y[56] y[55] y[54] y[53] y[52] y[51] y[50] y[49] y[48] y[47] y[46] y[45] y[44] y[43] y[42] y[41] y[40] y[39] y[38] y[37] y[36] y[35] y[34] y[33] y[32] y[31] y[30] y[29] y[28] y[27] y[26] y[25] y[24] y[23] y[22] y[21] y[20] y[19] y[18] y[17] y[16] y[15] y[14] y[13] y[12] y[11] y[10] y[9] y[8] y[7] y[6] y[5] y[4] y[3] y[2] y[1] y[0]");
		writer.println();
		final int aSize = 6;
		final int ySize = 64;
		StringBuffer a;
		StringBuffer y;
		int tally;
		int phN;
		char ph1;
		for(int i=0;i<ySize;i++)
		{
			a = new StringBuffer();
			y = new StringBuffer();
			tally = i;
			for(int j=0;j<aSize;j++)
			{
				if(tally%2==0)
				{
					a.insert(0,'l');
				}
				else
				{
					a.insert(0,'h');
				}
				tally = (tally-(tally%2))/2;
			}
			for(int j=0;j<ySize-1;j++)
			{
				y.append(0);
			}
			phN = (int) Math.floor(2*Math.random());
			if(phN==1)
			{
				ph1 = 'h';
				y.insert(63-i,1);
			}
			else
			{
				ph1 = 'l';
				y.insert(63-i,0);
			}
			writer.println("print iteration "+i+" ph1 set to "+ph1);
			writer.println("set a "+a);
			writer.println(ph1+" ph1");
			writer.println("s 50");
			writer.println("assert y "+y);
			writer.println();
		}
		writer.close();
	}
}
