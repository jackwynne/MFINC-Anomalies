clear; clc;
crsp = importCRSP();
sz = height(crsp);
count = 1;

comps = unique(crsp.GVKEY);
gen = table('Size', [sz,33], 'VariableTypes',...
    ["double", "datetime", "double", "double", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "categorical"...
    , "double", "double"],...
    'VariableNames',...
    ["GVKEY", "datadate", "Year", "fyear", "indfmt", "consol", "popsrc", "datafmt", "tic", "conm", "ajex", "curcd", "act", "AT", "ceq", "ch", "che", "COGS", "csho", "dlc", "dltt", "dp", "invt", "lct", "mib", "ppegt", "pstk", "REVT", "txp", "exchg", "costat"...
    , "ATt", "ATtm1"]...
    );

for i = 1:numel(comps)
    data = crsp(crsp.GVKEY == comps(i), : );
    n = 1;
    for y = (min(data.Year)):max(data.Year)
        ATt = data{data.Year == y, {'AT'}};
        if isempty(ATt) == 0
            ATtm1 = data{data.Year == (y-1), {'AT'}};
            if isempty(ATtm1)
                ATtm1 = nan();
            end
            row = addvars(data(n,:), ATt(1), ATtm1(1));
            n = n + 1;
            gen(count,:) = row;
            count = count + 1;
        end
    end
end

gpa = a2_gpa(gen.REVT, gen.COGS, gen.AT);
ag = a3_ag(gen.ATt, gen.ATtm1);

ano = table(crsp.Year, crsp.GVKEY, gpa, ag);
