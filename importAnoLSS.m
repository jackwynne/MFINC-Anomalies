%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: C:\Users\jackw\OneDrive\Documents\2019\MFINC\Code\rf.csv
%
% Auto-generated by MATLAB on 11-Dec-2019 07:20:00
clear; clc;

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["year", "b10ret", "b5ret", "b2ret", "b1ret", "t90ret", "t30ret"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
rf = readtable("C:\Users\jackw\OneDrive\Documents\2019\MFINC\Code\rf.csv", opts);


%% Clear temporary variables
clear opts

%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: C:\Users\jackw\OneDrive\Documents\2019\MFINC\Code\Archive_AnomalyRet_11_Long_Short_Spread.csv
%
% Auto-generated by MATLAB on 10-Dec-2019 18:04:02

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 34);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["YYYYMM", "Long_ACCRUAL_ADJ", "Short_ACCRUAL_ADJ", "Spread_ACCRUAL_ADJ", "Long_ASSET_GROWTH", "Short_ASSET_GROWTH", "Spread_ASSET_GROWTH", "Long_COMPOSITE_ISSUE", "Short_COMPOSITE_ISSUE", "Spread_COMPOSITE_ISSUE", "Long_DISTRESS", "Short_DISTRESS", "Spread_DISTRESS", "Long_GP_ADJ", "Short_GP_ADJ", "Spread_GP_ADJ", "Long_INVASSET", "Short_INVASSET", "Spread_INVASSET", "Long_MOMENTUM", "Short_MOMENTUM", "Spread_MOMENTUM", "Long_NOA", "Short_NOA", "Spread_NOA", "Long_OSCORE", "Short_OSCORE", "Spread_OSCORE", "Long_ROA", "Short_ROA", "Spread_ROA", "Long_STOCK_ISSUE", "Short_STOCK_ISSUE", "Spread_STOCK_ISSUE"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "InputFormat", "yyyyMM");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
AnoLSS = readtable("C:\Users\jackw\OneDrive\Documents\2019\MFINC\Code\Archive_AnomalyRet_11_Long_Short_Spread.csv", opts);

clear opts
save('AnoLSS.mat');