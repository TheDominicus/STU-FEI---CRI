clear
clc

%% Hodnoty
K = 43.5;
T = 300;
T1 = 935;
T2 = 25;
Delay = 300;
Beta = 1.944;

citatel = (K/(T1*T2));
menovatel = [1,(T1+T2)/(T1*T2), 1/(T1*T2)];

%% 