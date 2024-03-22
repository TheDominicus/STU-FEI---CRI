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

%% Spracovanie - Gz
Gs = tf(citatel, menovatel, 'InputDelay', Delay);
Gp = pade(Gs,1);
Gz_celk = c2d(Gp, T, 'zoh')

%% Dead beat
citatel1 = cell2mat(Gz_celk.Numerator); %konvert cell na maticu
menovatel1 = cell2mat(Gz_celk.Denominator);

q00 = 1/sum(citatel1(2:end)); %sum citatela
q01 = menovatel1(2)*q00;
q02 = menovatel1(3)*q00;
q03 = menovatel1(4)*q00;

p01 = citatel1(2)*q00;
p02 = citatel1(3)*q00;
p03 = citatel1(4)*q00;

%% Dead beat AZ
bSum = sum(citatel1(2:end));

q10 = 0.089115984; %0.0968652 -> 92%
q11 = q10*(menovatel1(2)-1)+1/bSum;
q12 = q10*(menovatel1(3)-menovatel1(2))+(menovatel1(2)/bSum);
q13 = q10*(menovatel1(4)-menovatel1(3))+(menovatel1(3)/bSum);

p11 = q10*citatel1(2);
p12 = q10*(citatel1(3)-citatel1(2))+(citatel1(2)/bSum);
p13 = q10*(citatel1(4)-citatel1(3))+(citatel1(3)/bSum);

%% Simulacia a vykreslenie
figure(1)
out = sim("BlokSchema.slx");
plot(out.DeadBeat)
grid
legend("w - vstup","e - odchylka","y - vystup","u - akcny zasah")
xlabel("t [s]")
ylabel("value []")
title("Dead beat")

figure(2)
plot(out.DeadBeatAZ)
grid
legend("w - vstup","e - odchylka","y - vystup","u - akcny zasah")
xlabel("t [s]")
ylabel("value []")
title("Dead beat AZ")