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
    X1 = ff3.mkt;
    X = [x1 X1];
    t = table;
    t.i = i;
    [b,bint,r,rint,stats] = regress(lsdata(:,i), X);
    t.a = b(1);    t.bMkt = b(2);
    t.R2 = stats(1);    t.fStat = stats(2);
    t.pv = stats(3);    t.errorVar = stats(4);
    capm_reg = [capm_reg; t];
end

%FF3