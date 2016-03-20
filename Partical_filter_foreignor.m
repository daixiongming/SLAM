clc
clear all
close all
 
% Particle filter example, adapted from Gordon, Salmond, and Smith paper.
 
x = 0.1; % initial state
Q = 1; % process noise covariance
R = 1; % measurement noise covariance
tf = 50; % simulation length
 
N = 200; % number of particles in the particle filter
 
xhat = x;
P = 2;
xhatPart = x;
 
% Initialize the particle filter.
for i = 1 : N
    xpart(i) = x + sqrt(P) * randn;
end
 
xArr = [x];
yArr = [x^2 / 20 + sqrt(R) * randn];
xhatArr = [x];
PArr = [P];
xhatPartArr = [xhatPart];
                                        
for k = 1 : tf
    % System simulation
    x = 0.5 * x + 25 * x / (1 + x^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn;%���䨬?��?3��
    y = x^2 / 20 + sqrt(R) * randn;%1?2a��?3��
    % Particle filter
    for i = 1 : N
        xpartminus(i) = 0.5 * xpart(i) + 25 * xpart(i) / (1 + xpart(i)^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn;
        ypart = xpartminus(i)^2 / 20;
        vhat = y - ypart;%1?2ao��?��2a��?2?
        q(i) = (1 / sqrt(R) / sqrt(2*pi)) * exp(-vhat^2 / 2 / R);
    end
    % Normalize the likelihood of each a priori estimate.
    qsum = sum(q);
    for i = 1 : N
        q(i) = q(i) / qsum;%1����??������??
    end
    % Resample.
    for i = 1 : N
        u = rand; % uniform random number between 0 and 1
        qtempsum = 0;
        for j = 1 : N
            qtempsum = qtempsum + q(j);
            if qtempsum >= u
                xpart(i) = xpartminus(j);
                break;
            end
        end
    end
    % The particle filter estimate is the mean of the particles.
    xhatPart = mean(xpart);
 
    % Save data in arrays for later plotting
    xArr = [xArr x];
    yArr = [yArr y];
    xhatPartArr = [xhatPartArr xhatPart];
end
 
t = 0 : tf;
figure;
plot(t, xArr, 'b.', t, xhatPartArr, 'k-');
set(gca,'FontSize',12); set(gcf,'Color','White');
xlabel('time step'); ylabel('state');
legend('True state', 'Particle filter estimate');
 
xhatPartRMS = sqrt((norm(xArr - xhatPartArr))^2 / tf);
disp(['Particle filter RMS error = ', num2str(xhatPartRMS)]); 