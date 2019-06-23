%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 4
%{
Usa la función adapthisteq sobre la imagen mujer.jpg y analiza el 
resultado.
%}

% https://www.dfstudios.co.uk/articles/programming/image-programming-algorithms/image-processing-algorithms-part-6-gamma-correction/
I = imread('p3_imagenes/mujer.jpg');

figure, subplot(1,2,1), imshow(I), title('Original'), ...
    subplot(1,2,2), imshow(adapthisteq(I)), ...
    title('adapthisteq');

%{
En la imagen procesada podemos ver un mayor contraste, lo cual nos permite
ver de forma más marcada las fronteras. Si nos fijamos en el rostro de 
la mujer, en concreto en la frente y mofletes, podemos apreciar también 
como se introduce un poco ruido en la imagen, ya que se ve una piel más
imperfecta y granulada.
%}