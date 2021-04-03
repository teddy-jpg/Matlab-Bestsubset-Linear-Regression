clc; clear;
DataReg = xlsread('DataBestSubset');
%memisahkan var bebas x dan y
x = DataReg(:,1:5);
Y = DataReg(:,6);
%korealsi X dan Y
korelasiXY = corr(x,Y); %untuk mencari var bebas X yang mempunyai hub terbesar dengan Y tanpa melihat tanda +-

korelasiDataReg = corr(DataReg);

[n,p] = size(x);
x0 = ones(n, 1);
X05 = [x0 x(:,5)];


b05 = (inv(X05'*X05))*(X05'*Y);

Yhat05 = X05*b05;
error = Y-Yhat05;

Hasil = [Y Yhat05 error]

% plot(Y,'ro')
% hold on
% plot(Yhat05,'b*')


%Tabel Analisis Variate (ANOVA)
%Source       | Sum of Squares | Degress of Freedom | Mean of Square
%--------------------------------------------------------------------------------
%Regression | b'*(X'*Y)            | px                           | SSReg/dfReg
%Residual     | ((Y'*Y)-(b'*X'*Y)) | nx-px                       | SSReg/dfRsd
%Total = Y'*Y

SSReg = b05'*(X05'*Y)
SSRsd = ((Y'*Y)-(b05'*X05'*Y))
SStotal = Y'*Y

[nx, px] = size(X05);
R2 = (SSReg/SStotal)*100
dfReg = px-1
dfRsd = nx-px

MSReg = SSReg/dfReg
MSRes = SSRsd/dfRsd

fhitung = MSReg/MSRes
fTabel = finv(0.95, dfReg, dfRsd)

%JIKA semua variabel diikutkan
X = [x0 x]

b = (inv(X'*X))*(X'*Y);

Yhat = X*b;


SSReg_All = b'*(X'*Y) - (mean(Y)^2) %membuang titk potong - (mean(Y)^2)
SSRsd_All = ((Y'*Y)-(b'*X'*Y))
SStotal_All = Y'*Y - (mean(Y)^2)

[na, pa] = size(X);
R2_All = (SSReg_All/SStotal_All)*100
dfReg_All = pa-1
dfRsd_All = na-pa

MSReg_All = SSReg_All/dfReg_All
MSRes_All = SSRsd_All/dfRsd_All

fhitung_All = MSReg_All/MSRes_All
fTabel_All = finv(0.95, dfReg_All, dfRsd_All)


