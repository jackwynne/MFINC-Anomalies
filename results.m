clear; clc; load('uncon.mat'); load('conpat.mat');

names = AnoLSS.Properties.VariableNames;
lssn = [];
longn = [];
shortn = [];
for i = 1:11
    col = (i*3)+1;  col1 = (i*3)-1;    col2 = (i*3); 
    lssn = [lssn, names(:,col)];
    longn = [longn, names{:,col1}];
    shortn = [shortn, names{:,col2}];
end

unconstats = long_means;
unconstats = vertcat(unconstats, short_means);
unconstats = vertcat(unconstats, lms_means);
unconstats = vertcat(unconstats, long_stdev);
unconstats = vertcat(unconstats, short_stdev);
unconstats = vertcat(unconstats, lms_stdev);
unconstats = transpose(unconstats);

[res_capm, rese_capm, rest_capm] = unconres(capm_reg);
[res_ff3, rese_ff3, rest_ff3] = unconres(ff3_reg);
[res_ff5, rese_ff5, rest_ff5] = unconres(ff5_reg);
[res_ff6, rese_ff6, rest_ff6] = unconres(ff6_reg);
[res_ff6vix, rese_ff6vix, rest_ff6vix] = unconres(ff6vix_reg);


res_vol_stats = [];
res_vol_stats_mean = [];
res_vol_stats_stdev = [];
for x = 1:11
    means = [];
    means = [means, highvol_stats{2}(x)];
    means = [means, lowvol_stats{2}(x)];
    means = [means, highvol_stats{3}(x)];
    means = [means, lowvol_stats{3}(x)];
    means = [means, highvol_stats{1}(x)];
    means = [means, lowvol_stats{1}(x)];
    
    stdev = [];
    stdev = [stdev, highvol_stats{5}(x)];
    stdev = [stdev, lowvol_stats{5}(x)];
    stdev = [stdev, highvol_stats{6}(x)];
    stdev = [stdev, lowvol_stats{6}(x)];
    stdev = [stdev, highvol_stats{4}(x)];
    stdev = [stdev, lowvol_stats{4}(x)];
    
    res_vol_stats = vertcat(res_vol_stats, means);
    res_vol_stats = vertcat(res_vol_stats, stdev);

    res_vol_stats_mean = vertcat(res_vol_stats_mean, means);
    res_vol_stats_stdev = vertcat(res_vol_stats_stdev, stdev);
end

res_epu_stats = [];
res_epu_stats_mean = [];
res_epu_stats_stdev = [];
for x = 1:11
    means = [];
    means = [means, highepu_stats{2}(x)];
    means = [means, lowepu_stats{2}(x)];
    means = [means, highepu_stats{3}(x)];
    means = [means, lowepu_stats{3}(x)];
    means = [means, highepu_stats{1}(x)];
    means = [means, lowepu_stats{1}(x)];
    
    stdev = [];
    stdev = [stdev, highepu_stats{5}(x)];
    stdev = [stdev, lowepu_stats{5}(x)];
    stdev = [stdev, highepu_stats{6}(x)];
    stdev = [stdev, lowepu_stats{6}(x)];
    stdev = [stdev, highepu_stats{4}(x)];
    stdev = [stdev, lowepu_stats{4}(x)];
    
    res_epu_stats = vertcat(res_epu_stats, means);
    res_epu_stats = vertcat(res_epu_stats, stdev);

    res_epu_stats_mean = vertcat(res_epu_stats_mean, means);
    res_epu_stats_stdev = vertcat(res_epu_stats_stdev, stdev);
end

res_liq_stats = [];
res_liq_stats_mean = [];
res_liq_stats_stdev = [];
for x = 1:11
    means = [];
    means = [means, highliq_stats{2}(x)];
    means = [means, lowliq_stats{2}(x)];
    means = [means, highliq_stats{3}(x)];
    means = [means, lowliq_stats{3}(x)];
    means = [means, highliq_stats{1}(x)];
    means = [means, lowliq_stats{1}(x)];
    
    stdev = [];
    stdev = [stdev, highliq_stats{5}(x)];
    stdev = [stdev, lowliq_stats{5}(x)];
    stdev = [stdev, highliq_stats{6}(x)];
    stdev = [stdev, lowliq_stats{6}(x)];
    stdev = [stdev, highliq_stats{4}(x)];
    stdev = [stdev, lowliq_stats{4}(x)];
    
    res_liq_stats = vertcat(res_liq_stats, means);
    res_liq_stats = vertcat(res_liq_stats, stdev);

    res_liq_stats_mean = vertcat(res_liq_stats_mean, means);
    res_liq_stats_stdev = vertcat(res_liq_stats_stdev, stdev);
end


% res_highv_ff6vix = [];
% rese_highv_ff6vix = [];
% resp_highv_ff6vix = [];
% for x = 1:11
%     estimate = transpose(highvol_ff6vix_reg{x}.Coefficients.Estimate);
%     pval = transpose(highvol_ff6vix_reg{x}.Coefficients.pValue);
%     res_highv_ff6vix = vertcat(res_highv_ff6vix, estimate);
%     rese_highv_ff6vix = vertcat(rese_highv_ff6vix, estimate);
%     resp_highv_ff6vix = vertcat(resp_highv_ff6vix, pval);
% end
    
function [res, rese, rest] = unconres(mdl)
    res = [];
    rese = [];
    rest = [];
    for x = 1:11
        estimate = transpose(mdl{x}.Estimate);
        tstat = transpose(mdl{x}.tStat);
        res = vertcat(res, estimate);
        res = vertcat(res, tstat);
        rese = vertcat(rese, estimate);
        rest = vertcat(rest, tstat);
    end
end