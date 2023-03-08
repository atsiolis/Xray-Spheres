% Parameters
n = 256; % image size
d1 = 50; % diameter of first sphere
x1 = -32; % x-coordinate of center of first sphere
y1 = 0; % y-coordinate of center of first sphere
d2 = 24; % diameter of second sphere
x2 = 52; % x-coordinate of center of second sphere
y2 = 0; % y-coordinate of center of second sphere
mu_sphere1 = 0.015; % absorption coefficient of spheres in mm^-1
mu_sphere2 = 0.005;
mu_image = 0.01; % absorption coefficient of image
N = 1000; % number of photons

% Create x-ray grid
[X,Y] = meshgrid(-n/2:n/2-1, -n/2:n/2-1);
Z = zeros(size(X));

% Compute projection of first sphere onto x-ray grid
R1 = sqrt((X-x1).^2 + (Y-y1).^2 + Z.^2);
F1 = R1 - d1/2;

% Compute projection of second sphere onto x-ray grid
R2 = sqrt((X-x2).^2 + (Y-y2).^2 + Z.^2);
F2 = R2 - d2/2;

% Compute x-ray intensity at each point
I1 = double(F1 < 0);
I2 = double(F2 < 0);
I3 = ones(256)-I1-I2;

%Fix shpere heights 
F1=2*abs(F1);
F2=2*abs(F2);

% Compute attenuation due to absorption in spheres
I1 = I1 .* (N*exp(-mu_sphere1*F1-mu_image*(128-F1)));
I2 = I2 .* (N*exp(-mu_sphere2*F2-mu_image*(128-F2)));


% Compute attenuation due to absorption in image
I3=(I3.*(N*exp(-mu_image*128)));


% Add intensities of both spheres
I = I1 + I2 + I3;

%Add noise
noise = sqrt(I) .* randn(size(I));
J = I + noise;


% Display images
figure
subplot(1,2,1);
imshow(I,[])
title('X-ray image without noise')

subplot(1,2,2);
imshow(J,[])
title('X-ray image with noise')
