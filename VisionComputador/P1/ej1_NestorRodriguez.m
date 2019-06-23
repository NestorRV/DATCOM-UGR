%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 1
%{
    1. Probar los distintos visualizadores de que disponemos en Matlab 
    (imshow, imtool, imagesc). Para ello cargar la imagen disney.png:
%}
I=imread('p1_imagenes/disney.png');

%{
1.1. Visualizarla con los tres visualizadores.
%}
figure, subplot(1,3,1), imshow(I), title('imshow'), ...
    subplot(1,3,2), imtool(I), title('imtool'), ...
    subplot(1,3,3), imagesc(I), title('imagesc') 

%{
    1.2. Convertir a tipo double con double(img) y visualizar de nuevo.
%}
doubleI = double(I);

figure, subplot(1,3,1), imshow(doubleI,[]), title('imshow'), ...
    subplot(1,3,2), imtool(doubleI), title('imtool'), ...
    subplot(1,3,3), imagesc(doubleI), title('imagesc') 

%{
    1.3. Convertir a double con im2double y analizar el resultado.
%}
im2doubleI = im2double(I);

figure, subplot(1,3,1), imshow(im2doubleI), title('imshow'), ...
    subplot(1,3,2), imtool(im2doubleI), title('imtool'), ...
    subplot(1,3,3), imagesc(im2doubleI), title('imagesc') 

%{
    La función double() convierte la imagen en una variable de tipo double, 
    manteniendo los mismos valores. La función im2double() hace el mismo 
    proceso pero también normaliza los valores de la imagen a un intervalo 
    de [0, 1], es decir, modifica los valores de la imagen. Esta
    normalización es necesaria para trabajar con imshow(). Es por eso que
    ya no es necesario el argumento [] en la llamada a imshow().
%}