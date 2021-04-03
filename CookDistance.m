clear; clc;
data = [
55    80  83  14  19  17
27  55  60  20  15  23
22  80  68  16  12  18
27  55  60  20  18  26
24  75  72  12  12  23
30  62  73  18  18  27
32  30  71  11  18  30
24  75  72  14  13  23
22  62  68  19  14  22
25  75  70  21  12  20
40  90  78  32  9   16
32  52  71  11  16  28
25  85  80  40  25  20
50  40  94  12  20  31
40  90  78  26  11  22
20  50  75  15  16  24
50  84  87  12  19  31
30  62  73  18  19  29
27  55  60  20  15  22
27  55  60  20  16  24
27  72  67  21  14  20
20  50  75  15  15  27];

[n,p] = size(data);
x0 = ones(n,1);

x =data(:, 1:5);
Y =data(:,6);

X = [x0 x];

%1. model regresi
b = (inv(X'*X)) * (X'*Y);

Yhat = X*b;
error = Y-Yhat;
% plot(Y, 'bo')
% hold on
% plot(Yhat, 'r*')

%2. Tabel Analisis Variate (ANOVA)
%Source       | Sum of Squares | Degress of Freedom | Mean of Square
%--------------------------------------------------------------------------------
%Regression | b'*(X'*Y)            | px                           | SSReg/dfReg
%Residual     | ((Y'*Y)-(b'*X'*Y)) | nx-px                       | SSReg/dfRsd
%Total = Y'*Y

SSReg = b'*(X'*Y)
SSRsd = ((Y'*Y)-(b'*X'*Y))
SStotal = Y'*Y

[nx, px] = size(x);
R2 = (SSReg/SStotal)*100
dfReg = px-1
dfRsd = nx-px

MSReg = SSReg/dfReg
MSRes = SSRsd/dfRsd

fhitung = MSReg/MSRes
fTabel = finv(0.95, dfReg, dfRsd)

R2 = (SSReg/SStotal)*100

%3. Hat Matriks
x = horzcat(x0,x)

H = x*inv(x'*x)*x'

%4. ambil nilai hii
for i = 1:n
    for j = 1:n
        if i==j
            hii(i,1)=H(i,j);
        end
    end
end
hii;
%5. Cook Distance
Di = ((error.^2)/(px*(MSRes))).*(hii./(1-hii).^2)

%plot(Di, 'ro')
ei = error.^2
Hasil2 = [ei hii Di]

%jika variabel K>1/3*data, maka outlier adalah > 4/(n-k-1)
%jika tidak seperti itu maka lebih banyak yang menggunakan > 4/n
%4/22 = 0.1818

%menentukan outliers
or=0;
for i=1:n
    if(Di(i)>4/n)
        disp(['observasi ke -', num2str(i), ' outlier'])
        or=or+1;
    else
        xbaru(i-or,:)=data(i,:);
    end
end
%membuat model baru tanpa outlier
%DATA_Bersih = vertcat(xbaru(:,:))
% idx = find(Di(:,1)>4/n) ; % from first column get values greater then 0.5
% data(idx,:) = [] ; % removes the rows idx from data
% DATA_Bersih = data
data(1,:) = [] ; % removes the rows idx from data
data(12,:) = [] ; % removes the rows idx from data
data(15,:) = [] ; % removes the rows idx from data
DATA_Bersih = data
x_Bersih =DATA_Bersih(:, 1:5);
Y_Bersih =DATA_Bersih(:,6);
[n_bersih, pbersih] = size(DATA_Bersih)
x0_bersih = ones(n_bersih,1)
X_Bersih=[x0_bersih x_Bersih]
B_Bersih = (inv(X_Bersih'*X_Bersih))*(X_Bersih'*Y_Bersih)

Yhat_Bersih = X_Bersih*B_Bersih;
error = Y_Bersih-Yhat_Bersih

hasil_model_bersih = [Y_Bersih Yhat_Bersih error]
