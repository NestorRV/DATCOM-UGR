%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 2

%{
    2. Descomponer una imagen RGB en sus tres componentes de color 
    (rosa.jpg).
%}

Icolor = imread('p1_imagenes/rosa.jpg');

imR = Icolor(:,:,1);
imG = Icolor(:,:,2);
imB = Icolor(:,:,3);

%{
    2.1. Visualizar las tres componentes de manera simultánea junto con la 
    imagen original y analizar los resultados.
%}

figure, subplot(1,4,1), imshow(Icolor), title('color'), ...
    subplot(1,4,2), imshow(imR), title('Roja'), ...
    subplot(1,4,3), imshow(imG), title('Verde'), ...
    subplot(1,4,4), imshow(imB), title('Azul')

%{
    Podemos apreciar que, por ejemplo, cuando pintamos la componente de 
    color rojo, las zonas en las que en la imagen eran rojas se muestran en 
    color blanco y que, las zonas en las que hay ausencia de rojo, se 
    muestran en tonos más oscuros. Esto mismo pasa para cualquier 
    componente con su respectivo color.
%}
    
%{
    2.2 Anula una de sus bandas (por ejemplo la roja) y analiza los 
    resultados. Se recomienda usar imtool para ver los valores de color en 
    cada píxel.
%}

Icolor(:,:,1) = 0;
imtool(Icolor)

%{
    Podemos ver como desaparece el color rojo de la imagen y todos los
    colores se vuelven en tonos verdosos y azulados.
%}

%{
    2.3 Usa también la imagen sintetica.jpg, haz otras modificaciones y 
    observa los resultados (por ejemplo: poner una de sus bandas al nivel 
    máximo, intercambiar el papel de las bandas entre sí, aplicar un 
    desplazamiento a alguna de las bandas con circshift, invertir alguna de 
    sus bandas con fliplr o flipud, ...).
%}

img = imread('p1_imagenes/sintetica.jpg');

imgRMax = img;
imgRMax(:,:,1) = 255;

imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);
imgCambiaOrden = cat(3,imgG, imgR, imgB);

imgCircshift = img;
imgCircshift(:,:,1) = circshift(img(:,:,1), 5);

imgFliplr = img;
imgFliplr(:,:,1) = fliplr(img(:,:,1));

figure, subplot(2,3,1), imshow(img), title('img'), ...
    subplot(2,3,2), imshow(imgRMax), title('imgRMax'), ...
    subplot(2,3,3), imshow(imgCambiaOrden), title('imgCambiaOrden'), ...
    subplot(2,3,4), imshow(imgCircshift), title('imgCircshift'), ...
    subplot(2,3,5), imshow(imgFliplr), title('imgFliplr')