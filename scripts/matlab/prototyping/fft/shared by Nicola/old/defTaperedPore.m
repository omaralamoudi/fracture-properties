clear 
close all
clc

c0=1;
nu=0.2;
mu=10e9;
P=[0:20e6:160e6];
b=0.01;

c=c0.*(1-2*(1-nu)./(3*mu*(b/c0)).*P).^(1/2);

for n=1:length(c)
    %x=linspace(-c0,c0,512);
    %x=linspace(-c(n),c(n),512);
    x=[-c(n):0.01:c(n)];
    U=2.*b.*(c(n)./c0).^3.*(1-(x./c(n)).^2).^(3/2);
    U=real(U);
    Ufft=[U -U];
    Ufft=repmat(Ufft,1,fix(8192/length(x)));
    Ufft=Ufft([1:4096]);
    u(n,:)=fft(Ufft)./length(U);
    subplot(3,1,1);
    plot(Ufft); hold on
    subplot(3,1,2);
    semilogx(abs(u(n,:))); hold on
    subplot(3,1,3);
    semilogx((angle(u(n,:)))); hold on
end
figure
plot((1+abs(u(1,:)))./(1+abs(u(end,:))))
figure
plot((1+1i+u(1,:))./(1+1i+u(end,:)+1))
figure
plot3([0:4095],real(u(1,:)),imag(u(1,:)))
figure
plot(abs(u(1,:))./max(abs(u(1,:)))); hold on
plot(abs(u(end,:))./max(abs(u(end,:))));
