clear; clc; load('AnoLSS.mat');

rf10 = rf.b10ret;
lsdata = table2array(AnoLSS(:,2:end));
zerod_data = AnoLSS(:,2:end);
zerod_data{:,:}(isnan(zerod_data{:,:})) = 0;
zdata = table2array(zerod_data(:,:));

%% 1.1 Excess Returns

% Mean
means = nanmean(lsdata);

% Std Dev
std_dev = nanstd(lsdata);

% Correlation
corrs = corr(zdata);

% Sharpe Ratio
sharpe = (lsdata - rf10) ./ std_dev;

%% 1.2 Risk-Adjusted Returns
% CAPM
x1 = ones(length(lsdata),1);
capm_reg = table;
for i = 1:11
    X1 = ff3.mkt_rf;
    X = [x1 X1];
    t = table;
    t.i = i;
    [b,bint,r,rint,stats] = regress(lsdata(:,i), X);
    t.a = b(1);         t.bMkt = b(2);
    t.R2 = stats(1);    t.fStat = stats(2);
    t.pv = stats(3);    t.errorVar = stats(4);
    capm_reg = [capm_reg; t];
end

%FF3
x1 = ones(length(lsdata),1);
ff3_reg = table;
for i = 1:11
    X1 = ff3.mkt_rf;    X2 = ff3.smb;    X3 = ff3.hml;
    X = [x1 X1 X2 X3];
    t = table;
    t.i = i;
    [b,bint,r,rint,stats] = regress(lsdata(:,i), X);
    t.a = b(1);         t.bMkt = b(2);
    t.cSmb = b(3);      t.dHml = b(4);
    t.R2 = stats(1);    t.fStat = stats(2);
    t.pv = stats(3);    t.errorVar = stats(4);
    ff3_reg = [ff3_reg; t];
end

% FF5
x1 = ones(length(ff5.mkt_rf),1);
ff5_reg = table;
for i = 1:11
    X1 = ff5.mkt_rf;    X2 = ff5.smb;    X3 = ff5.hml;
    X4 = ff5.rmw;       X5 = ff5.cma;
    X = [x1 X1 X2 X3 X4 X5];
    Y = lsdata(7:end,i);
    t = table;
    t.i = i;
    [b,bint,r,rint,stats] = regress(Y, X);
    t.a = b(1);         t.bMkt = b(2);      t.cSmb = b(3);
    t.dHml = b(4);      t.eRmw = b(5);      t.fCma = b(6);
    t.R2 = stats(1);    t.fStat = stats(2);
    t.pv = stats(3);    t.errorVar = stats(4);
    ff5_reg = [ff5_reg; t];
end