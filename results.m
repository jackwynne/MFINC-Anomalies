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

res_ff6vix = [];
rese_ff6vix = [];
resp_ff6vix = [];
for x = 1:11
    estimate = transpose(ff6vix_reg{x}.Coefficients.Estimate);
    pval = transpose(ff6vix_reg{x}.Coefficients.pValue);
    res_ff6vix = vertcat(res_ff6vix, estimate);
    rese_ff6vix = vertcat(rese_ff6vix, estimate);
    resp_ff6vix = vertcat(resp_ff6vix, pval);
end






volstats = [];
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
    
    volstats = vertcat(volstats, means);
    %volstats = vertcat(volstats, stdev);
end


res_highv_ff6vix = [];
rese_highv_ff6vix = [];
resp_highv_ff6vix = [];
for x = 1:11
    estimate = transpose(highvol_ff6vix_reg{x}.Coefficients.Estimate);
    pval = transpose(highvol_ff6vix_reg{x}.Coefficients.pValue);
    res_highv_ff6vix = vertcat(res_highv_ff6vix, estimate);
    rese_highv_ff6vix = vertcat(rese_highv_ff6vix, estimate);
    resp_highv_ff6vix = vertcat(resp_highv_ff6vix, pval);
end
    