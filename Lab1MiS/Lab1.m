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


fig1 = figure(); hold on, grid on;
fig2 = figure(); hold on, grid on;
fig3 = figure(); hold on, grid on;
fig4 = figure(); hold on, grid on;

% Identyfikacja parametrów statycznych

Kg=PgN/(TgN-TwewN);
K12=PgN/(TwewN-TzewN);
K1=K12/2;
K2=K12/2;

% Identyfikacja parametrów dynamicznych
Cvg = cpo*roo*Vg;
Cvw = cpp*rop*Vw;

% Warunki początkowe

% Tzew0=TzewN + 0;
% Pg0=PgN * 1.0;

% Stan równowagi

% Twew0=(Pg0+(K1+K2)*Tzew0)/(K1+K2);
% Tg0=(Pg0+Kg*Twew0)/Kg;


% Zakłócenie
dPg = 0;
dTzew = 1;

% out = sim("ProModel.slx", 50000);
% figure, plot(out.tout,out.Tg), grid on, title("Temperatura grzejnika");
% figure, plot(out.tout,out.Twew), grid on, title("Temperatura pokoju");
legends = {};
for i = 1:length(tab_Tzew)
  Tzew0=tab_Tzew(i);
  Pg0=tab_Pg(i);
  Twew0=(Pg0+(K1+K2)*Tzew0)/(K1+K2);
  Tg0=(Pg0+Kg*Twew0)/Kg;

  out = sim("ProModel.slx", 50000);
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