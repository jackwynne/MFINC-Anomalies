% This is a sample code for calculating the year-by-year change in Total
% Assets (the proxy for firm investment)
%% Calculate INV (using Compustat data)
% Variable Definition: INV = (AT(t) - AT(t-1)) / AT(t-1)
clear; clc; load('Dataset_Compustat_2010_2018.mat','Compustat20102018')
% main program to calculate the lagged Total Assets 
[nobs,~] = size(Compustat20102018);
Compustat20102018.at_bop = nan(nobs,1);     % Pre-allocate 
Compustat20102018 = sortrows(Compustat20102018,{'LPERMNO','fyear'});
id = Compustat20102018.LPERMNO;  uid = unique(id);  nfirms = length(uid);
yyyymm = Compustat20102018.fyear;    at = Compustat20102018.at; 
h = waitbar(0,'Please wait...'); 
for i = 1:nfirms
    fts_i = (id == uid(i)); 
    yyyymm_i = yyyymm(fts_i,1); 
    at_i = at(fts_i,1);
    % calculate the one-period lag
    at_i_lag = lagmatrix(at_i,[1]);
    Compustat20102018.at_bop(fts_i,1) = at_i_lag; 
    waitbar(i / nfirms)
end
close(h)
%--------------------------------------------------------------------------
Compustat20102018.INV = (Compustat20102018.at - Compustat20102018.at_bop)...
    ./Compustat20102018.at_bop;
writetable(Compustat20102018,'Sample_Compustat.csv');
% Save the output
% save('Dataset_Compustat_2010_2018.mat','Compustat20102018','-append');
%==========================================================================