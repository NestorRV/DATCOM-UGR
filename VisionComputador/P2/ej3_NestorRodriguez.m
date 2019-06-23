%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 3
%{
    Implementa alguna modificación sobre la componente H de la imagen. Por 
    ejemplo, suma un valor constante a dicho componente y visualiza la 
    imagen resultante.
%}

I = imread('p2_imagenes/Warhol_Marilyn_1967_OnBlueGround.jpg');
hsvImage = rgb2hsv(I);
hsvImage(:,:,1) = hsvImage(:,:,1)+(0.3333);
imshow(hsvImage)