clear; clc; load('AnoLSS.mat');

% Adjustments to vix dataset for formatting
days = day(vix.Date);
LastDayOfMonthIndex=[diff(days)]<0;
LastDayOfMonthIndex(end) = 1;
vix = vix(LastDayOfMonthIndex == 1,:);
vix.Date = datetime(vix.Date,'Format', 'yyyyMM');

% Create filters for high and low vol
vix.vxo_lag = lagmatrix(vix.vxo,1);
high_val_vol = prctile(vix.vxo_lag, 70);
low_v_vol = prctile(vix.vxo_lag, 30);
high_f_vol = vix.vxo_lag >= high_val_vol;
low_f_vol = vix.vxo_lag <= low_v_vol;

% Cut EPU data to time
epu_filter1 = (epu.year >= min(vix.Date)) + (epu.year == datetime(1986,1,1));
epu_filter2 = epu.year <= max(vix.Date);
epuy = epu(epu_filter1 == epu_filter2 == 1, :);

% Create filters for high and low epu
epuy.compo_lag = lagmatrix(epuy.compo,1);
high_v_epu = prctile(epuy.compo_lag, 70);
low_v_epu = prctile(epuy.compo_lag, 30);
high_f_epu = epuy.compo_lag >= high_v_epu;
low_f_epu = epuy.compo_lag <= low_v_epu;

% Cut liquidity data to time
liq_filter1 = (liq.year >= min(vix.Date)) + (liq.year == datetime(1986,1,1));
liq_filter2 = liq.year <= max(vix.Date);
liqy = liq(liq_filter1 == liq_filter2 == 1, :);

% Create filters for high and low liquidity
liqy.avg_lag = lagmatrix(liqy.avg_liq,1);
high_v_liq = prctile(liqy.avg_lag, 70);
low_v_liq = prctile(liqy.avg_lag, 30);
high_f_liq = liqy.avg_lag >= high_v_liq;
low_f_liq = liqy.avg_lag <= low_v_liq;

% Run regressions
[highvol_stats, highvol_capm_reg, highvol_ff3_reg, highvol_ff5_reg, highvol_ff6_reg, highvol_ff6vix_reg]...
    = conditionalPattern(high_f_vol);
[lowvol_stats, lowvol_capm_reg, lowvol_ff3_reg, lowvol_ff5_reg, lowvol_ff6_reg, lowvol_ff6vix_reg]...
    = conditionalPattern(low_f_vol);

[highepu_stats, highepu_capm_reg, highepu_ff3_reg, highepu_ff5_reg, highepu_ff6_reg, highepu_ff6vix_reg]...
    = conditionalPattern(high_f_epu);
[lowepu_stats, lowepu_capm_reg, lowepu_ff3_reg, lowepu_ff5_reg, lowepu_ff6_reg, lowepu_ff6vix_reg]...
    = conditionalPattern(low_f_epu);

[highliq_stats, highliq_capm_reg, highliq_ff3_reg, highliq_ff5_reg, highliq_ff6_reg, highliq_ff6vix_reg]...
    = conditionalPattern(high_f_liq);

[lowliq_stats, lowliq_capm_reg, lowliq_ff3_reg, lowliq_ff5_reg, lowliq_ff6_reg, lowliq_ff6vix_reg]...
    = conditionalPattern(low_f_liq);

function [stats, capm_reg, ff3_reg, ff5_reg, ff6_reg, ff6vix_reg] = conditionalPattern(filter)
    load('AnoLSS.mat');
    
    AnoLSS_filter = (AnoLSS.YYYYMM >= min(vix.Date)) + (AnoLSS.YYYYMM == datetime(1986,1,1));
    AnoLSSy = AnoLSS(AnoLSS_filter == 1, :);
    Anof = AnoLSSy(filter == 1, :);
    
    zerod_data = Anof(:,2:end);
    zerod_data{:,:}(isnan(zerod_data{:,:})) = 0;
    zdata = table2array(zerod_data(:,:));

    rf_filter = (rf.year >= min(vix.Date)) + (rf.year == datetime(1986,1,1));
    rfy = rf(rf_filter == 1, :);
    rff = rfy(filter == 1, :);

    % Adjustments to vix dataset for formatting
    days = day(vix.Date);
    LastDayOfMonthIndex=[diff(days)]<0;
    LastDayOfMonthIndex(end) = 1;
    vix = vix(LastDayOfMonthIndex == 1,:);
    vix.Date = datetime(vix.Date,'Format', 'yyyyMM');
    
    %% 1.1 Excess Returns

    % Mean
    means = nanmean(Anof{:,2:end});

    % Std Dev
    std_dev = nanstd(Anof{:,2:end});

    % Correlation
    corrs = corr(zdata);

    % Sharpe Ratio
    sharpe = (Anof{:,2:end} - rff.b10ret) ./ std_dev;
    
    stats{1} = means;
    stats{2} = std_dev;
    stats{3} = corrs;
    stats{4} = sharpe;
    
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