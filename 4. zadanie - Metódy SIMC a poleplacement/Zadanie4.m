clear
clc

%% Hodnoty
K = 43.5;
T = 300; % tiež T_omega z prednášky
T1 = 935;
T2 = 25;
Delay = 300; 
Beta = 1.944;
B = min(T1, 4*(T+Delay));

citatel = (K/(T1*T2));
menovatel = [1,(T1+T2)/(T1*T2), 1/(T1*T2)];

%% SIMC
G = tf(citatel, menovatel, 'InputDelay', Delay);
G_z = c2d(G,T);

P = (T1*(T2+B))/((B*K)*(T+Delay));
Ti = T2+B;
Td = (B*T2)/(T2+B);

q00 = P*(1+(Td/T)+(T/Ti));
q11 = (-P*(1+((2*Td)/T)));
q22 = ((P*Td)/T);

Grz = filt([q00 q11 q22],[1 -1],T)

%% Poleplacement
