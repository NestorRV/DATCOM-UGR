%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 3
%{
Realizar sobre la imagen barbara una descomposición wavelet usando bior3.7 
con tres niveles. Fijado un porcentaje, por ejemplo 10 %, que indican el 
porcentaje de coeficientes que nos quedamos de entre todos los coeficientes
wavelets de la descomposición. Estos coeficientes son los que tiene 
mayor magnitud. 
Variar el procentaje y obtener una grafica en la que en el eje X tenemos 
razon de compresión y en el eje Y el valor de PSNR.
%}

I = imread('barbara.png');

I_10 = wavelet(I, 0.10);
I_50 = wavelet(I, 0.50);
I_99 = wavelet(I, 0.99);

figure, subplot(2,2,1), imshow(I, []), title('Original'), ...
    subplot(2,2,2), imshow(I_10, []), title('10%'), ...
    subplot(2,2,3), imshow(I_50, []), title('50%'), ...
    subplot(2,2,4), imshow(I_99, []), title('99%');

[PSNR_10,~,~,~] = measerr(I, I_10);
[PSNR_50,~,~,~] = measerr(I, I_50);
[PSNR_99,~,~,~] = measerr(I, I_99);

x = [10; 50; 99];
y = [PSNR_10; PSNR_50; PSNR_99];

figure, plot(x, y);

% Cómo podemos ver en el plot, no hay mucha diferencia entre usar el 10% de
% los coeficientes o usar el 50% pero si la hay entre usar el 50% o usar el
% 99%.

function I_reconstruida = wavelet(I, porcentaje)
    [C,S] = wavedec2(I, 3, 'bior3.7');
    % Cogemos el valor absoluto ya que queremos coger los de mayor magnitud
    [~, idx] = sort(abs(C), 'descend');
    part_idx = idx(ceil(length(idx) * porcentaje):length(idx));
    C(part_idx) = 0;
    I_reconstruida = waverec2(C,S,'bior3.7');
end