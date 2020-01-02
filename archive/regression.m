clear; clc; load('decile.mat');

%% Long minus Short
ls = sortrows(anomalies, 'year');
long = ls(ls.dec == 10, :);
short = ls(ls.dec == 1, :);

lms = table;
lms.year = long.year;
lms.gpa_lms = long.gpa_ret - short.gpa_ret;
lms.ag_lms = long.ag_ret - short.ag_ret;

%% Correlation
corrcoef(lms.gpa_lms,lms.ag_lms)