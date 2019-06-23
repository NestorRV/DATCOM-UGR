%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 5
%{
Aplica distintas técnicas de mejora de contraste sobre la imagen siguiente 
y compara los resultados.
%}

I = imread('p3_imagenes/paisaje.jpg');

I_adapthisteq = cat(3, adapthisteq(I(:,:,1)), adapthisteq(I(:,:,2)), ...
    adapthisteq(I(:,:,3)));

gamma = 0.75;
gammaCorrection = 1 / gamma;

transfer_I = I;
for ii = 1:size(I, 1)
    for jj = 1:size(I, 2)
        transfer_I(ii, jj) = 255.0 * (double(I(ii, jj)) / 255.0) ...
                .^ gammaCorrection;
    end
end

figure, subplot(2,3,1), imshow(I), title('Original'), ...
    subplot(2,3,2), imshow(I+50), title('I+50'), ...
    subplot(2,3,3), imshow(I*2), title('I*2'), ...
    subplot(2,3,4), imshow(imadjust(I,stretchlim(I),[])), ...
        title('imadjust(I,stretchlim(I),[])'), ...
    subplot(2,3,5), imshow(transfer_I), title('gamma=0.75'), ...
    subplot(2,3,6), imshow(I_adapthisteq), title('adapthisteq');

%{
Como podemos ver, el sumarle un valor constante clarea la imagen, pero no
mejora el constraste de las misma. Multiplicar la imagen por dos, si mejora
bastante el contraste de la foto. Podemos ver que el resultado es bastante
parecido al obtenido usando la función imadjust con la función stretchlim.
He probado también a aplicar una corrección gamma, pero en este caso la
imagen se oscurece bastante. Finalmente, podemos ver que aplicar la función
adapthisteq sobre las 3 bandas de la imagen provoca una imagen resultante
con un contraste altísimo y unos colores muy vivos. Personalmente, esta
última es la que más me gusta.
%}