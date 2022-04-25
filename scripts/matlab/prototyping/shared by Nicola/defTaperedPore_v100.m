clear 
close all
clc
L=32768;
c0=1;
nu=0.2;
mu=10e9;
P=[0:40e6:160e6];
b=0.01;

c=c0.*(1-2*(1-nu)./(3*mu*(b/c0)).*P).^(1/2);

for n=1:length(c)
    x=[-c(n):0.01:c(n)];
    U=2.*b.*(c(n)./c0).^3.*(1-(x./c(n)).^2).^(3/2);
    U=max(U).*sin(2.*pi./(4*c(n)).*(x+c(n)));
    U=real(U);
    U=[U -U];
    U=repmat(U,1,fix(L/length(U)));
    Ufft(n,:)=U(1:L/2);
    u=fft(Ufft(n,:))./length(Ufft(n,:));
    subplot(3,1,1);
    plot(Ufft(n,:)); hold on
    subplot(3,1,2);
    semilogx(abs(u)); hold on
    subplot(3,1,3);
    semilogx((angle(u))); hold on
end

