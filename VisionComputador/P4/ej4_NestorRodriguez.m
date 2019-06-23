%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 4
%{
Analizar la imagen distorsion1.jpg y aplicar diferentes técnicas para 
mejorarla (eliminación del ruido). En concreto, prueba con suavizados 
gaussianos y con el filtro 'motion' de Matlab.

¿Se te ocurre alguna otra técnica que mejore sensiblemente la calidad de la 
imagen respecto de los filtrados propuestos?
%}

I = imread('p4_imagenes/distorsion1.jpg');

gauss = fspecial('gaussian', 7, 3);
motion = fspecial('motion', 7, 45);

figure, subplot(1,3,1), imshow(I), title('Original'), ...
    subplot(1,3,2), imshow(imfilter(I, gauss)), title('Gaussiano'), ...
    subplot(1,3,3), imshow(imfilter(I, motion)), title('Motion');