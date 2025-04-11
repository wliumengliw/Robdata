% -------------------------------
% Configuration for 8 Networks
% -------------------------------
function params=parameters()
params = struct();

% ER
params.ER.N = 100;
params.ER.nlink = 300;
params.ER.style = 'no_chain';

% SF
params.SF.N = 100;
params.SF.nlink = 300;
params.SF.style = 'no_chain';
params.SF.sfpara.mu = 0.9;
params.SF.sfpara.theta = 1;

% MCN
params.MCN.r = 1;
params.MCN.N = 100;

% QSN
params.QSN.r = 3;
params.QSN.N = 100;
params.QSN.q = 0.3;
params.QSN.nlink = 300;
params.QSN.itop = 'chain';

% RTN
params.RTN.N = 100;
params.RTN.nlink = 300;
params.RTN.style = 'loop';

% RH
params.RH.N = 100;
params.RH.m = 300;

% SW-NW
params.SWNW.N = 100;
params.SWNW.K = 2;
params.SWNW.p = 0.05;

% SW-WS
params.SWWS.N = 100;
params.SWWS.K = 2;
params.SWWS.beta = 0.1;

