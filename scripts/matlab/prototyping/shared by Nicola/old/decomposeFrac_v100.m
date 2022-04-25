clear
close all
clc
nu=0.2;
mu=10e9;
P=1
;
L=8192;
x=[0:L-1]; %distance arbitrary units
A=[1 3 10];    %amplitudes in units of x
TA=[100 300 1000]; %wavelength in units of x
fA=1./TA;

%% create the synthetic fracture profile
a=zeros(1,length(x));
for n=1:length(A)
    a=a+A(n).*sin(2*pi.*fA(n).*x);
end
figure;
subplot(2,1,1);
plot(x,a); hold on
xlabel('x');
ylabel('y');
%% compute the FFT
afft=fft(a);
aa=abs(afft/L);
aa=2.*aa(1:L/2);
fs=1/mean(diff(x));
f=fs.*(0:((L/2)-1))/L;
lam=1./f;
subplot(2,1,2);
semilogx(lam,aa); hold on
xlabel('2c');
ylabel('b');
aao=zeros(1,L/2);
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
    aao(ID)=aao(ID)+b(n);
end
aao=[0 diff(aao)];
subplot(2,1,2);
semilogx(lam,aao);

%% calculate iFFT
aad=[aao.*L./2 0 fliplr(aao(2:end).*L./2)];
%aad=[aa.*L./2 0 fliplr(aa(2:end).*L./2)];
aao=aad.*cos(angle(afft))+1i.*aad.*sin(angle(afft));
ao=ifft(aao);
subplot(2,1,1);
plot(x,real(ao));
