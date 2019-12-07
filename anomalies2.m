% This is a sample code for calculating the year-by-year change in Total
% Assets (the proxy for firm investment)
%% Calculate Annual
clear; clc; load('crsp.mat');
% main program to calculate the lagged Total Assets 
[nobs,~] = size(crspa);
crspa.at_bop = nan(nobs,1);     % Pre-allocate 
crspa = sortrows(crspa,{'GVKEY','fyear'});
id = crspa.GVKEY;  uid = unique(id);  nfirms = length(uid);
yyyymm = crspa.fyear;    at = crspa.at;       ppegt = crspa.ppegt;
invt = crspa.invt;       act = crspa.act;     che = crspa.che;
lct = crspa.lct;         dlc = crspa.dlc;     txp = crspa.txp;
crspa.ads = (crspa.csho .* crspa.ajex);        ads = crspa.ads;
crspa.me = (crspa.csho .* crspa.prcc_f);            me = crspa.me;
prc = crspa.prcc_f;
h = waitbar(0,'Please wait for annual variables...'); 
for i = 1:nfirms
    fts_i = (id == uid(i)); 
    yyyymm_i = yyyymm(fts_i,1); 
    at_i = at(fts_i,1);
    ppegt_i = ppegt(fts_i,1);
    invt_i = invt(fts_i,1);
    act_i = act(fts_i,1);
    che_i = che(fts_i,1);
    lct_i = lct(fts_i,1);
    dlc_i = dlc(fts_i,1);
    txp_i = txp(fts_i,1);
    ads_i = ads(fts_i,1);
    me_i = me(fts_i,1);
    prc_i = prc(fts_i,1);
    % calculate the one-period lag
    at_i_lag = lagmatrix(at_i,[1]);
    ppegt_i_lag = lagmatrix(ppegt_i,[1]);
    invt_i_lag = lagmatrix(invt_i,[1]);
    act_i_lag = lagmatrix(act_i,[1]);
    che_i_lag = lagmatrix(che_i,[1]);
    lct_i_lag = lagmatrix(lct_i,[1]);
    dlc_i_lag = lagmatrix(dlc_i,[1]);
    txp_i_lag = lagmatrix(txp_i,[1]);
    ads_i_lag = lagmatrix(ads_i,[1]);
    me_i_lag5 = lagmatrix(me_i,[5]);
    prc_i_lag = lagmatrix(prc_i, [1]);
    prc_i_lag5 = lagmatrix(prc_i, [5]);
    rtn_i = prc_i - prc_i_lag;
    crspa.ATtm1(fts_i,1) = at_i_lag; 
    crspa.PPEGTtm1(fts_i,1) = ppegt_i_lag;
    crspa.INVTtm1(fts_i,1) = invt_i_lag;
    crspa.ACTtm1(fts_i,1) = act_i_lag;
    crspa.CHEtm1(fts_i,1) = che_i_lag;
    crspa.LCTtm1(fts_i,1) = lct_i_lag;
    crspa.DLCtm1(fts_i,1) = dlc_i_lag;
    crspa.TXPtm1(fts_i,1) = txp_i_lag;
    crspa.ADStm1(fts_i,1) = ads_i_lag;
    crspa.MEtm5(fts_i,1) = me_i_lag5;
    crspa.PRCtm1(fts_i,1) = prc_i_lag;
    crspa.PRCtm5(fts_i,1) = prc_i_lag5;
    crspa.rtn(fts_i,1) = rtn_i;

    waitbar(i / nfirms)
end
close(h)
%% Calculate Quarterly 
[nobs,~] = size(crspq);
crspq.at_bop = nan(nobs,1);     % Pre-allocate 
crspq = sortrows(crspq,{'GVKEY','fyearq','fqtr'});
id = crspq.GVKEY;  uid = unique(id);  nfirms = length(uid);
yyyymm = (crspq.fyearq .* 10) + crspq.fqtr;
niq = crspq.niq;        prcq = crspq.prccq;
crspq.meq = (crspq.cshoq .* crspq.prccq);
h3 = waitbar(0,'Please wait for quarterly variables...'); 
for i = 1:nfirms
    fts_i = (id == uid(i)); 
    yyyymm_i = yyyymm(fts_i,1); 
    niq_i = niq(fts_i,1);
    prcq_i = prcq(fts_i,1);
    % calculate the one-period lag
    niq_i_lag = lagmatrix(niq_i, [1]);
    prcq_i_lag = lagmatrix(prcq_i, [1]);
    rtnq_i = prcq_i - prcq_i_lag;
    crspq.NIQqm1(fts_i,1) = niq_i_lag;
    crspq.PRCQqm1(fts_i,1) = prcq_i_lag;
    crspq.rtnq(fts_i,1) = rtnq_i;
    waitbar(i / nfirms)
end
close(h3)
%--------------------------------------------------------------------------
a = 0;
ta = 11;
h2 = waitbar(0,'Calculating...'); 
%% A1: Momentum

a = a + 1;
waitbar(a/ta)

%% A2: Gross Profitability 
crspa.gpa = (crspa.revt-crspa.cogs)./crspa.at;

a = a + 1;
waitbar(a/ta)

%% A3: Asset Growth
crspa.ag = (crspa.at - crspa.ATtm1)./crspa.ATtm1;

a = a + 1;
waitbar(a/ta)

%% A4: Investment to Assets
crspa.iva = (crspa.ppegt - crspa.PPEGTtm1 + crspa.invt - crspa.INVTtm1)./crspa.ATtm1;

a = a + 1;
waitbar(a/ta)

%% A5: Return on Assets
crspq.roa = crspq.ibq ./ crspq.atq;

a = a + 1;
waitbar(a/ta)

%% A6: Net Operating Assets
crspa.noa = ((crspa.at - crspa.che) ...
- (crspa.at - crspa.dlc - crspa.dltt - crspa.mib - crspa.pstk - crspa.ceq))...
./crspa.ATtm1;

a = a + 1;
waitbar(a/ta)

%% A7: Accruals
crspa.ac = (((crspa.ACTtm1 - crspa.act) - (crspa.CHEtm1 - crspa.che)) ...
- ((crspa.LCTtm1 - crspa.lct) - (crspa.DLCtm1 - crspa.dlc) - (crspa.TXPtm1 - crspa.txp)) ...
- crspa.dp)./crspa.ATtm1;

a = a + 1;
waitbar(a/ta)

%% A8: Net Stock Issues
crspa.nsi = (log(crspa.ads) - log(crspa.ADStm1));

a = a + 1;
waitbar(a/ta)

%% A9: Coposite Equity Issues
crspa.cei = (log(crspa.me ./ crspa.MEtm5)) - ((crspa.prcc_f - crspa.PRCtm5) ./ crspa.PRCtm5);

a = a + 1;
waitbar(a/ta)

%% A10: Failure Probability 

% crspa.fp = -9.16 + (-20.26 .* crspa.nimtaavg) + (1.42 .* crspa.tlmta) ...
% + (-7.13 .* crspa.exretavg) + (1.41 .* crspa.sigma) + (-0.045 .* crspa.rsize) ...
% + (-2.13 .* crspa.cashmta) + (0.075 .* crspa.mb) + (-0.058 * crspa.prcc_f);

a = a + 1;
waitbar(a/ta)

%% A11: O-Score
crspq.adjasset = (crspq.atq) + 0.1 .* (crspq.meq - crspq.ceqq);   % Working Capital
crspq.tlta = (crspq.dlcq + crspq.dlttq) ./ crspq.adjasset;      % Leverage Ratio
crspq.wcta = (crspq.actq - crspq.lctq) ./ crspq.adjasset;       % Working Capital
crspq.clca = (crspq.lctq ./ crspq.actq);                    
crspq.oeneg = ((crspq.ltq - crspq.atq) > 0);
crspq.nita = (crspq.niq ./ crspq.adjasset);
crspq.futl = (crspq.piq ./ crspq.ltq);
crspq.intwo = ((crspq.niq < 0 ) & (crspq.NIQqm1 < 0));
crspq.chin = (crspq.niq - crspq.NIQqm1) ./ (abs(crspq.niq) + abs(crspq.NIQqm1));

crspq.os = -1.32 + (-0.407 .* log(crspq.adjasset)) + (6.03 .* crspq.tlta) ...
+ (-1.43 .* crspq.wcta) + (0.076 .* crspq.clca) + (-1.72 .* crspq.oeneg) ...
+ (-2.37 .* crspq.nita) + (-1.83 .* crspq.futl) + (0.285 .* crspq.intwo) ...
+ (-0.521 .* crspq.chin);

a = a + 1;
waitbar(a/ta)

close(h2)

save("crsp+an.mat");
% Save the output
% save('Dataset_Compustat_2010_2018.mat','Compustat20102018','-append');
%==========================================================================