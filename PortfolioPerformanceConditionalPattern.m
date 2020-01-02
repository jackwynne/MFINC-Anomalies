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
for i = 1:11
    X1 = ff3.mkt_rf;
    X = [X1];
    col = (i*3);
    Y = lsdata(:, col);
    mdl = fitlm(X, Y);
    capm_reg{i} = mdl;
end

%FF3
for i = 1:11
    X1 = ff3.mkt_rf;    X2 = ff3.smb;    X3 = ff3.hml;
    X = [X1 X2 X3];
    col = (i*3);
    Y = lsdata(:, col);
    mdl = fitlm(X, Y);
    ff3_reg{i} = mdl;
end

% FF5
for i = 1:11
    X1 = ff5.mkt_rf;    X2 = ff5.smb;    X3 = ff5.hml;
    X4 = ff5.rmw;       X5 = ff5.cma;
    X = [X1 X2 X3 X4 X5];
    col = (i*3);
    Y = lsdata(7:end, col);
    mdl = fitlm(X, Y);
    ff5_reg{i} = mdl; 
end

% FF6 (FF5 + Momentum)
for i = 1:11
    X1 = ff5.mkt_rf;    X2 = ff5.smb;    X3 = ff5.hml;
    X4 = ff5.rmw;       X5 = ff5.cma;    X6 = fffw.umd(7:end,1);
    X = [X1 X2 X3 X4 X5 X6];
    col = (i*3);
    Y = lsdata(7:end,col);
    mdl = fitlm(X, Y);
    ff6_reg{i} = mdl; 
end

% FF6 + VIX
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
    X = [X1 X2 X3 X4 X5 X6 X7];
    col = (i*3)+1;
    Y = table2array(AnoLSSf(:,col));
    mdl = fitlm(X, Y);
    ff6vix_reg{i} = mdl;   
end