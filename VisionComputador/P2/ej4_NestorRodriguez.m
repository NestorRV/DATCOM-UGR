%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 4
%{
    Chroma Key. Haz una función que dada una imagen con un color de fondo
    casi uniforme (en el ejemplo primer plano) inserte esta imagen en otra
    (en el ejemplo segundo plano). Para ello el fondo de color uniforme en 
    la imagen primer plano se sustituye por los valores de la imagen 
    segundo plano. La función debe dar la posibilidad de insertar la imagen 
    primer plano en diferentes posiciones de la imagen segundo plano.
%}

foreground = imread('imagenes_chromakey/chromakey_original.jpg');
background = imread('imagenes_chromakey/praga1.jpg');

chroma = chroma_key(foreground, background, 0, 0, 0, 220, 0);
figure, imshow(chroma)

chroma = chroma_key(foreground, background, ...
    size(background, 1) - size(foreground, 1), ...
    size(background, 2) - size(foreground, 2), 0, 220, 0);

figure, imshow(chroma)

function chroma = chroma_key(foreground, background, iniX, iniY, R, G, B)
    % Convertimos nuestro color a HSV
    HSV_color(1,1,:) = [R G B]; 
    HSV_color = rgb2hsv(HSV_color);
    % Y nuestra imagen
    foreground_hsv = rgb2hsv(foreground);
    % Creamos la máscara. Dicha máscara va a tener un 1 para los píxeles
    % cuya diferencia con nuestro colo HSV supere un umbral, en nuestro
    % caso 0.05
    mask = abs(foreground_hsv(:,:,1) - HSV_color(1,1,1)) > 0.05;

    for ii = 1:size(mask, 1)
        for jj = 1:size(mask, 2)
            % Si la máscara es no es cero, ponemos la imagen foreground
            % sobre la imagen background. Que el valor de la máscara sea
            % cero nos indica que el pixel asociado a ese punto de la
            % imagen foreground es muy similar al color ver y, por lo
            % tanto, no nos interesa.
            if mask(ii, jj) ~= 0
                for kk = 1:3
                    background(iniX + ii, iniY + jj, kk) = ...
                        foreground(ii, jj, kk);
                end
            end
        end
    end

    chroma = background;
end