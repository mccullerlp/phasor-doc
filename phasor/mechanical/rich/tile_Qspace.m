   

% three masses in series with one mass hanging off of the top mass, no independent Tension paramaeter

density_glass = 2.2e3;   %kg/m^3
g = 9.8;
T = 300;
  kb = 1.38e-23; %m^2 kg/s^2 Kelvin
   Q3 = 1e9; f3 = 500; %fiber 
   w3 = 2*pi*f3;
   M3 = density_glass*pi*200e-6^2*0.5;
   
   
M1 = 40; L1 =   g*(2*M1+M3)/(M3*w3^2); Q1 = 1e7;  %test mass
w1 = sqrt(g/L1); f1 = w1/(2*pi);

 
M2 = 40; L2 = 0.4; Q2 = 1e4;  %penultimate mass
w2 = sqrt(g/L2); f2 = w2/(2*pi);
 

M4 = 0.025e-0;  Q4 = 100e3;eps =  0;  f4 = 500;% damper
w4 = 2*pi*(f4 + eps); L4 = g/w4^2;

L3 =  L1;

   params.M1.name = 'Test Mass';
   params.M1.Mass = M1;
   params.M1.Length = L1;
   params.M1.Q = Q1;
   params.M1.freq = w1/(2*pi);
   
   params.M2.name = 'Penultimate Mass';
   params.M2.Mass = M2;
   params.M2.Length = L2;
   params.M2.Q = Q2;
   params.M2.freq = w2/(2*pi);
   
   params.M3.name = 'Fiber';
   params.M3.Mass = M3;
   params.M3.Length = L3;
   params.M3.Q = Q3;
   params.M3.freq = w3/(2*pi);
   
   params.M4.name = 'Damper';
   params.M4.Mass = M4;
   params.M4.Length = L4;
   params.M4.Q = Q4;
   params.M4.freq = w4/(2*pi);
   params.M4.tune = eps;
   %%  test stuff and calcualte the undamper thermal noise form the fiber
           for kk =  8
            params.M4.Mass = M4/(10^kk);
            params.M4.Length =  g/w4^2;
           [SYS params] = getsystem2a(params);
           POLES = sort(unique(abs(pole(SYS))/(2*pi)));
           POLES = POLES(POLES>400);
           B_Fiber = 2*pi*params.M3.freq/params.M3.Q;
           
           [params.M4.Mass*1e6 max(abs(freqresp(SYS(1,4),2*pi*abs(POLES)))) ];
           FIBER_thermal_noise = sqrt(2*kb*T*B_Fiber*params.M3.Mass/pi)*max(abs(freqresp(SYS(1,4),2*pi*abs(POLES)))) ;
           [params.M4.Mass*1e6 max(abs(freqresp(SYS(1,4),2*pi*abs(POLES)))) FIBER_thermal_noise*1e12]
           end
%%
   
%    M_vector = logspace(log10(10),log10(100),20);
   M_vector = 10:5:200;  %grams
   Q_vector = 50:25:2000;
   tic
   
   peak_thermal_noise = zeros(length(Q_vector),length(M_vector));
   plus_thermal_noise = zeros(length(Q_vector),length(M_vector));
   minus_thermal_noise = zeros(length(Q_vector),length(M_vector));
   tuner = zeros(length(Q_vector),length(M_vector));
   Q_Plus = zeros(length(Q_vector),length(M_vector));
    Q_Peak = zeros(length(Q_vector),length(M_vector));
     Q_Minus = zeros(length(Q_vector),length(M_vector));
   for mm = 1:length(M_vector)   
       for qq = 1:length(Q_vector)
           params.M4.tune = 0;
           w4 = 2*pi*(f4 +  params.M4.tune);
           params.M4.Length = g/w4^2;
           params.M4.Q = Q_vector(qq);
           params.M4.Mass = M_vector(mm)/1000;
           
           [SYS params] = getsystem2a(params);
           POLES = sort(unique(abs(pole(SYS))/(2*pi)));
           POLES = POLES(POLES>400);
           del = POLES-params.M3.freq;
           [maxdel II] = max(abs(del));
           maxdel = sign(del(II))*maxdel;
           params.M4.tune = params.M4.tune  - maxdel;
            w4 = 2*pi*(f4 +  params.M4.tune);
            params.M4.freq = w4/(2*pi); params.M4.Length = g/w4^2;
            tuner(qq,mm) =  params.M4.tune;
           [SYS params] = getsystem2a(params);
           
           
           POLES = sort(unique(abs(pole(SYS))/(2*pi)));
           POLES = POLES(POLES>400); 
           if (POLES(2)-POLES(1))/POLES(1) > 1/params.M4.Q
               [mm qq]
           end
           B_damper = 2*pi*POLES(1)/params.M4.Q;
           peak_thermal_noise(qq,mm) = sqrt(2*kb*T*B_damper*params.M4.Mass/pi)*max(abs(freqresp(SYS(1,5),2*pi*abs(POLES))));
           
            FIBER_10 = abs(freqresp(SYS(3,4),2*pi*10));
               FIBER_MAX = max(abs(freqresp(SYS(3,4),2*pi*abs(POLES))));
               Q_Peak(qq,mm) = FIBER_MAX/ FIBER_10 ; 
           
           %detune damper by 2.5Hz
            params.M4.tune = params.M4.tune  + 2.5;
             w4 = 2*pi*(f4 +  params.M4.tune);
             params.M4.freq = w4/(2*pi); params.M4.Length = g/w4^2;           

            [SYS params] = getsystem2a(params);
            POLES = sort(unique(abs(pole(SYS))/(2*pi)));
            POLES = POLES(POLES>400);
             plus_thermal_noise(qq,mm) = sqrt(2*kb*T*B_damper*params.M4.Mass/pi)*max(abs(freqresp(SYS(1,5),2*pi*abs(POLES))));
             
               FIBER_10 = abs(freqresp(SYS(3,4),2*pi*10));
               FIBER_MAX = max(abs(freqresp(SYS(3,4),2*pi*abs(POLES))));
               Q_Plus(qq,mm) = FIBER_MAX/ FIBER_10 ; 
             
             
             params.M4.tune = params.M4.tune  - 5;
             w4 = 2*pi*(f4 + eps); L4 = g/w4^2;

            [SYS params] = getsystem2a(params);
            POLES = sort(unique(abs(pole(SYS))/(2*pi)));
            POLES = POLES(POLES>400);
            minus_thermal_noise(qq,mm) = sqrt(2*kb*T*B_damper*params.M4.Mass/pi)*max(abs(freqresp(SYS(1,5),2*pi*abs(POLES))));
          
            
               FIBER_10 = abs(freqresp(SYS(3,4),2*pi*10));
               FIBER_MAX = max(abs(freqresp(SYS(3,4),2*pi*abs(POLES))));
               Q_Minus(qq,mm) = FIBER_MAX/ FIBER_10 ; 
       end
       mm
       toc
   end
   toc
   %%
   figure(55)
   pcolor(M_vector,Q_vector ,peak_thermal_noise./FIBER_thermal_noise)
   colorbar
   set(gca,'fontsize',15)
       title('Normalize Thermal noise for a tuned damper ','fontsize',40, 'color',[0.3 0 1],'fontname','Taxidermist II')
    xlabel('Damper Mass in grams','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
     ylabel('Damper Q','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
   
   
     figure(56)
   pcolor(M_vector,Q_vector ,minus_thermal_noise./ FIBER_thermal_noise)
   colorbar
   set(gca,'fontsize',15)
    title('Normalize Thermal noise for a detuned damper (-2.5Hz)','fontsize',40, 'color',[0.3 0 1],'fontname','Taxidermist II')
    xlabel('Damper Mass in grams','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
     ylabel('Damper Q','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
   
   
     figure(57)
   pcolor(M_vector,Q_vector ,plus_thermal_noise./ FIBER_thermal_noise)
      colorbar
   set(gca,'fontsize',15)
     title('Normalize Thermal noise for a detuned damper (+2.5Hz)','fontsize',40, 'color',[0.3 0 1],'fontname','Taxidermist II')
    xlabel('Damper Mass in grams','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
     ylabel('Damper Q','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
   
%%

     figure(58)
   pcolor(M_vector,Q_vector, log10(Q_Peak))
     hhh =  colorbar;
     hhh.Label.String = 'log_{10}(Fiber Q)';
      hhh.FontName = 'Spicy Sushi Roll';
      hhh.Label.FontSize = 33;
     hhh.Label.Color = [0.25 0 1];
     
   set(gca,'fontsize',15)
   title(' Fiber Q for a tuned damper','fontsize',40, 'color',[0.3 0 1],'fontname','Taxidermist II')
    xlabel('Damper Mass in grams','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
     ylabel('Damper Q','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
  %%
     figure(59)
   pcolor(M_vector,Q_vector, log10(Q_Plus))
      hhh =  colorbar;
     hhh.Label.String = 'log_{10}(Fiber Q)';
      hhh.FontName = 'Spicy Sushi Roll';
      hhh.Label.FontSize = 33;
     hhh.Label.Color = [0.25 0 1];
   set(gca,'fontsize',15)
   title('Fiber Q for a detuned damper (-2.5Hz)','fontsize',40, 'color',[0.3 0 1],'fontname','Taxidermist II')
    xlabel('Damper Mass in grams','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
     ylabel('Damper Q','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
%    
%    
%      figure(60)
%    pcolor(M_vector,Q_vector ,log10(Q_Minus))
%       hhh =  colorbar;
%      hhh.Label.String = 'log_{10}(Fiber Q)';
%       hhh.FontName = 'Spicy Sushi Roll';
%       hhh.Label.FontSize = 33;
%      hhh.Label.Color = [0.25 0 1];
%    set(gca,'fontsize',15)
%     title('Fiber Q for a detuned damper (+2.5Hz)','fontsize',40, 'color',[0.3 0 1],'fontname','Taxidermist II')
%     xlabel('Damper Mass in grams','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
%      ylabel('Damper Q','fontsize',30, 'color',[0.3 0.7 0],'fontname','teen spirit')
%    
