%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 3
%{
Usa imadjust para aplicar la siguiente función de transferencia a la imagen
campo.ppm.
%}

I = imread('p3_imagenes/campo.ppm');

new_I=imadjust(I, [0.43,0.75], [], 0.75);

figure, subplot(1,2,1), imshow(I), title('Original'), ...
    subplot(1,2,2), imshow(new_I), ...
    title('Función transferencia aplicada');

% Este ejecicio también se puede resolver tal y como hemos hecho en clase de teoría,
% calcular las rectas y aplicar las funciones de cada recta.
% https://www.dfstudios.co.uk/articles/programming/image-programming-algorithms/image-processing-algorithms-part-6-gamma-correction/

gamma = 0.75;
gammaCorrection = 1 / gamma;

transfer_I = I;
for ii = 1:size(I, 1)
    for jj = 1:size(I, 2)
        pixel = I(ii, jj);
        if pixel <= 110
            transfer_I(ii, jj) = 0;
        elseif pixel >= 190
            transfer_I(ii, jj) = 255;
        else
            transfer_I(ii, jj) = 255.0 * (double(pixel) / 255.0) ...
                .^ gammaCorrection;
        end
    end
end

figure, subplot(1,2,1), imshow(I), title('Original'), ...
    subplot(1,2,2), imshow(transfer_I), ...
    title('Función transferencia aplicada');