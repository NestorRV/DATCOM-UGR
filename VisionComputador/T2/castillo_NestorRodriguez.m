%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

castillo_oculto = imread('Castillo_oculto2bits.png');
castillo = imread('castillo.png');

%{
Primero he probado la versión comentada en clase, simplemente asignar 0 o
255 en función de si el pixel es par o no.
%}
secreto_1 = zeros(size(castillo_oculto, 1), size(castillo_oculto, 2));
for ii = 1:size(castillo_oculto, 1)
    for jj = 1:size(castillo_oculto, 2)
        if rem(castillo_oculto(ii, jj), 2) ~= 0
            secreto_1(ii, jj) = 255;
        end
    end
end

%{
Pero podemos ir un paso más alla. Dado que tenemos la imagen con las vacas
escondidas y la imagen sin ellas, la imagen de las vacas será obtenida
sacando la diferencia entre ellas.
%}

vacas = castillo_oculto - castillo;
imshow(vacas);

%{
Cómo podemos ver, sale todo negro. Veamos que valores tiene nuestra nueva
imagen:
%}

unique(vacas)

%{
Cómo podemos ver, sólo tiene 0, 1 y 2, por eso sale todo negro, ya que son
valores muy bajos. Ahora, podemos aplicar lo comentario que hay en el
enunciado, el cual consiste en jugar con los valors 0, 128 y 255. Por lo
tanto, en la imagen con contenido oculto, he aplicado la operación de
módulo 4, para así poder obtener esos tres valores (0, 1 y 2) comentados
anteriormente. Si nos paramos a pensar, en el caso anterior, hemos aplicado
la misma idea pero mirando directamente la paridad del pixel.
%}

secreto_2 = zeros(size(castillo_oculto, 1), size(castillo_oculto, 2));
for ii = 1:size(castillo_oculto, 1)
    for jj = 1:size(castillo_oculto, 2)
        pixel = rem(castillo_oculto(ii, jj), 4);
        if pixel == 0
            secreto_2(ii, jj) = 0;
        elseif pixel == 1
            secreto_2(ii, jj) = 128;
        elseif pixel == 2
            secreto_2(ii, jj) = 255;
        end
    end
end

figure, subplot(1,2,1), imshow(secreto_1), title('secreto 1'), ...
    subplot(1,2,2), imshow(secreto_2, []), title('secreto 2');

%{
El proceso de ocultar las vacas ha sido simple, sólo debemos revertir el 
proceso aquí explicado. Cambiamos los tres valores de los píxeles por 0, 1
y 2 y lo sumamos a la imagen donde queramos esconder el contenido.
%}