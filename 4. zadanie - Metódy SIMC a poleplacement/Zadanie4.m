clear
clc

%% Hodnoty
K = 43.5;
T = 300; % tiež T_omega z prednášky
T1 = 935;
T2 = 25;
Delay = 300; 
Beta = 1.944;

citatel = (K/(T1*T2));
menovatel = [1,(T1+T2)/(T1*T2), 1/(T1*T2)];

%% SIMC
Psimc = (T1*(T2+Beta))/((Beta*K)*(T+T));
Ti = T2+Beta;
Td = (Beta*T2)/(T2+Beta);
Isimc = T/Ti;
Dsimc = Td/T;

G = tf(citatel, menovatel, 'InputDelay', Delay);
Gd = pade(G,1);
G_z = c2d(Gd,T);

q00 = Psimc*(1+(T/Ti)+(Td/T));
q11 = (-Psimc*(1+((2*Td)/T)));
q22 = ((Psimc*Td)/T);

Grz = tf([q00 q11 q22],[1 -1 0],T)
Grz_num = Grz.num{1};
Grz_den = Grz.den{1};

Grz_uro = (Grz*G_z)/(1+(Grz*G_z));
figure;
out = sim("BlokSchema.slx");
plot(out.SYMC)
step(Grz_uro);

%% Poleplacement


%% Simulácia a výpis
%out = sim("BlokSchema.slx");