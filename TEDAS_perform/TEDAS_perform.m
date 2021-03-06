
clc
clear
load('TEDAS_GS.mat') % Cumulative returns of TEDAS gestalts and benchmark srategies for German stocks' sample
load('TEDAS_MF.mat') % Cumulative returns for TEDAS gestalts and benchmark srategies for Mutual funds' sample
load('TEDAS_RF_GS.mat') % Risk-free rate for German stocks (Long Term German government Bond  9-10 years) 
load('TEDAS_RF_MF.mat') % Risk-free rate for Mutual funds 
ishift  = 0;
num_dig = 4;
Date    = TEDAS_GS(2:end,1);
RetGS   = price2ret(TEDAS_GS(1:end,2:end),[], 'Periodic');
RetMF   = price2ret(TEDAS_MF(1:end,2:end),[], 'Periodic');

%% Performance measures calculation
% Cumulative returns' vector for 3 TEDAS gestalts and 5 benchmark-strategies
Cumret = TEDAS_GS(end,2:end)';
Cumret = round(Cumret*(10^num_dig))./(10^num_dig);

% Sharpe ratio for 3 TEDAS gestalts and 5 benchmark-strategies

for i = 1:size(RetGS,2)
    sharper(i) = sharpe(RetGS(1:end,i),TEDAS_RF_GS(1:end,end))
    sharpelast = sharper(i);
    ishift     = ishift + 1
end
SHARPE = [sharper,sharpelast]';
SHARPE = round(SHARPE(1:end-1,1)*(10^num_dig))./(10^num_dig);

% Maximum Drawdown for 3 TEDAS gestalts and 5 benchmark-strategies

for i = 2:size(TEDAS_GS,2)
    maxdd(i-1) = maxdrawdown(TEDAS_GS(1:end,i))
    maxddlast = maxdd(i-1);
    ishift     = ishift + 1
end
MAXDD  = [maxdd,maxddlast]';
MAXDD  = round(MAXDD(1:end-1,1)*(10^num_dig))./(10^num_dig);


%% Building latex table with TEDAS gestalts' and benchmarks' performance measures

input.data                      = [Cumret, SHARPE, MAXDD];

input.tableColLabels            = {'Cumulative return','Sharpe ratio','Maximum drawdown'};
input.tableRowLabels            = {'TEDAS basic','TEDAS naive','TEDAS hybrid'...
                                   'DAX30','MV-OGARCH','60/40 portfolio','Risk-Parity'};
input.transposeTable            = 0;
input.dataFormatMode            = 'column'; 
input.dataNanString             = '-';
input.tableColumnAlignment      = 'c';
input.tableBorders              = 1;
input.tableCaption              = 'Strategies performance overview: German stocks sample';
input.tableLabel                = 'MyTableLabel';
input.makeCompleteLatexDocument = 1;
latex                           = latexTable(input);
