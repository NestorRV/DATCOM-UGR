%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 2
%{
Eliminación de ruido. Sobre la imagen cameraman insertar ruido gaussiano y 
mirar que componentes frecuenciales habría que eliminar para reducir el 
mayor ruido posible.
%}

I = imread('cameraman.tif');
% Ruido gaussiano con media 0 y varianza 0.02
I_noise = im2double(imnoise(I,'gaussian',0,0.02));

% Filtro paso bajo ideal
radius = 35;
H = zeros(size(I_noise,1),size(I_noise,2));
ind = ind2sub(size(H), find(dist <= radius));
H(ind) = 1;
Hd = fftshift(double(H));
I_dft = fft2(im2double(I_noise));
DFT_filt = Hd.*I_dft;
ideal_bajo = real(ifft2(DFT_filt));

% Filtrado paso bajo con una Gaussiana
mi = size(I_noise,1)/2;
mj = size(I_noise,2)/2;
x = 1:size(I_noise,2);
y = 1:size(I_noise,1);
[Y, X] = meshgrid(y-mi,x-mj);
dist = hypot(X,Y);

sigma = 30;
H_gau = exp(-(dist.^2)/(2*(sigma^2)));
Id = im2double(I_noise);
I_dft = fft2(Id);

DFT_filt_gau = fftshift(H_gau).*I_dft;
gaus_bajo = real(ifft2(DFT_filt_gau));

% Con Butterworth 
D0 = 35; n = 3;
H_but = 1./(1+(dist./D0).^(2*n));
DFT_filt_but = fftshift(H_but).*I_dft;
butterworth_bajo = real(ifft2(DFT_filt_but));

% Filtrado paso alto Filtro Ideal
radius = 35;
H = ones(size(I_noise,1),size(I_noise,2));
ind = ind2sub(size(H), find(dist <= radius));
H(ind) = 0;
Hd = fftshift(double(H));

% Filtro Paso Alto Gaussiana
sigma  = 30;
H_gau = 1-exp(-(dist.^2)/(2*(sigma^2)));
Id = im2double(I_noise);
I_dft = fft2(Id);
DFT_filt_gau = fftshift(H_gau).*I_dft;
gaus_alto = real(ifft2(DFT_filt_gau));

% Filtro Paso Alto Butterworth
D0 = 35; n = 3;
H_but = 1./(1+(D0./dist).^(2*n));

DFT_filt_but = fftshift(H_but).*I_dft;
butterworth_alto = real(ifft2(DFT_filt_but));

figure, subplot(2,4,1), imshow(I,[]), title('Original'), ...
    subplot(2,4,2), imshow(I_noise), title('Ruido'), ...
    subplot(2,4,3), imshow(ideal_bajo,[]), ...
        title('Filtro Paso bajo ideal'), ...
    subplot(2,4,4), imshow(gaus_bajo), ...
        title('Filtrado paso bajo con una Gaussiana'), ...
    subplot(2,4,5), imshow(butterworth_bajo), ...
        title('Paso Bajo: Butterworth'), ...
    subplot(2,4,6), imshow(gaus_alto), ...
        title('Filtro Paso Alto Gaussiana'), ...
    subplot(2,4,7), imshow(butterworth_alto), ...
        title('Filtro Paso Alto Butterworth');


%{
Realmente nos hubiese bastqado con aplicar un filtro de paso bajo. 
Dichos filtros atenuan las frecuencias altas. En teoría vimos que 
dichos filtros eran útiles si hay cambios radicales en el ruido y
esa es justo la situación que tenemos.
%}