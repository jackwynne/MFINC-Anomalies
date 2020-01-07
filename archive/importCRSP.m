clear; clc;

%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: C:\Users\jackw\OneDrive\Documents\2019\MFINC\Code\crspa.csv
%
% Auto-generated by MATLAB on 26-Nov-2019 13:38:16

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 34);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["GVKEY", "datadate", "fyear", "indfmt", "consol", "popsrc", "datafmt", "tic", "conm", "ajex", "curcd", "act", "at", "ceq", "ch", "che", "cogs", "csho", "dlc", "dltt", "dp", "invt", "lct", "lqpl1", "lt", "mib", "ni", "ppegt", "pstk", "revt", "txp", "exchg", "costat", "prcc_f"];
opts.VariableTypes = ["double", "datetime", "double", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double"];
opts = setvaropts(opts, 2, "InputFormat", "dd/MM/yyyy");
opts = setvaropts(opts, [4, 5, 6, 7, 8, 9, 11, 33], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
crspa = readtable("C:\Users\jackw\OneDrive\Documents\2019\MFINC\Code\crspa.csv", opts);

% Clear temporary variables
clear opts

%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: C:\Users\jackw\OneDrive\Documents\2019\MFINC\Code\crspq.csv
%
% Auto-generated by MATLAB on 26-Nov-2019 13:39:19

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 25);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["GVKEY", "datadate", "fyearq", "fqtr", "indfmt", "consol", "popsrc", "datafmt", "conm", "curcdq", "datacqtr", "datafqtr", "actq", "atq", "ceqq", "cshoq", "dlcq", "dlttq", "ibq", "lctq", "ltq", "niq", "piq", "costat", "prccq"];
opts.VariableTypes = ["double", "datetime", "double", "double", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical", "double"];
opts = setvaropts(opts, 2, "InputFormat", "dd/MM/yyyy");
opts = setvaropts(opts, [5, 6, 7, 8, 9, 10, 11, 12, 24], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
crspq = readtable("C:\Users\jackw\OneDrive\Documents\2019\MFINC\Code\crspq.csv", opts);
% Clear temporary variables
clear opts
%%
save("crsp.mat");