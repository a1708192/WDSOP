function CostPipe=cal_linear(x1,y1,x2,y2,LengthPipe,x)

m= (y2-y1)/(x2-x1);
b= y2-(m*x2);
y=m*x+b;
CostPipe=LengthPipe*y;
end