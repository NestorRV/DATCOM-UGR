%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 1
%{
Mostrar las componentes frecuenciales que entran en un disco de centro u, v 
y radio r. Visualizar diferentes discos cambiando el centro y radio.
%}

fourier(320, 320, 5)
fourier(0, 0, 15)
fourier(100, 500, 20)

% (u,v) centro
% radio
function fourier(u, v, radio)
    sizeX = 640;
    sizeY = 640;
    
    [columnas, filas] = meshgrid(1:sizeX, 1:sizeY);
    % Creamos el círculo como una matrix 2D booleana
    I = (filas - v).^2 + (columnas - u).^2 <= radio.^2;

    Id=im2double(I); 
    ft_shift =fftshift(fft2(Id));

    freal = real(ft_shift);
    fimg = imag(ft_shift);

    figure, subplot(2,2,1),imshow(freal,[]), title ('Real'), ...
        subplot(2,2,2), imshow(fimg,[]), title('Imaginaria'), ...
        subplot(2,2,3), imshow(log(1+abs(ft_shift)),[]), ...
            title('Log Modulo'), ...
        subplot(2,2,4), imshow((angle(ft_shift))), title('Fase');
end