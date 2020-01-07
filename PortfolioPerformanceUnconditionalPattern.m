clear; clc; load('AnoLSS.mat');

days = day(vix.Date);
LastDayOfMonthIndex=[diff(days)]<0;
LastDayOfMonthIndex(end) = 1;
vix = vix(LastDayOfMonthIndex == 1,:);
vix.Date = datetime(vix.Date,'Format', 'yyyyMM');

filter = ones(height(vix),1);
AnoLSS_filter = (AnoLSS.YYYYMM >= min(vix.Date)) + (AnoLSS.YYYYMM == datetime(1986,1,1));
AnoLSSy = AnoLSS(AnoLSS_filter == 1, :);
Anof = AnoLSSy(filter == 1, :);

zerod_data = Anof(:,2:end);
zerod_data{:,:}(isnan(zerod_data{:,:})) = 0;
zdata = table2array(zerod_data(:,:));

rf_filter = (rf.year >= min(vix.Date)) + (rf.year == datetime(1986,1,1));
rfy = rf(rf_filter == 1, :);
rff = rfy(filter == 1, :);

%% 1.1 Excess Returns
lss = [];
long = [];
short = [];
for i = 1:11
    col = (i*3)+1;  col1 = (i*3)-1;    col2 = (i*3); 
    lss = [lss, Anof{:,col}];
    long = [long, Anof{:,col1}];
    short = [short, Anof{:,col2}];
end

% Mean
lms_means = nanmean(lss);
long_means = nanmean(long);
short_means = nanmean(short);

% Std Dev
lms_stdev = nanstd(lss);
long_stdev = nanstd(long);
short_stdev = nanstd(short);

% Correlation
corrs = corr(lss);

% Sharpe Ratio
sharpe = (lss - rff.b10ret) ./ lms_stdev;
avg_sharpe = nanmean(sharpe);

%% 1.2 Risk-Adjusted Returns
ff3_filter = (ff3.year >= min(vix.Date)) + (ff3.year == datetime(1986,1,1));
ff3y = ff3(ff3_filter == 1, :);
ff3f = ff3y(filter == 1, :);
% CAPM
for i = 1:11
    X1 = ff3f.mkt_rf;
    X = [X1];
    col = (i*3)+1;
    Y = table2array(Anof(:,col));
    mdl = fitlm(X, Y);
    nw = newy(mdl, X, Y);
    capm_reg{i} = nw;
end

%FF3
for i = 1:11
    X1 = ff3f.mkt_rf;    X2 = ff3f.smb;    X3 = ff3f.hml;
    X = [X1 X2 X3];
    col = (i*3)+1;
    Y = table2array(Anof(:,col));
    mdl = fitlm(X, Y);
    nw = newy(mdl, X, Y);
    ff3_reg{i} = nw;
end

ff5_filter = (ff5.year >= min(vix.Date)) + (ff5.year == datetime(1986,1,1));
ff5y = ff5(ff5_filter == 1, :);
ff5f = ff5y(filter == 1, :);
% FF5
for i = 1:11
    X1 = ff5f.mkt_rf;    X2 = ff5f.smb;    X3 = ff5f.hml;
    X4 = ff5f.rmw;       X5 = ff5f.cma;
    X = [X1 X2 X3 X4 X5];
    col = (i*3)+1;
    Y = table2array(Anof(:,col));
    mdl = fitlm(X, Y);
    nw = newy(mdl, X, Y);
    ff5_reg{i} = nw; 
end

fffw_filter = (fffw.year >= min(vix.Date)) + (fffw.year == datetime(1986,1,1));
fffwy = fffw(fffw_filter == 1, :);
fffwf = fffwy(filter == 1, :);
% FF6 (FF5 + Momentum)
for i = 1:11
    X1 = ff5f.mkt_rf;    X2 = ff5f.smb;    X3 = ff5f.hml;
    X4 = ff5f.rmw;       X5 = ff5f.cma;    X6 = fffwf.umd;
    X = [X1 X2 X3 X4 X5 X6];
    col = (i*3)+1;
    Y = table2array(Anof(:,col));
    mdl = fitlm(X, Y);
    nw = newy(mdl, X, Y);
    ff6_reg{i} = nw; 
end

% FF6 + VIX
for i = 1:11 
    X1 = ff5f.mkt_rf;    X2 = ff5f.smb;    X3 = ff5f.hml;
    X4 = ff5f.rmw;       X5 = ff5f.cma;    X6 = fffwf.umd;
    X7 = vix.vxo(filter == 1, :);
    X = [X1 X2 X3 X4 X5 X6 X7];
    col = (i*3)+1;
    Y = table2array(Anof(:,col));
    mdl = fitlm(X, Y);
    nw = newy(mdl, X, Y);
    ff6vix_reg{i} = nw;   
end

save('uncon.mat');

function [Coefficients_NW] = newy(mdl,x, y)
    % Calculate the lag selection parameter for the standard Newey-West HAC 
    % estimate (Andrews and Monohan, 1992).
    T = length(y);  maxLag = floor(4*(T/100)^(2/9));  clear T; 

    % Estimate the standard Newey-West OLS coefficient covariance using hac by 
    % setting the bandwidth to maxLag + 1. Display the OLS coefficient estimates,
    % their standard errors, and the covariance matrix.
    EstCov = hac(x,y,'bandwidth',maxLag+1, 'display', 'off');

    NWSE = sqrt(diag(EstCov));      
    Estimate = table2array(mdl.Coefficients(:,1));   % OLS coefficients
    tStat = Estimate./NWSE;                          % Newey West t-stats.
    % Calculate the p-value using the t-stats and the degree of freedom
    df = length(y) - length(Estimate);  % degree of freedom
    pValue = 2*(1-tcdf(abs(tStat),df));
    % Save the output in a table; 
    Coefficients_NW = table(Estimate,NWSE,tStat,pValue); 
    clear Estimate NWSE tStat pValue df; 
end