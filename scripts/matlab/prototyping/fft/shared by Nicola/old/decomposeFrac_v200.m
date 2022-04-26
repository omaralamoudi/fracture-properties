clear
close all
clc
nu=0.2;
mu=10e9;
Pall=[0:2:100].*1e6;
L=8192;
x=[0:L-1]; %distance arbitrary units
A=[1 1 1];    %amplitudes in units of x
TA=[10 30 100]; %wavelength in units of x
fA=1./TA;

% %% create the synthetic fracture profile
% a=zeros(1,length(x));
% for n=1:length(A)
%     a=a+A(n).*sin(2*pi.*fA(n).*x);
% end

% %% open data
% load('.\JSGpaperSurfaces_RawData\Original_griddata_grit150_XYZ.mat','z','y');
% dh=mean(mean(diff(y)));
% %a=z(fix(end/2),:)./dh;
% a=z(:,fix(end/2))./dh; a=a'; 

% load('.\JSGpaperSurfaces_RawData\006_griddata_SEM_44_XYZ.mat','z','y');
% dh=mean(mean(diff(y)));
% a=z(fix(end/2),:)./dh;
% a=z(:,fix(end/2))./dh; a=a'; 

a=zeros(1,100);
a(1:50)=1;
a(51:end)=-1;

a=detrend(a);
a=a-mean(a);
a=[a fliplr(-a)];
a=repmat(a,1,fix(2*L/length(a)));
a=a(1:L);
%% loop
for cnt=1:length(Pall)
    P=Pall(cnt);
    figure(1);
    subplot(3,1,1);
    plot(x,a); hold on
    xlabel('x');
    ylabel('y');
    %% compute the FFT
    afft=fft(a);
    aa=abs(afft/L);
    aa=2.*aa(1:L/2);
    pp=angle(afft);
    pp=pp(1:L/2);
    fs=1/mean(diff(x));
    f=fs.*(0:((L/2)-1))/L;
    lam=1./f;
    subplot(3,1,2);
    semilogx(lam,aa); hold on
    xlabel('2c');
    ylabel('b');
    subplot(3,1,3);
    semilogx(lam,pp); hold on
    xlabel('2c');
    ylabel('{\phi}');
    aao=zeros(1,L/2);
    ppo=zeros(1,L/2);
    %% calculate the deformate amplitudes and wavelengths
    for n=2:L/2
        c0=1/(2*f(n));  % initial length
        b0=aa(n);       % initial height
        c(n)=c0.*(1-2*(1-nu)./(3*mu*(b0/c0)).*P).^(1/2);
        c(n)=real(c(n));
        x0=0;
        if c(n)==0
            U=0;
        else
            U=2.*b0.*(c(n)./c0).^3.*(1-(x0./c(n)).^2).^(3/2); % deformed height
        end
        b(n)=U/2;
        b(n)=real(b(n));
        %% interpolate b on the original frequency
        ID=find(1./(2.*f)<=c(n));
        l=1./(2.*c(n))-f(ID(1)-1);
        i=f(ID(1))-1./(2.*c(n));
        il=i+l;
        aao(ID(1))=aao(ID(1))+b(n)*(il-i)/il;
        aao(ID(1)-1)=aao(ID(1))+b(n)*(il-l)/il;
        %% shift the phase
        ppo(ID(1))=ppo(ID(1))+pp(n);
    end
    aao=[0 diff(aao)];
    ppo=[0 diff(ppo)];
    subplot(3,1,2);
    semilogx(lam,aao); hold off
    subplot(3,1,3);
    semilogx(lam,ppo); hold off
    %% calculate iFFT
    aad=[aao.*L./2 0 fliplr(aao(2:end).*L./2)];
    ppd=[ppo 0 fliplr(-ppo(2:end))];
    aao=aad.*cos(ppd)+1i.*aad.*sin(ppd);
    ao=ifft(aao);
    subplot(3,1,1);
    plot(x,real(ao));
    title(['P = ' num2str(round(P/1e6,1)) ' MPa']); hold off
    drawnow
    h(cnt)=2*std(real(ao));
    k(cnt)=h(cnt)^2/12;
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if cnt == 1
        imwrite(imind,cm,'animation.gif','gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,'animation.gif','gif','WriteMode','append');
    end
end
figure(2);
yyaxis left
plot(Pall,h,'o');
xlabel('P, MPa');
ylabel('h');
yyaxis right
plot(Pall,k,'x');
xlabel('P, MPa');
ylabel('{\kappa}');
grid on
drawnow