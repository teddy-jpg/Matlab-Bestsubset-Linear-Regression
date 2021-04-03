clc; clear;
DataReg = xlsread('DataBestSubsetCook');
%memisahkan var bebas x dan y
x = DataReg(:,1:4);
Y = DataReg(:,5);

%menghitung korelasi
korelasiXY=corr(x,Y);
korelasiDataReg = corr(DataReg);

[n,p] = size(x);
x0 = ones(n,1);
X04 = [x0 x(:,4)];

b04 = (inv(X04'*X04))*(X04'*Y);

Yhat04 = X04*b04;
error = Y-Yhat04

Hasil = [Y Yhat04 error]

%Tabel Analisis Variate (ANOVA)
%Source       | Sum of Squares | Degress of Freedom | Mean of Square
%--------------------------------------------------------------------------------
%Regression | b'*(X'*Y)            | px                           | SSReg/dfReg
%Residual     | ((Y'*Y)-(b'*X'*Y)) | nx-px                       | SSReg/dfRsd
%Total = Y'*Y

SSReg = b04'*(X04'*Y) -(mean(Y)^2)
SSRsd = ((Y'*Y)-(b04'*X04'*Y))
SStotal = Y'*Y-(mean(Y)^2)

[nx, px] = size(X04);
R2 = (SSReg/SStotal)*100
dfReg = px-1
dfRsd = nx-px

MSReg = SSReg/dfReg
MSRes = SSRsd/dfRsd

fhitung = MSReg/MSRes
fTabel = finv(0.95, dfReg, dfRsd)

