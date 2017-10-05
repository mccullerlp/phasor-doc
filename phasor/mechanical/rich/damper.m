
clear
rads = 180/pi;

[SYS params] = getsystem2;

 
dampermass = params.M4.Mass;
damperQ = params.M4.Q;
tune = params.M4.tune;

    f = logspace(log10(450),log10(550),1e6);
    [MAX_A, MAX_F] = findlocalmax(SYS(:,4),[450 550]);  % find peaks for F3, force on fiber
%     for kk = 1:size(MAX_A,1)
%         for zz = 1:size(MAX_A,2)
%             if MAX_F(kk,zz) > 0
%                 III = find(f>MAX_F(kk,zz),1);
%                 df = f(III+1) - f(III);
%                 freq_delta = 1 + 3*df/MAX_F(kk,zz);
%                 TEMP_A = [1 1]; %stupid
%                 TEMP_F = MAX_F(kk,zz);
%                 while length(TEMP_A)>1
%                     ff = logspace(log10(MAX_F(kk,zz)/freq_delta),log10(MAX_F(kk,zz)*freq_delta),1e5);
%                     try
%                         [TEMP_A, TEMP_F] = findmax(SYS(kk,4),ff);  % find peaks for F3, force on fiber
%                     catch
%                         'what'
%                     end
%                     if length(TEMP_A)>1
%                             III = find(ff>MAX_F(kk,zz),1);
%                            df = ff(III+1) - ff(III);
%                           freq_delta = 1 + 3*df/MAX_F(kk,zz);
% %                         freq_delta = 1+(TEMP_F(2) - TEMP_F(1))/(2*TEMP_F(1));  %MIGHT NOT  WORK PROPERLY IF THERE ARE MORE THEN 2 PEAKS
%                     end
%                 end
%                 try
%                 MAX_A(kk,zz) = TEMP_A;
%                 MAX_F(kk,zz) = TEMP_F;
%                 catch
%                     [kk zz]
%                 end
%             end
%         end
%     end
%     
       aSYS = squeeze(freqresp(SYS,2*pi*f));
            FIBER_DC = freqresp(SYS(3,4),0);
            FIBER_10 = abs(freqresp(SYS(3,4),2*pi*10));
            
           color_order
       if 1 == 51 
           figure(1)
           bode(SYS(1,1),SYS(2,1),SYS(3,1),SYS(4,1),2*pi*logspace(log10(0.1),log10(1500),15333))
           h = findobj(gcf,'type','line');
           set(h,'linewidth',3);
           legend('Test Mass','Penultimate Mass','Fiber','Damper')
           title('From Top Motion','fontsize',29, 'color',[0.3 0 1],'fontname',['Wanda','''','s Write'])
           
           grid on
           
           figure(2)
           bode(SYS(1,2),SYS(2,2),SYS(3,2),SYS(4,2),2*pi*logspace(log10(0.1),log10(1500),15333))
           h = findobj(gcf,'type','line');
           set(h,'linewidth',3);
           legend('Test Mass','Penultimate Mass','Fiber','Damper')
           title('From Bottom Force','fontsize',29, 'color',[0.3 0 1],'fontname',['Wanda','''','s Write'])
           grid on
           
           %%
       
           
           %%
           figure(11)
           bode(1e6*SYS(1,1),1e3*SYS(2,1),SYS(3,1),SYS(4,1),2*pi*logspace(log10(499.7),log10(500.3),15333))
           h = findobj(gcf,'type','line');
           set(h,'linewidth',3);
           legend('1e6*Test Mass','1e3*Penultimate Mass','Fiber','Damper')
           title('From Top Motion','fontsize',29, 'color',[0.3 0 1],'fontname',['Wanda','''','s Write'])
           grid on
           
           
           %%
           figure(22)
           bode(SYS(1,2),1e3*SYS(2,2),SYS(3,2)/1000,SYS(4,2),2*pi*logspace(log10(499.7),log10(500.3),15333))
           h = findobj(gcf,'type','line');
           set(h,'linewidth',3);
           legend(' Test Mass','1e3*Penultimate Mass','Fiber/1e3','Damper')
           title('From Bottom Force','fontsize',29, 'color',[0.3 0 1],'fontname',['Wanda','''','s Write'])
           grid on
           
              %%
           figure(33)
           bode(1e6*SYS(1,3),1e3*SYS(2,3),SYS(3,3),SYS(4,3),2*pi*logspace(log10(499.7),log10(500.3),15333))
           h = findobj(gcf,'type','line');
           set(h,'linewidth',3);
           legend('1e6*Test Mass','1e3*Penultimate Mass','Fiber','Damper')
           title('From Penultimate Mass Force','fontsize',29, 'color',[0.3 0 1],'fontname',['Wanda','''','s Write'])
           grid on
                  %%
           figure(44)
           bode( SYS(1,4), SYS(2,4),SYS(3,4),SYS(4,4),2*pi*logspace(log10(0.1),log10(1500 ),15333))
           h = findobj(gcf,'type','line');
           set(h,'linewidth',3);
           legend(' Test Mass',' Penultimate Mass','Fiber','Damper')
           title('From Fiber Mass Force','fontsize',29, 'color',[0.3 0 1],'fontname',['Wanda','''','s Write'])
           grid on
           
           %%
                       %%
           figure(55)
           bode( SYS(1,5), SYS(2,5),SYS(3,5),SYS(4,5),2*pi*logspace(log10(0.1),log10(1500 ),15333))
           h = findobj(gcf,'type','line');
           set(h,'linewidth',3);
           legend(' Test Mass',' Penultimate Mass','Fiber','Damper')
           title('From Damper Mass Force','fontsize',29, 'color',[0.3 0 1],'fontname',['Wanda','''','s Write'])
           grid on
       end
    %%
    fmax = 507; fmin = 493;
    f =  logspace(log10(493),log10(507),30e4);
    fibFTF = squeeze(freqresp(SYS(:,4),2*pi*f));
    %MAXY = max(abs(fibFTF)');
    figure(393)
   HHH =  loglog(f,abs(fibFTF),...
        MAX_F ,MAX_A(1,:),'X',...
        MAX_F ,MAX_A(2,:),'p',...
        MAX_F ,MAX_A(3,:),'h',...
        MAX_F ,MAX_A(4,:),'*',...
        'linewidth',3,...
        'markersize',16);
    
        set(HHH([1 5]),'color',colors(1,:))
    set(HHH([2 6]),'color',colors(2,:))
    set(HHH([3 7]),'color',colors(3,:))
    set(HHH([4 8]),'color',colors(4,:))
    xtext = 500+  15*(fmax -fmin)/100;
     ytext = abs(freqresp(SYS(3,4),2*pi*fmin));  
    text(xtext,100*ytext,['Damper Q is ',num2str(damperQ)],'fontname','I Love Derwin','color',[0.1 0.4 0.2],'fontsize',30,'fontweight','bold')
    text(xtext,10*ytext,['Damper Mass is ',num2str(dampermass),' Kg'],'fontname','I Love Derwin','color',[0.1 0.4 0.2],'fontsize',30,'fontweight','bold')
    text(xtext,1*ytext,['Damper detuning is ',num2str(tune),'Hz'],'fontname','I Love Derwin','color',[0.1 0.5 0.2],'fontsize',30,'fontweight','bold')
    
    legend(['Test Mass  ',num2str(MAX_A(1,:),4)],...
             ['Penultimate Mass  ',num2str(MAX_A(2,:),4)],...
             ['Noramlized Fiber  ',num2str(MAX_A(3,:)/FIBER_10,4)],...
             ['Damper  ',num2str(MAX_A(4,:),4)],'location','nw');
         set(gca,'fontsize',15)
      title('From Fiber Force','fontsize',29,'color',[0.3 0 1],'fontname',['Wanda','''','s Write'])
    grid on
    
 'bob'
 %%
 if 1 == 1
     fmin = 499; fmax = 501;
     f =  logspace(log10(fmin),log10(fmax),30e4);
     fibFTF = squeeze(freqresp(SYS(:,3),2*pi*f)); % from penultimate mass force
     %MAXY = max(abs(fibFTF)');
     figure(394)
     subplot(211)
     HHH =  loglog(f,abs(fibFTF),...
         'linewidth',3,...
         'markersize',16);
     %
               set(HHH([1 ]),'linewidth',4)
                set(HHH([2 ]),'linewidth',6)
     %         set(HHH([2 6]),'color',colors(2,:))
     %         set(HHH([3 7]),'color',colors(3,:))
     %         set(HHH([4 8]),'color',colors(4,:))
     xtext = 500+  15*(fmax -fmin)/100;
     ytext =20*abs(freqresp(SYS(3,3),2*pi*fmin));
     text(xtext,400*ytext,['Damper Q is ',num2str(damperQ)],'fontname','I Love Derwin','color',[0.1 0.4 0.2],'fontsize',30,'fontweight','bold')
     text(xtext,20*ytext,['Damper Mass is ',num2str(dampermass),' Kg'],'fontname','I Love Derwin','color',[0.1 0.4 0.2],'fontsize',30,'fontweight','bold')
     text(xtext,1*ytext,['Damper detuning is ',num2str(tune),'Hz'],'fontname','I Love Derwin','color',[0.1 0.5 0.2],'fontsize',30,'fontweight','bold')
     
     legend(['Test Mass  ',num2str(MAX_A(1,:),4)],...
         ['Penultimate Mass  ',num2str(MAX_A(2,:),4)],...
         ['Noramlized Fiber  ',num2str(MAX_A(3,:)/FIBER_10,4)],...
         ['Damper  ',num2str(MAX_A(4,:),4)],'location','sw');
     set(gca,'fontsize',15)
     title('From Penultimate Mass Force','fontsize',29,'color',[0.3 0 0.6],'fontname',['Waterfalls'])
     grid on
      ylabel('Magnitude','fontname','Mr and Mrs Popsicle','fontsize',33,'color',[1 0.5 0.5])
     
     subplot(212)
     HHH =  semilogx(f,rads*unwrap(angle(fibFTF)),...
         'linewidth',3,...
         'markersize',16);
     grid on
     set(gca,'fontsize',15,'ytick',-1800:45:1800)
     ylabel('Phase','fontname','Mr and Mrs Popsicle','fontsize',33,'color',[1 0.5 0.5])
     xlabel('Frequency (Hz)','fontname','Mr and Mrs Popsicle','fontsize',33,'color',[1 0.5 0.5])
        set(HHH([1 ]),'linewidth',6)
         set(HHH([2 ]),'linewidth',6)
 end
    %% theremal noise from the damper & fiber
    FiberMass = params.M3.Mass;
    FiberQ = params.M3.Q;
    if 1 == 1
         fmin = 10; fmax = 2000;
     f =  logspace(log10(fmin),log10(fmax),30e4);
     II = find(f>100,1);
     w = 2*pi*f;
        kb = 1.38e-23; %m^2 kg/s^2 Kelvin
        T = 300;
        w0 = 2*pi*(500+tune);
        B_damper = w0/damperQ;
        Dampermotion = sqrt(2*kb*T*B_damper./(pi*dampermass*((w0^2-w.^2).^2 + B_damper^2*w.^2)));   
        DamperForce = abs(squeeze(freqresp(SYS(4,5),2*pi*f))); % damper force to damper motions tf
        
        B_Fiber =  w0/FiberQ;
        Fibermotion = sqrt(2*kb*T*B_Fiber./(pi*FiberMass*((w0^2-w.^2).^2 + B_Fiber^2*w.^2)));   
        FiberForce = abs(squeeze(freqresp(SYS(4,4),2*pi*f)));  %fiber force to fiber motion tf
       % DamperForce = Dampermotion(II)*DamperForce/DamperForce(II);
        DamperForce =  sqrt( 2*kb*T*B_damper*dampermass/pi)*DamperForce;
        FiberForce =  sqrt( 2*kb*T*B_Fiber*FiberMass/pi)*FiberForce;
        
        TestMass_damper =  sqrt( 2*kb*T*B_damper*dampermass/pi)*abs(squeeze(freqresp(SYS(1,5),2*pi*f)));
        TestMass_Fiber =  sqrt( 2*kb*T*B_Fiber*FiberMass/pi)*abs(squeeze(freqresp(SYS(1,4),2*pi*f)));
        POLL = pole(SYS(1,5));
         POLL = POLL(abs(POLL) >100);
        MAX_damper = sqrt( 2*kb*T*B_damper*dampermass/pi)*max(abs(freqresp(SYS(1,5),abs(POLL))));
        MAX_Fiber = sqrt( 2*kb*T*B_Fiber*FiberMass/pi)*max(abs(freqresp(SYS(1,4),abs(POLL)))) 
        figure(123)
         loglog(f,Dampermotion ,...
                f,DamperForce  ,...
                f, TestMass_damper ,...
                500,MAX_damper,'*',...
                f, TestMass_Fiber ,...
                500,MAX_Fiber,'p',...
                'linewidth',3,...
                'markersize',16)
            
         grid on
         legend('Motion from kT','Motion from Force','On Test Mass','','Test mass thermal motion from Fiber','')
             set(gca,'fontsize',15,'XLim',[fmin fmax],'YLim',[1e-30 1e-10])
             title('Thermal Noise from Damper','fontsize',29,'color',[0.3 0 0.6],'fontname',['El&Font'])
             ylabel('Meters/rtHz','fontname','Mr and Mrs Popsicle','fontsize',33,'color',[1 0.5 0.5])
%              sqrt(kb*T/(dampermass))
%              sqrt(2*kb*T*B/pi)
             text(20,1e-26,['Thermal Noise Damper/Termal Nose FIber at the peak is ',num2str(MAX_damper/MAX_Fiber,2) ],'fontname','I Love Derwin','color',[0.8 0.5 0.7],'fontsize',30,'fontweight','bold')
             
           sqrt((params.M3.Q/params.M4.Q)*(dampermass/FiberMass))*(2*pi*1.3/w0)^2
             
    end
        