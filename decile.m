clear; clc; load('crsp+an.mat');

minyear = min(crspa.fyear);     maxyear = max(crspa.fyear);
year = crspa.fyear;

gpa = crspa.gpa;        ag = crspa.ag;      iva = crspa.iva;
noa = crspa.noa;        ac = crspa.ac;      nsi = crspa.nsi;
cei = crspa.cei;

for y = minyear:maxyear
    fts_y = (year == y); 
    gpa_y = gpa(fts_y, 1);
    ag_y = ag(fts_y, 1);
    iva_y = iva(fts_y, 1);
    noa_y = noa(fts_y, 1);
    ac_y = ac(fts_y, 1);
    nsi_y = nsi(fts_y, 1);
    cei_y = cei(fts_y, 1);
    
    gpa_dec = quantileranks(gpa_y, 10);
    ag_dec = quantileranks(ag_y, 10);
    iva_dec = quantileranks(iva_y, 10);
    noa_dec = quantileranks(noa_y, 10);
    ac_dec = quantileranks(ac_y, 10);
    nsi_dec = quantileranks(nsi_y, 10);
    cei_dec = quantileranks(cei_y, 10);
    
    crspa.gpa_dec(fts_y, 1) = gpa_dec;
    crspa.ag_dec(fts_y, 1) = ag_dec;
    crspa.iva_dec(fts_y, 1) = iva_dec;
    crspa.noa_dec(fts_y, 1) = noa_dec;
    crspa.ac_dec(fts_y, 1) = ac_dec;
    crspa.nsi_dec(fts_y, 1) = nsi_dec;
    crspa.cei_dec(fts_y, 1) = cei_dec;
end