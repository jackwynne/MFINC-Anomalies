function [gpa] = a2_gpa(REVTt, COGSt, ATt)
% Anomaly Two: Gross Profitability
%   Finds the gross profitability for a firm for a year
gpa = (REVTt-COGSt)./ATt;
end
