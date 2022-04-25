clear; close all; clc
%% Parameters to set 
nu=0.2;         % Poisson's ratio
G=10e9;         % Shear modulus, Pa
L=8192;         % Dimension of the aperture profile, arb units
%%
dh=1;           % Spacing, arb. units
x=(0:dh:L-1);   % distance arbitrary units
%% create the synthetic fracture profile from a sum of sines
Stresses=[0:1:10].*1e6;   % Stress vector, Pa
%Stresses=[0].*1e6;   % Stress vector, Pa
A=[0 1 1];                % amplitudes in units of x
TA=[99.902439024390250 303.407 1000];        % wavelength in units of x
fA=1./TA;                 % calculate frequencies
ai=zeros(1,length(x));     % initiate the profile
for n=1:length(A)
    ai=ai+A(n).*sin(2*pi.*fA(n).*x);    % build the profile
end

%% open data from Tisato et al. 2012, JSG
% Stresses=[0:2:100].*1e6;            % Stress vector, Pa
% load(fullfile('.','JSGpaperSurfaces_RawData','Original_griddata_grit150_XYZ.mat'),'z','y');   
% %load(fullfile('.','JSGpaperSurfaces_RawData','006_griddata_SEM_44_XYZ.mat'),'z','y');
% dh=mean(mean(diff(y)));             % Spacing, arb. units
% %ai=z(fix(end/2),:)./dh;             % Take a profile along x
% ai=z(:,fix(end/2))./dh; ai=ai';     % Take a profile along y
% ai=detrend(ai);                     % Detrend the profile
% ai=ai-mean(ai);                     % Center the profile
% ai=[ai fliplr(-ai)];                % Replicate the profile

%% Square wave
% Stresses=[0:1:20].*1e6;       % Stress vector, Pa
% Ta=200;                       % Period of the square wave
% a0=0.1;                       % Amplitude, arb units
% ai=zeros(1,Ta);               % Initiate the profile
% ai(1:Ta/2)=a0;                  
% ai(Ta/2-1:end)=-a0;

%% Circle wave
% Stresses=[0:25:500].*1e6;     % Stress vector, Pa
% Ta=200;                       % Period of the square wave
% a0=0.1;                       % Amplitude, arb units
% ai=sqrt((Ta/2)^2-[-(Ta/2):(Ta/2)-1].^2);
% ai=[ai -ai].*a0;

%% calculate
ai=repmat(ai,1,fix(2*L/length(ai)));    % extend the profile
ai=ai(1:L);                             % cut the profile to L    
figure(1);
%% loop
for cnt=1:length(Stresses)              % cycle through the stresses
    Stress=Stresses(cnt);               % Stress of cycle cnt, Pa
    %% compute and plot the FFT
    fs=1/mean(diff(x));                     % sampling frequency
    f=fs.*(0:((L/2)-1))/L;                  % frequency vector 
    lam=1./f;                               % wavelength vector
    afft=fft(ai);                           % calculate the FFT
    Ai=abs(afft/L); Ai=2.*Ai(1:L/2);        % amplitude  FFT
    Pi=unwrap(angle(afft)); Pi=Pi(1:L/2);   % phase FFT
    %% plot
    subplot(3,1,1);             % plot profile
    plot(x,ai); hold on
    xlabel('x'); ylabel('y');
    subplot(3,1,2);             % plot FFT amplitude
    semilogx(lam,Ai); hold on
    xlabel('2c'); ylabel('2b');
    subplot(3,1,3);             % plot FFT phase
    semilogx(lam,Pi); hold on
    xlabel('2c'); ylabel('{\phi}');
    %% calculate the deformate amplitudes and wavelengths
    Ao=zeros(1,L/2); Po=Pi;         % initialize the output amplitude, phase
    for n=2:L/2                     % loop through the frequencies
        c0=1/(2*f(n));              % initial length
        b0=Ai(n)/2;                 % initial height
        c(n)=c0.*(1-2*(1-nu)./(3*G*(b0/c0)).*Stress).^(1/2);    % calculate the new half wavelength
        c(n)=real(c(n));            % eliminate the imaginary part of c (when c<0)               
        U=2.*b0.*(c(n)./c0).^3;     % deformed height at x=0, general formula (Mavko, two-dimensional thin crack): U=2.*b0.*(c(n)./c0).^3.*(1-(x0./c(n)).^2).^(3/2);
        b(n)=real(U);               % assign the new height and eliminate the imaginary part of c (when U<0)
        ID=find(1./(2.*f)<=c(n));   % find the FFT peak 
        if ~isempty(ID)
            Ao(ID(1))=Ao(ID(1))+b(n);   % transfer b on the original frequency vector
            Po(ID(1))=Pi(n);            % shift the phase
        end
    end
    %% plot    
    subplot(3,1,2);
    semilogx(lam,Ao); hold off
    subplot(3,1,3);
    semilogx(lam,Po); hold off
    %% calculate iFFT
    Ao=[Ao.*L./2 0 fliplr(Ao(2:end).*L./2)];    % recompose the amplitude
    Po=[Po 0 fliplr(-Po(2:end))];               % recompose the phase
    Ao=Ao.*cos(Po)+1i.*Ao.*sin(Po);             % recompose the complex vector
    ao=ifft(Ao);                                % calculate the inverse FFT
    %% plot
    subplot(3,1,1); 
    plot(x,real(ao));
    title(['{\sigma} = ' num2str(round(Stress/1e6,1)) ' MPa']); hold off
    drawnow
    %% calculate the amplitude
    h(cnt)=2*std(real(ao)).*dh;     % amplitude
    k(cnt)=h(cnt)^2/12;             % permeability
    %% save the animation
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if cnt == 1
        imwrite(imind,cm,'animation.gif','gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,'animation.gif','gif','WriteMode','append');
    end
end
%% show the change of aperture and permeability
figure(2);
yyaxis left
plot(Stresses,h,'-o'); xlabel('{\sigma}, MPa'); ylabel('h');
yyaxis right
semilogy(Stresses,k,'-x'); ylabel('{\kappa}');
grid on
drawnow