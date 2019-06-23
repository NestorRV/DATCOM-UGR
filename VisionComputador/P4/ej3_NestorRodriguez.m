%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 3
%{
Utiliza la correlación para buscar formas den una imagen. Para este
ejercicios puedes usar las siguientes imágenes:
    * formas.png, estrella.png, ovalo.png, cuadrado.png, cuadrado2.png, 
        cuadrado3.png
    * texto.png, letra_i.png, letra_k.png, letra_m.png, letra_o.png, 
        letra_p.png
%}

formas = imread('p4_imagenes/formas.png');
estrella = imread('p4_imagenes/estrella.png');
estrella = im2bw(imresize(estrella,0.9),0.5);
se = strel('arbitrary', estrella);
s_estr = imopen(formas,se);
figure, subplot(1,2,1), imshow(formas), subplot(1,2,2), imshow(s_estr);

texto = imread('p4_imagenes/texto.png');
letra_p = imread('p4_imagenes/letra_p.png');
letra_p = im2bw(imresize(letra_p,1),0.5);
sp = strel('arbitrary', letra_p);
s_letra_p = imopen(texto,sp);
figure, subplot(1,2,1), imshow(texto), subplot(1,2,2), imshow(s_letra_p);

% Se me ha ocurrido otra manera de resolver el problema de las formas. 
% Lo que he hecho ha saido calcular la correlacion de todas las formas
% con la imagen formas y, para los píxeles cuya correlación es baja, les
% asigno el valor 255 para suprimirlos.

formas = imread('p4_imagenes/formas.png');
estrella = imresize(imread('p4_imagenes/estrella.png'), 0.1);
ovalo = imresize(imread('p4_imagenes/ovalo.png'), 0.1);
cuadrado = imresize(imread('p4_imagenes/cuadrado.png'), 0.1);
cuadrado2 = imresize(imread('p4_imagenes/cuadrado2.png'), 0.1);
cuadrado3 = imresize(imread('p4_imagenes/cuadrado3.png'), 0.1);

cor_estrella = imfilter(formas, double(estrella));
cor_ovalo = imfilter(formas, double(ovalo));
cor_cuadrado = imfilter(formas, double(cuadrado));
cor_cuadrado2 = imfilter(formas, double(cuadrado2));
cor_cuadrado3 = imfilter(formas, double(cuadrado3));

new_formas = formas;
for ii = 1:size(formas, 1)
    for jj = 1:size(formas, 2)
        if cor_estrella(ii, jj) == 0 || cor_ovalo(ii, jj) == 0 || ...
            cor_cuadrado(ii, jj) == 0 || cor_cuadrado2(ii, jj) == 0 || ...
            cor_cuadrado3(ii, jj) == 0

            new_formas(ii, jj) = 255;
        end
    end
end

figure, imshow(new_formas);