%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 1
%{
    Cargar una imagen RGB y convertirla a HSV. Para ello implementa una 
    función que reciba como entrada la imagen en formato RGB y que muestre 
    una ventana con la imagen y los histogramas de sus tres componentes
    HSV.
%}

I = imread('p2_imagenes/Warhol_Marilyn_1967_OnBlueGround.jpg');

hsvHistogramas(I)

function hsvHistogramas(I)
    hsvImage = rgb2hsv(I);
    color = hsvImage(:,:,1);
    saturacion = hsvImage(:,:,2);
    brillo = hsvImage(:,:,3);

    mapahsv=hsv(256);

    figure, subplot(1,4,1), imshow(I), title('RGB'), ...
        subplot(1,4,2), imhist(im2uint8(color), mapahsv), title('color'), ...
        subplot(1,4,3), imhist(im2uint8(saturacion)), title('saturacion'), ...
        subplot(1,4,4), imhist(im2uint8(brillo)), title('brillo') 
end