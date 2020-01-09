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

[res_vol_stats, res_vol_stats_mean, res_vol_stats_stdev] = constats(highvol_stats, lowvol_stats);
[res_epu_stats, res_epu_stats_mean, res_epu_stats_stdev] = constats(highepu_stats, lowepu_stats);
[res_liq_stats, res_liq_stats_mean, res_liq_stats_stdev] = constats(highliq_stats,lowliq_stats);

[res_vol_capm, rese_vol_capm, rest_vol_capm] = conres(highvol_capm_reg, lowvol_capm_reg);
[res_vol_ff3, rese_vol_ff3, rest_vol_ff3] = conres(highvol_ff3_reg, lowvol_ff3_reg);
[res_vol_ff5, rese_vol_ff5, rest_vol_ff5] = conres(highvol_ff5_reg, lowvol_ff5_reg);
[res_vol_ff6, rese_vol_ff6, rest_vol_ff6] = conres(highvol_ff6_reg, lowvol_ff6_reg);
[res_vol_ff6vix, rese_vol_ff6vix, rest_vol_ff6vix] = conres(highvol_ff6vix_reg, lowvol_ff6vix_reg);

[res_epu_capm, rese_epu_capm, rest_epu_capm] = conres(highepu_capm_reg, lowepu_capm_reg);
[res_epu_ff3, rese_epu_ff3, rest_epu_ff3] = conres(highepu_ff3_reg, lowepu_ff3_reg);
[res_epu_ff5, rese_epu_ff5, rest_epu_ff5] = conres(highepu_ff5_reg, lowepu_ff5_reg);
[res_epu_ff6, rese_epu_ff6, rest_epu_ff6] = conres(highepu_ff6_reg, lowepu_ff6_reg);
[res_epu_ff6vix, rese_epu_ff6vix, rest_epu_ff6vix] = conres(highepu_ff6vix_reg, lowepu_ff6vix_reg);

[res_liq_capm, rese_liq_capm, rest_liq_capm] = conres(highliq_capm_reg, lowliq_capm_reg);
[res_liq_ff3, rese_liq_ff3, rest_liq_ff3] = conres(highliq_ff3_reg, lowliq_ff3_reg);
[res_liq_ff5, rese_liq_ff5, rest_liq_ff5] = conres(highliq_ff5_reg, lowliq_ff5_reg);
[res_liq_ff6, rese_liq_ff6, rest_liq_ff6] = conres(highliq_ff6_reg, lowliq_ff6_reg);
[res_liq_ff6vix, rese_liq_ff6vix, rest_liq_ff6vix] = conres(highliq_ff6vix_reg, lowliq_ff6vix_reg);

save('results.mat');

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

function [stats, stats_mean, stats_stdev] = constats(high_stats,low_stats)
    stats = [];
    stats_mean = [];
    stats_stdev = [];
    for x = 1:11
        means = [];
        means = [means, high_stats{2}(x)];
        means = [means, high_stats{3}(x)];
        means = [means, high_stats{1}(x)];
        means = [means, low_stats{2}(x)];
        means = [means, low_stats{3}(x)];
        means = [means, low_stats{1}(x)];

        stdev = [];
        stdev = [stdev, high_stats{5}(x)];
        stdev = [stdev, high_stats{6}(x)];
        stdev = [stdev, high_stats{4}(x)];
        stdev = [stdev, low_stats{5}(x)];
        stdev = [stdev, low_stats{6}(x)];
        stdev = [stdev, low_stats{4}(x)];

        stats = vertcat(stats, means);
        stats = vertcat(stats, stdev);

        stats_mean = vertcat(stats_mean, means);
        stats_stdev = vertcat(stats_stdev, stdev);
    end
end

function [res, rese, rest] = conres(high_mdl, low_mdl)
    res = [];
    rese = [];
    rest = [];
    for x = 1:11
        estimate = horzcat(transpose(high_mdl{x}.Estimate), transpose(low_mdl{x}.Estimate));
        tstat = horzcat(transpose(high_mdl{x}.tStat), transpose(low_mdl{x}.tStat));
        res = vertcat(res, estimate);
        res = vertcat(res, tstat);
        rese = vertcat(rese, estimate);
        rest = vertcat(rest, tstat);
    end
end
