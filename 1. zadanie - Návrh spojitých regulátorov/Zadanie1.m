clc;
clear;
close all;

%hodnoty
K=43.5;
T1=935;
T2=25;
Delay=300;
Beta = 1.944;

b0 = K/(T1*T2);
t1 = (T1+T2)/(T1*T2);
t0 = 1/(T1*T2);

citatel = (K/(T1*T2));
menovatel = [1,(T1+T2)/(T1*T2), 1/(T1*T2)];

p1 = T1+T2+Delay;
p2 = T1^2+T2^2;
p3 = T1^3+T2^3;
p4 = T1^4+T2^4;
p5 = T1^5+T2^5;

a0 = 1;
a1 = p1;
a2 = ((p1^2)-p2)/2;
a3 = ((p1^3)-(3*p1*p2)+(2*p3))/6;
a4 = ((p1^4)-(6*(p1^2)*p2)+(8*p1*p3)+(3*(p2^2))-(6*p4))/24;
a5 = ((p1^5)-(10*(p1^3)*p2)+(20*(p1^2)*p3)+(15*p1*(p2^2))-(30*p1*p4)-(20*p2*p3)+(24*p5))/120;

A = [a1,-1,0;a3,-a2,a1;a5,-a4,a3];
b = (1/(2*K))*[1;-a1^2+2*a2;a2^2-2*a1*a3+2*a4]

DM = b(1)
PM = b(2)
IM = b(3)

%inverzna_dynamika
a = 1/(Beta*Delay);

TI = T1 + T2;
TD = t1^(-1);

P = (a/K)*TI;
I = P/TI;
D = P*TD;

%sucet_casovych_konstant
Ts = p1;

P1 = 2/K;
TI1 = 0.8*Ts;
TD1 = 0.194*Ts;

I1 = P1/TI1;
D1 = P1*TD1;

%simulacia_a_spracovanie
Simulation = sim("BlokSchema1.slx");

figure;
hold on;

Names = {'optimalModul','inverzDynam','sucetCasKonst'};

plot(Simulation.tout,Simulation.o.Data);
plot(Simulation.tout,Simulation.i_d.Data);
plot(Simulation.tout,Simulation.s_c_k.Data);
legend(Names,'Location','southeast')
hold off;

%stepinfo
Optimal = stepinfo(Simulation.o.Data, Simulation.tout)
InverzDyn = stepinfo(Simulation.i_d.Data, Simulation.tout)
CasKonst = stepinfo(Simulation.s_c_k.Data, Simulation.tout)

GR = tf([D1 P1 I1],[1 0]);
G = tf(citatel, menovatel, 'InputDelay', Delay);
[G_cit, G_men]=tfdata(G);
[GR_cit, GR_men]=tfdata(GR);
G_coef(1,[1 2 3]) = cell2mat(G_cit);
G_coef(2,[1 2 3]) = cell2mat(G_men);
GROPM_coef(1,[1 2 3]) = cell2mat(GR_cit);
GROPM_coef(2,[1 2 3]) = cell2mat(GR_men);

syms o;
G_syms = (G_coef(1,1)*o^2 +G_coef(1,2)*o +G_coef(1,3))/(G_coef(2,1)*o^2 +G_coef(2,2)*o +G_coef(2,3));
GROPM_syms = (GROPM_coef(1,1)*o^2+GROPM_coef(1,2)*o+GROPM_coef(1,3))/(GROPM_coef(2,1)*o^2+GROPM_coef(2,2)*o+GROPM_coef(2,3));

e = limit(1/(1+G_syms*GROPM_syms),o,0)
y = limit((G_syms*GROPM_syms)/(1+G_syms*GROPM_syms),o,0)
u = limit(GROPM_syms/(1+G_syms*GROPM_syms),o,0)

Gd = pade(G,1);

Go = Gd*GR;

CHRURO = minreal(1+Go);
polyURO = roots (CHRURO.Numerator{1})