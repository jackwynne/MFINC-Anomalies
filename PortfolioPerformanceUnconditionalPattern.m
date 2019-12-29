clear; clc; load('AnoLSS.mat');

rf10 = rf.b10ret;
lsdata = table2array(AnoLSS(:,2:end));
zerod_data = AnoLSS(:,2:end);
zerod_data{:,:}(isnan(zerod_data{:,:})) = 0;
zdata = table2array(zerod_data(:,:));

days = day(vix.Date);
LastDayOfMonthIndex=[diff(days)]<0;
LastDayOfMonthIndex(end) = 1;
vix = vix(LastDayOfMonthIndex == 1,:);
vix.Date = datetime(vix.Date,'Format', 'yyyyMM');

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

% FF6 (FF5 + Momentum)
x1 = ones(length(ff5.mkt_rf),1);
ff6_reg = table;
for i = 1:11
    X1 = ff5.mkt_rf;    X2 = ff5.smb;    X3 = ff5.hml;
    X4 = ff5.rmw;       X5 = ff5.cma;    X6 = fffw.umd(7:end,1);
    X = [x1 X1 X2 X3 X4 X5 X6];
    Y = lsdata(7:end,i);
    t = table;
    t.i = i;
    [b,bint,r,rint,stats] = regress(Y, X);
    t.a = b(1);         t.bMkt = b(2);      t.cSmb = b(3);
    t.dHml = b(4);      t.eRmw = b(5);      t.fCma = b(6);
    t.gUmd = b(7);
    t.R2 = stats(1);    t.fStat = stats(2);
    t.pv = stats(3);    t.errorVar = stats(4);
    ff6_reg = [ff6_reg; t];
end

% FF6 + VIX
x1 = ones(length(ff5.mkt_rf),1);
ff6vix_reg = table;
ff5_filter = (ff5.year >= min(vix.Date)) + (ff5.year == datetime(1986,1,1));
fffw_filter = (fffw.year >= min(vix.Date)) + (fffw.year == datetime(1986,1,1));
AnoLSS_filter = (AnoLSS.YYYYMM >= min(vix.Date)) + (AnoLSS.YYYYMM == datetime(1986,1,1));
ff5f = ff5(ff5_filter == 1, :);
fffwf = fffw(fffw_filter == 1, :);
AnoLSSf = AnoLSS(AnoLSS_filter == 1, :);
x1 = ones(height(vix),1);
for i = 1:11
    X1 = ff5f.mkt_rf;    X2 = ff5f.smb;    X3 = ff5f.hml;
    X4 = ff5f.rmw;       X5 = ff5f.cma;    X6 = fffwf.umd;
    X7 = vix.vxo;
    X = [x1 X1 X2 X3 X4 X5 X6 X7];
    col = (i*3)+1;
    Y = table2array(AnoLSSf(:,col));
    t = table;
    t.i = i;
    [b,bint,r,rint,stats] = regress(Y, X);
    t.a = b(1);         t.bMkt = b(2);      t.cSmb = b(3);
    t.dHml = b(4);      t.eRmw = b(5);      t.fCma = b(6);
    t.gUmd = b(7);      t.fVix = b(8);
    t.R2 = stats(1);    t.fStat = stats(2);
    t.pv = stats(3);    t.errorVar = stats(4);
    ff6vix_reg = [ff6vix_reg; t];
end