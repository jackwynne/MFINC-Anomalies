clear; clc; load('anomalies2.mat');

minyear = min(crspa.fyear);     maxyear = max(crspa.fyear);
year = crspa.fyear;             nyears = maxyear - minyear;

gpa = crspa.gpa;        ag = crspa.ag;      iva = crspa.iva;
noa = crspa.noa;        ac = crspa.ac;      nsi = crspa.nsi;
cei = crspa.cei;

%% Calculate Deciles
h = waitbar(0,'Please wait for deciles...');
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
    waitbar(y / nyears)
end
close(h)

%% Calculate Equal Weighted Returns
gpa_dec = crspa.gpa_dec;    ag_dec = crspa.ag_dec;
anomalies = table();
h = waitbar(0,'Please wait for anomalies...');
for d = 1:10
    gpa_d = (gpa_dec == d);
    ag_d = (ag_dec == d);
    for y = minyear:maxyear
        a = table();
        fts_y = (year == y); 
        gpa_d_y = gpa(gpa_d == 1 & fts_y == 1);
        ag_d_y = ag(ag_d == 1 & fts_y == 1);
        gpa_ret = mean(gpa_d_y);
        ag_ret = mean(ag_d_y);
        a.year = y;
        a.dec = d;
        a.gpa_ret = gpa_ret;
        a.ag_ret = ag_ret;
        anomalies = [anomalies;a];
        waitbar((y / nyears + d / 10)/2)
    end
end
close(h)
save("decile.mat")