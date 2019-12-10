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
regress(