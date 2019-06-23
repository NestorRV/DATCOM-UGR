%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 5
%{
Obtener sobre la imagen formas.png las esquinas usando el método de Harris.
%}

I = imread('p4_imagenes/formas.png');
C = corner(I);
imshow(I);
hold on
plot(C(:,1), C(:,2), 'r*');