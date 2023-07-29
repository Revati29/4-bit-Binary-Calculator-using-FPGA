module calci(a,b,op,reset,mode,neg,control,display,clk,bcd1,bcd2,bcd3);
input [3:0]mode;
input reset,clk;
output [7:0] op;
reg [7:0] op;
output neg;
reg neg;
input [3:0]a;
input [3:0]b;
output [7:0]display;
reg [19:0]temp;
reg [7:0]display;
output [3:0]bcd1,bcd2,bcd3;
reg [3:0]bcd1,bcd2,bcd3;
output [3:0] control;
reg [3:0] control;
integer temp1,temp2;
reg clkdiv,clkms,flag;
integer i;
initial 
begin
temp1=0;
temp2=0;
bcd1 = 4'b0000;
bcd2 = 4'b0000;
bcd3 = 4'b0000;
clkdiv=1'b0;
clkms=1'b0;
flag=2'b00;
end
always@(posedge clk)
begin
temp1=temp1+1;
temp2=temp2+1;
if (temp1==2000000)
begin
clkdiv=~clkdiv;
temp1=0;
end
if(temp2==2000)
begin
clkms=~clkms;
temp2=0;
end
end
always@(posedge clkdiv)
begin
op = 8'b00000000;
if(mode == 4'b0001)
begin
op = a+b;
neg = 0;
end
if(mode == 4'b0010)
begin
if(b > a)
begin 
op = b-a;
neg = 1;
end
else
begin
op = a-b;
neg = 0;
end
end
if(mode == 4'b0100)
begin
op = a*b;
neg = 0;
end
if(mode == 4'b1000)
begin
op = a/b;
neg = 0;
end
 temp[7:0]=op;
temp[19:8]=12'b000000000000;
for (i=0; i<8; i=i+1) 
begin
 if (temp[11:8] >= 5)
 temp[11:8] = temp[11:8] + 3;
 if (temp[15:12] >= 5)
 temp[15:12] = temp[15:12] + 3;
if (temp[19:16] >= 5)
 temp[19:16] = temp[19:16] + 3;
 temp = temp << 1;
end
bcd3<=temp[19:16];
bcd2<=temp[15:12];
bcd1<=temp[11:8];
end
always@(posedge clkms)
begin
if (flag==2'b00)
begin
control=4'b0111;
case(bcd1)
4'b0000:display=8'b11111100;
4'b0001:display=8'b01100000;
4'b0010:display=8'b11011010;
4'b0011:display=8'b11110010;
4'b0100:display=8'b01100110;
4'b0101:display=8'b10110110;
4'b0110:display=8'b10111110;
4'b0111:display=8'b11100000;
4'b1000:display=8'b11111110;
4'b1001:display=8'b11110110;
endcase
flag=2'b01;
end
else if (flag==2'b01)
begin
control=4'b1011;
case(bcd2)
4'b0000:display=8'b11111100;
4'b0001:display=8'b01100000;
4'b0010:display=8'b11011010;
4'b0011:display=8'b11110010;
4'b0100:display=8'b01100110;
4'b0101:display=8'b10110110;
4'b0110:display=8'b10111110;
4'b0111:display=8'b11100000;
4'b1000:display=8'b11111110;
4'b1001:display=8'b11110110;
endcase
flag=2'b10;
end
else
begin
control=4'b1101;
case(bcd3)
4'b0000:display=8'b11111100;
4'b0001:display=8'b01100000;
4'b0010:display=8'b11011010;
4'b0011:display=8'b11110010;
4'b0100:display=8'b01100110;
4'b0101:display=8'b10110110;
4'b0110:display=8'b10111110;
4'b0111:display=8'b11100000;
4'b1000:display=8'b11111110;
4'b1001:display=8'b11110110;
endcase
flag=2'b00;
end
end
endmodule
