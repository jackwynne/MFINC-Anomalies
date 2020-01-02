function [ag] = a3_ag(ATt,ATtm1)
% Anomaly Three: Asset Growth
%   Detailed explanation goes here
ag = (ATt - ATtm1)./ATtm1;
end

