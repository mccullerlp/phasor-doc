function [SYS params] = getsystem2

% three masses in series with one mass hanging off of the top mass, no independent Tension paramaeter

density_glass = 2.2e3;   %kg/m^3
g = 9.8;

   Q3 = 1e9; f3 = 500; %fiber 
   w3 = 2*pi*f3;
   M3 = density_glass*pi*200e-6^2*0.5;
   
   
M1 = 40; L1 =   g*(2*M1+M3)/(M3*w3^2); Q1 = 1e7;  %test mass
w1 = sqrt(g/L1); f1 = w1/(2*pi);

 
M2 = 40; L2 = 0.4; Q2 = 1e4;  %penultimate mass
w2 = sqrt(g/L2); f2 = w2/(2*pi);
 

M4 = 0.025e-0;  Q4 = 100;eps = -0.312;  f4 = 500;% damper

% M4 = 0.025e-10;  Q4 = 10000;eps = -10.312;  f4 = 500;% detuned damper


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



Mt = M1+M2+M3 +M4;
%gamma = w0/Q
 
% M4 = 1e-6; Q3 = 1;
% M3 = 1e-6;  

%     %  x1               dx1/dt        x2                                            dx2/dt        x3                       dx3/dt             x4            dx4/dt
% A = [  0                  1           0                                                0           0                          0             0               0;    %dx1/dt
%      -g/L1              -w1/Q1        0                                                0         g/L1                         0             0               0;    % d^2(x1)/dt^2
%        0                  0           0                                                1           0                          0             0               0;    % dx2/dt
%        0                  0     -(g/M2)*((M1+M3)/L3 + M4/L4 + MT/L2)                -w2/Q2     g*(M3+M1)/(L3*M2)              0         g*M4/(L4*M2)        0;    % d^2(x2)/dt^2
%        0                  0           0                                                0           0                          1             0               0;    % dx3/dt
%      g*(M1/M3)/L1         0        (g/M3)*(M1+M3)/L3                                   0    -(g/M3)*(((M3+M1)/L3) + M1/L1)    -w3/Q3        0               0;    % d^2(x3)/dt^2
%        0                  0           0                                                0           0                          0             0               1;    % dx3/dt
%        0                  0          g/L4                                              0           0                          0            -g/L4       -w4/Q4];   % d^2(x4)/dt^2
  %     %  x1               dx1/dt        x2                                            dx2/dt        x3                       dx3/dt             x4            dx4/dt 
   A = [  0                  1           0                                                0           0                          0             0               0;    %dx1/dt
     -g/L1              -w1/Q1        0                                                0         g/L1                         0             0               0;    % d^2(x1)/dt^2
       0                  0           0                                                1           0                          0             0               0;    % dx2/dt
       0                  0     -(g/M2)*((M1+M3)/L3 + M4/L4 + Mt/L2)                -w2/Q2     g*(M3+M1)/(L3*M2)              0         g*M4/(L4*M2)        0;    % d^2(x2)/dt^2
       0                  0           0                                                0           0                          1             0               0;    % dx3/dt
     g*(M1/M3)/L1         0        (g/M3)*(M1+M3)/L3                                   0    -(g/M3)*(((M3+M1)/L3) + M1/L1)    -w3/Q3        0               0;    % d^2(x3)/dt^2
       0                  0           0                                                0           0                          0             0               1;    % dx3/dt
       0                  0          g/L4                                              0           0                          0            -g/L4       -w4/Q4];   % d^2(x4)/dt^2

   
   
   
   
       %x0                       F1      F2   F3  F4
   B = [0                         0     0    0    0;
        0                        1/M1   0    0    0;
        0                         0     0    0    0;
       g*Mt/(L2*M2)               0    1/M2  0    0;
        0                         0     0    0    0;
        0                         0     0   1/M3  0;
        0                         0     0    0    0;
        0                         0     0    0  1/M4];
    
    C = [1  0  0  0  0  0  0  0;
         0  0  1  0  0  0  0  0;
         0  0  0  0  1  0  0  0;
         0  0  0  0  0  0  1  0];
    D = [];
    
    SYS = ss(A,B,C,D);
    
%     sqrt(g/(L1+L3+L2))/(2*pi)
return