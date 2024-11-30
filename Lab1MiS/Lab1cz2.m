clear all
close all

% I czesc - Identyfikacji

TzewN=-20; %oC
TwewN=20; %oC
TgN=40; %oC
Vp=35*2.5; %objetosc pokoju w m^3
Vg=0.54*0.23*0.51; %objetosc grzejnika w m^3
PgN=2000; %W
Vw=35*2.5; %m^3 pokoju
cpp=1000; rop=1.2; %powietrze
cpo=2400; roo=1200; %olej
tab_Tzew = [TzewN, TzewN+10, TzewN+10];
tab_Pg = [PgN, PgN, PgN*0.2];
color = 'rgbcm';
type = '---';

% Identyfikacja parametrów statycznych

Kg=PgN/(TgN-TwewN);
K12=PgN/(TwewN-TzewN);
K1=K12/2;
K2=K12/2;

% Identyfikacja parametrów dynamicznych
cvg = cpo*roo*Vg;
cvw = cpp*rop*Vw;

fig1 = figure(); hold on, grid on;
fig2 = figure(); hold on, grid on;
fig3 = figure(); hold on, grid on;
fig4 = figure(); hold on, grid on;

% Warunki początkowe
Tzew0=TzewN + 0;
Pg0=PgN * 1.0;

% Zakłócenie
dPg = 0;
dTzew = 1;

% Równanie
u = [Pg0;
    Tzew0];

A = [ -Kg/cvg,     Kg/cvg;
       Kg/cvw,  -(Kg + K1 + K2)/cvw ];

B = [ 1/cvg,        0;
          0,  (K1 + K2)/cvw ];

C = [ 1, 0;
      0, 1];

D = [ 0, 0;
      0, 0 ];

% x = -inv(A) * B * u;

% Tg0 = x(1);
% Twew0 = x(2);

legends = {};
for i = 1:length(tab_Tzew)
  Tzew0=tab_Tzew(i);
  Pg0=tab_Pg(i);
  u = [Pg0;
    Tzew0];
  x = -inv(A) * B * u;
  Tg0 = x(1);
  Twew0 = x(2);

  out = sim("model2.slx", 50000);
  figure(fig1), plot(out.tout,out.Tg, strcat(color(i), type(i))), grid on, title("Temperatura grzejnika");
  figure(fig2), plot(out.tout,out.Twew, strcat(color(i), type(i))), grid on, title("Temperatura pokoju");
  figure(fig3), plot(out.tout,out.Tg-Tg0, strcat(color(i), type(i))), grid on, title("Temperatura grzejnika");
  figure(fig4), plot(out.tout,out.Twew-Twew0, strcat(color(i), type(i))), grid on, title("Temperatura pokoju");
  legends{i} = sprintf('Tzew0 = %d°C, Pg0 = %.1f W', Tzew0, Pg0);
end

figure(fig1), legend(legends, 'Location', 'best'), xlabel('Czas [s]'), ylabel('Temperatura grzejnika [°C]');
figure(fig2), legend(legends, 'Location', 'best'), xlabel('Czas [s]'), ylabel('Temperatura pokoju [°C]');
figure(fig3), legend(legends, 'Location', 'best'), xlabel('Czas [s]'), ylabel('Odchylenie temperatury grzejnika [°C]');
figure(fig4), legend(legends, 'Location', 'best'), xlabel('Czas [s]'), ylabel('Odchylenie temperatury pokoju [°C]');