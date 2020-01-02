clear; clc; load('AnoLSS.mat');

% Adjustments to vix dataset for formatting
days = day(vix.Date);
LastDayOfMonthIndex=[diff(days)]<0;
LastDayOfMonthIndex(end) = 1;
vix = vix(LastDayOfMonthIndex == 1,:);
vix.Date = datetime(vix.Date,'Format', 'yyyyMM');

% Create filters for high and low vol
vix.vxo_lag = lagmatrix(vix.vxo,1);
high_v = prctile(vix.vxo_lag, 70);
low_v = prctile(vix.vxo_lag, 30);
highf = vix.vxo_lag >= high_v;
lowf = vix.vxo_lag <= low_v;

[highvol_capm_reg, highvol_ff3_reg, highvol_ff5_reg, highvol_ff6_reg, highvol_ff6vix_reg]...
    = conditionalPattern(highf);
[lowvol_capm_reg, lowvol_ff3_reg, lowvol_ff5_reg, lowvol_ff6_reg, lowvol_ff6vix_reg]...
    = conditionalPattern(lowf);

function [capm_reg, ff3_reg, ff5_reg, ff6_reg, ff6vix_reg] = conditionalPattern(filter)
load('AnoLSS.mat');   
rf10 = rf.b10ret;
lsdata = table2array(AnoLSS(:,2:end));
zerod_data = AnoLSS(:,2:end);
zerod_data{:,:}(isnan(zerod_data{:,:})) = 0;
zdata = table2array(zerod_data(:,:));

% Adjustments to vix dataset for formatting
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
    AnoLSS_filter = (AnoLSS.YYYYMM >= min(vix.Date)) + (AnoLSS.YYYYMM == datetime(1986,1,1));
    AnoLSSy = AnoLSS(AnoLSS_filter == 1, :);
    Anof = AnoLSSy(filter == 1, :);
    
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
        capm_reg{i} = mdl;
    end

    %FF3
    for i = 1:11
        X1 = ff3f.mkt_rf;    X2 = ff3f.smb;    X3 = ff3f.hml;
        X = [X1 X2 X3];
        col = (i*3)+1;
        Y = table2array(Anof(:,col));
        mdl = fitlm(X, Y);
        ff3_reg{i} = mdl;
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
        ff5_reg{i} = mdl; 
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
        ff6_reg{i} = mdl; 
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
        ff6vix_reg{i} = mdl;   
    end
end