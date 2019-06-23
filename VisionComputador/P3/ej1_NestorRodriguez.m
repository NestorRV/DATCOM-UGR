%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 1
%{
Cargar la imagen mujer.jpg y realiza las siguientes operaciones:
    1.1: Mejora el contraste usando únicamente operaciones 
        aritméticas (+, -, *, /).
    1.2: Usa imadjust para mejorar el contraste. Usa la función stretchlim.
    1.3: Usa imadjust para aplicar una función de transferencia de tipo 
        gamma. Comprueba el efecto que produce la transformación en la 
        imagen y en el histograma.
    1.4 Usa imadjust para aplicar la siguiente función de transferencia:
    1.5: Finalmente, ecualiza la imagen.
%}

I = imread('p3_imagenes/mujer.jpg');

% 1.1
figure, subplot(1,5,1), imshow(I), title('Original'), ...
    subplot(1,5,2), imshow(I+50), title('I+50'), ...
    subplot(1,5,3), imshow(I-50), title('I-50'), ...
    subplot(1,5,4), imshow(I*2), title('I*2'), ...
    subplot(1,5,5), imshow(I/2), title('I/2')

% 1.2
figure, subplot(1,2,1), imshow(I), title('Original'), ...
    subplot(1,2,2), imshow(imadjust(I,stretchlim(I),[])), ...
        title('imadjust(I,stretchlim(I),[])')

% 1.3
figure, subplot(2,2,1), imshow(I), title('Original'), 
    subplot(2,2,2), imhist(I), title('Histograma Original'), ...
    subplot(2,2,3), imshow(imadjust(I,stretchlim(I),[], 3)), ...
        title('gamma=3'), ...
    subplot(2,2,4), imhist(imadjust(I,stretchlim(I),[], 3)), ...
        title('Hist gamma=3')

% 1.4
new_I=imadjust(I, [0.39,1], []);

figure, subplot(1,2,1), imshow(I), title('Original'), ...
    subplot(1,2,2), imshow(new_I), ...
    title('Función transferencia aplicada');

% Este ejecicio también se puede resolver tal y como hemos hecho en clase de teoría,
% calcular las rectas y aplicar las funciones de cada recta.
x = 0:255;
y_primera_parte = zeros(1, 100);
y_segunda_parte = 0.0 + (0:155) * (255.0 / 155.0);
y = horzcat(y_primera_parte, y_segunda_parte);

transfer_I = I;
for ii = 1:size(I, 1)
    for jj = 1:size(I, 2)
        transfer_I(ii, jj) = y(I(ii, jj));
    end
end


figure, subplot(1,3,1), imshow(I), title('Original'), ...
    subplot(1,3,2), plot(x,y), title('Función transferencia'), ...
    subplot(1,3,3), imshow(transfer_I), ...
    title('Función transferencia aplicada');

% 1.5
figure, subplot(1,2,1), imshow(I), title('Original'), ...
    subplot(1,2,2), imshow(histeq(I)), title('Ecualizada')