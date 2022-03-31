%D. Maugis, Stresses and displacements around cracks and elliptical cavities: Exact solutions, Engineering Fracture Mechanics, Volume 43, Issue 2, September 1992, Pages 217-255, ISSN 0013-7944, http://dx.doi.org/10.1016/0013-7944(92)90123-V.
%(http://www.sciencedirect.com/science/article/pii/001379449290123V)

%uniform load beta=0;

clear all
close all
clc
format long e
%% physical state
plane_stress    =   0;                  %plane stress or plane strain
sgm_11          =   -18;                  %Stress Sigma_11 [MPa]
sgm_22          =   -16;                 %Stress Sigma_22 [MPa]
v               =   0.3;                %Poisson's ratio
mu              =   5000;           %shear modulus [GPa]
beta            =   pi/2;               %elipsoid inclination [rad]
alpha           =   0.1;                %aspect ratio
sgm             =   sgm_11;             %Maximum stress [MPa]
k               =   sgm_22/sgm_11;      %Stress ratio
a               =   1;                  %major axis of elipsoid dimension [m]
b               =   a*alpha;            %minor axis of elipsoid dimension [m]
Ar              =   pi*a*b;             %area [m2]
if plane_stress == 1
    K=(3-v)./(1+v);                     %plane stress
else
    K=3-4.*v;                           %plane strain
end
%% define the elliptical coordinates
c       =   sqrt(a^2-b^2);              %eq. 7 
xi0     =   acosh(a/c);                         %~eq. 6 or xi0   =   asinh(b/c);
NU      =   [0:(2.*pi)./100:2.*pi];     %nu variable 0<nu<360 
XI      =   linspace(xi0,4,101);        %xi>0
[nu,xi] =   meshgrid(NU,XI);            %2D matrix of nu and xi
%% define cartesian coordinates
xx      =   c.*cosh(xi).*cos(nu);       %eq. 3
yy      =   c.*sinh(xi).*sin(nu);       %eq. 4
xx_r    =   xx.*cos(pi/2-beta) -yy.*sin(pi/2-beta); %rotation of the cartesian coordinates
yy_r    =   xx.*sin(pi/2-beta) +yy.*cos(pi/2-beta); %rotation of the cartesian coordinates
%% solve 
X       =   xx./c;                              %eq. A1
Y       =   yy./c;                              %eq. A1
Delta   =   (X.^2+Y.^2+1).^2-4.*X.^2;           %eq. A1

lambda  =   1./(cosh(2.*xi)-cos(2.*nu));        %eq.28
m       =   1+k;                                %eq. 22-23
n       =   1-k;
A       =   m-n.*exp(2.*xi0).*cos(2.*beta);     %eq. 29
B       =   n.*exp(2.*xi0).*cos(2.*beta);       %eq. 30
C       =   n.*exp(2.*xi0).*sin(2.*beta);       %eq. 31
sgm_a   =   sgm.*(B+lambda.*(A.*sinh(2.*xi)-C.*sin(2.*nu)));                           %eq.23
sgm_b   =   sgm.*(-lambda.*(cosh(2.*(xi-xi0))-1).*(B.*cos(2.*nu)+C.*sin(2.*nu))...
    +lambda.*(cosh(2.*xi0)-cos(2.*nu)).*(B+lambda.*(A.*sinh(2.*xi)-C.*sin(2.*nu))));    %eq.24
tau_xinu  =   sgm./2.*(-(C+lambda.*B.*sin(2.*nu)).*sinh(2.*(xi-xi0))+lambda.*C.*sinh(2.*xi).*(cosh(2.*(xi-xi0))-1)...
    +lambda.^2.*(cosh(2.*xi)-cosh(2.*xi0)).*(A.*sin(2.*nu)+C.*sinh(2.*xi)));                 %eq.25
sgm_xi  =   (sgm_a-sgm_b)./2;                                                         %calculate stress perpend of xi 
sgm_nu  =   sgm_a-sgm_xi;                                                             %calculate stress perpend of nu 
sgm_1   =   (sgm_xi+sgm_nu)./2+(((sgm_xi-sgm_nu)./2.).^2+tau_xinu.^2).^(1/2);         %eq.32
sgm_2   =   (sgm_xi+sgm_nu)./2-(((sgm_xi-sgm_nu)./2.).^2+tau_xinu.^2).^(1/2);         %eq.32
sgm_z   =   v.*(sgm_xi+sgm_nu);
sgm_eq  =   sqrt(((sgm_1-sgm_2).^2+(sgm_2-sgm_z).^2+(sgm_z-sgm_1).^2)./2);
tau_m   =   (sgm_1-sgm_2)./2;
u_x     =   sgm.*c./(8.*mu).*((K+1).*(A.*sinh(xi).*cos(nu)+B.*cosh(xi).*cos(nu)+C.*exp(-xi).*sin(nu))...
    -4.*sinh(xi-xi0).*sinh(xi0).*(B.*cos(nu)+C.*sin(nu))...
    -2.*lambda.*(cosh(2.*xi)-cosh(2.*xi0)).*(A.*sinh(xi).*cos(nu)-C.*cosh(xi).*sin(nu)));
u_y     =   sgm.*c./(8.*mu).*((K+1).*(A.*cosh(xi).*sin(nu)+B.*sinh(xi).*sin(nu)+C.*exp(-xi).*cos(nu))...
    -4.*sinh(xi-xi0).*cosh(xi0).*(B.*sin(nu)-C.*cos(nu))...
    -2.*lambda.*(cosh(2.*xi)-cosh(2.*xi0)).*(A.*cosh(xi).*sin(nu)+C.*sinh(xi).*cos(nu)));

u_x_r   =   u_x.*cos(pi/2-beta) -u_y.*sin(pi/2-beta); %rotation of the displacement quiver
u_y_r   =   u_x.*sin(pi/2-beta) +u_y.*cos(pi/2-beta); %rotation of the displacement quiver
ind     =   [1:3:numel(xx)];
%% calculate the new area
S       =   sgm.*(K+1)./(8.*mu);
a_p     =   a.*(1+S.*n.*cos(2.*beta))+b.*S.*(m+n.*cos(2.*beta));    %new major axis
b_p     =   b.*(1-S.*n.*cos(2.*beta))+a.*S.*(m-n.*cos(2.*beta));    %new major axis
Ar_p    =   pi.*a_p.*b_p;
eps     =   (Ar_p-Ar)./Ar
%% plot
figure
set(gcf,'position',[100 50 600 600]);
axes
contourf(xx_r,yy_r,sgm_1./sgm,16);
set(gca,'position',[0.07 0.6 0.4 0.32],'xlim',[-2 2],'ylim',[-2 2]);
title('\sigma_1/\sigma');
shading flat
colorbar
axes
contourf(xx_r,yy_r,sgm_2./sgm,16);
shading flat
set(gca,'position',[0.57 0.6 0.4 0.32],'xlim',[-2 2],'ylim',[-2 2]);
title('\sigma_2/\sigma');
colorbar
axes
contourf(xx_r,yy_r,tau_m./sgm,16);
shading flat
set(gca,'position',[0.07 0.12 0.4 0.32],'xlim',[-2 2],'ylim',[-2 2]);
title('isochromatic');
colorbar
axes
quiver(xx_r(ind),yy_r(ind),u_x_r(ind),u_y_r(ind));
shading flat
set(gca,'position',[0.57 0.09 0.4 0.4],'xlim',[-2 2],'ylim',[-2 2]);
title('displacement');

