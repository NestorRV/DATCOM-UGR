%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 2
%{
    Haz otra función que, de forma análoga, muestre los histogramas de las 
    componentes RGB. Esta vez no hay que mostrar ningún mapa de color 
    específico para ninguna de ellas.
%}

I = imread('p2_imagenes/Warhol_Marilyn_1967_OnBlueGround.jpg');

rgbHistogramas(I)

function rgbHistogramas(I)
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    figure, subplot(1,4,1), imshow(I), title('RGB'), ...
        subplot(1,4,2), imhist(im2uint8(R)), title('R'), ...
        subplot(1,4,3), imhist(im2uint8(G)), title('G'), ...
        subplot(1,4,4), imhist(im2uint8(B)), title('B') 
end