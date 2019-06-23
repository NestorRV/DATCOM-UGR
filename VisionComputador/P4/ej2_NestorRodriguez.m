%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 2
%{
¿Cómo se puede mejorar la calidad de las imágenes distorsion2.jpg, 
rostro1.png y rostro2.png?
%}

d2 = imread('p4_imagenes/distorsion2.jpg');
r1 = imread('p4_imagenes/rostro1.png');
r2 = imread('p4_imagenes/rostro2.png');

gauss = fspecial('gaussian', [15 15], 2);

figure, subplot(2,3,1), imshow(d2), title('d2'), ...
    subplot(2,3,2), imshow(r1), title('r1'), ...
    subplot(2,3,3), imshow(r2), title('r2'), ...
    subplot(2,3,4), imshow(deconvwnr(d2, gauss, 0.02)), ...
        title('estimated nsr=0.02 d2'), ...
    subplot(2,3,5), imshow(deconvwnr(r1, gauss, 0.02)), ...
        title('estimated nsr=0.02 r1'), ...
    subplot(2,3,6), imshow(deconvwnr(r2, gauss, 0.02)), ...
        title('estimated nsr=0.02 r2');
    
%{
Si observamos las imágenes antes de hacer nada con ellas, podemos ver que
podrían haber sufrido un filtro Gaussiano. Por lo tanto, lo que he hecho ha
sido aplicar la función, deconvwnr la cual permite aplicar una
deconvolución (deshacer el filtro gaussiano). Los valores usados para el
parámetro nsr (0.02 en este caso) ha sido el que mejor resultados ha
obtenido tras realizar distintas pruebas variando dicho parámetro.
%}