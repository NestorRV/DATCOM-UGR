I = imread('p4_imagenes/formas.png');

% Aplicamos las variaciones de intensidad a las imágenes
h = conv2([1 -1], I);
v = conv2([1; -1], I);
diag1 = conv2([0 -1; 1 0], I);
diag2 = conv2([1 0; 0 -1], I);

for i = 2:size(h, 1) - 1
    for j = 2:size(h, 2) - 1
        hh(i, j) = sum(sum(abs(h(i - 1:i + 1, j - 1:j + 1))));
    end
end

for i = 2:size(v, 1) - 1
    for j = 2:size(v, 2) - 1
        vv(i, j) = sum(sum(abs(v(i - 1:i + 1, j - 1:j + 1))));
    end
end

for i = 2:size(diag1, 1) - 1
    for j = 2:size(diag1, 2) - 1
        ddiag1(i, j) = sum(sum(abs(diag1(i - 1:i + 1, j - 1:j + 1))));
    end
end

for i = 2:size(diag2, 1) - 1
    for j = 2:size(diag2, 2) - 1
        ddiag2(i, j) = sum(sum(abs(diag2(i - 1:i + 1, j - 1:j + 1))));
    end
end

% Calculamos los tamaños máximos permitidos, que son los tamaños de las
% frecuencias más pequeñas
sizes = [size(hh); size(vv); size(ddiag1); size(ddiag2)];
maxX = min(sizes(:, 1));
maxY = min(sizes(:, 2));

% Nos quedamos la parte de las frecuencias que nos interesa
hh = hh(1:maxX, 1:maxY);
vv = vv(1:maxX, 1:maxY);
ddiag1 = ddiag1(1:maxX, 1:maxY);
ddiag2 = ddiag2(1:maxX, 1:maxY);

% Combinamos las cuatro frecuencias
frecuencias = cat(3, hh, vv, ddiag1, ddiag2);
% Y nos quedamos con el valor mas pequeño en cada pixel
corners = min(frecuencias, [], 3);

% Recorremos nuestras esquinas y, si un píxel no es máximo de su entorno
% Lo ponemos a cero
for i = 2:size(corners, 1) - 1
    for j = 2:size(corners, 2) - 1
        local_region = corners(i - 1:i + 1, j - 1:j + 1);
        if (corners(i, j) == max(local_region(:)))
            corners(i) = 255;
        else
            corners(i) = 0;
        end
    end
end

figure, subplot(1,2,1), imshow(I), title('Original'), ...
    subplot(1,2,2), imshow(corners), title('Corners');