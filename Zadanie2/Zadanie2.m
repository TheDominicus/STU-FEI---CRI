clear

%% Hodnoty
K = 43.5;
T = 300;
T1 = 935;
T2 = 25;
Delay = 300;
Beta = 1.944;

citatel = (K/(T1*T2));
menovatel = [1,(T1+T2)/(T1*T2), 1/(T1*T2)];

%% Metoda inverznej dynamiky
a = 1/(Beta*Delay);

TI = T1 + T2;
TD = t1^(-1);

P = (a/K)*TI;
I = P/TI;
D = P*TD;

%% Simulacia a Spracovanie
G = tf(citatel, menovatel, 'InputDelay', Delay);
Gp = pade(G,1)
Gz_celk = c2d(Gp, T, 'zoh')
Greg = tf([D P I],[1 0]);
Grz_tustin = c2d(Greg, T, 'tustin')

%% Spatna obdlznikova metoda
q0 = P + T*I + D/T;
q1 = (-P) - ((2*D)/T);
q2 = D/T;

Grz_spatnaObdlMet = filt([q0 q1 q2], [1 -1], T);
Goro_spatnaObdlMet = Gz_celk * Grz_spatnaObdlMet;
Guro_spatnaObdlMet = minreal(Goro_spatnaObdlMet/(1+Goro_spatnaObdlMet));

%% Lichobeznikova nahrada - lepsia metoda
Goro_lychNah = Gz_celk * Grz_tustin;
Guro_lychNah = minreal(Goro_lychNah/(1+Goro_lychNah));

%% Vykreslenie
figure(1);
hold on;
step(Guro_lychNah)
step(Guro_spatnaObdlMet)
legend('LichobeznikovaNahrada', 'SpatnaOblznikovaMetoda')
hold off;

infoSpatObdlMet = stepinfo(Guro_spatnaObdlMet)
infoLychNah = stepinfo(Guro_lychNah)

CHRuro_tustin = minreal(1+(Gz_celk*Grz_tustin));
polyURO = roots(CHRuro_tustin.Numerator{1})

Simulation = sim("BlokSchema.slx");

%% Overenie
Gyw=minreal (Gz_celk*Goro_lychNah/(1+Gz_celk*Goro_lychNah));
cit = Gyw.Numerator{1}; 
den = Gyw.Denominator{1};

Guw=minreal (Goro_lychNah/(1+Gz_celk*Goro_lychNah));
citU = Guw.Numerator{1}; 
denU = Guw.Denominator{1};

Gew=minreal (1/(1+Gz_celk*Goro_lychNah));
citE = Gew.Numerator{1}; 
denE = Gew.Denominator{1};
syms z

limitaY1=vpa (limit (poly2sym(cit,z)/poly2sym(den,z),z,1),4) %vystup
limitaU1=vpa (limit (poly2sym(citU,z)/poly2sym(denU,z),z,1),4) %vstup
limitaE1=vpa (limit (poly2sym(citE,z)/poly2sym(denE,z),z,1),4) %odchylka