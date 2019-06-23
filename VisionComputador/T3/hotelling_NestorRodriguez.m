%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

% Leemos las imágenes
banda_1 = imread('adra/banda1.tif');
banda_2 = imread('adra/banda2.tif');
banda_3 = imread('adra/banda3.tif');
banda_4 = imread('adra/banda4.tif');
banda_5 = imread('adra/banda5.tif');
banda_6 = imread('adra/banda6.tif');

% Las convertimos en una única columna
banda_1_1d = double(banda_1(:));
banda_2_1d = double(banda_2(:));
banda_3_1d = double(banda_3(:));
banda_4_1d = double(banda_4(:));
banda_5_1d = double(banda_5(:));
banda_6_1d = double(banda_6(:));

% Y creamos una matrix con 6 columnas 
bandas = [banda_1_1d banda_2_1d banda_3_1d banda_4_1d banda_5_1d banda_6_1d];

% Calculamos las covarianzas
C = cov(bandas);

% Y sus autovalores y autovectores
[V,D] = eig(C);
% Ordenamos los autovalores de mayor a menos
[out, idx] = sort(diag(D), 'descend');
% Y reordenamos los autovectores en base a dicho orden
V_order = transpose(V(:,idx));
% Y reordenamos los autovalores en base a dicho orden
D_order = transpose(D(:,idx));

media = mean(bandas(:));
% Aplicamos la fórmula y=A(x-mx)
new_bandas = transpose(V_order * transpose(bandas - media));

% Sacamos las nuevas bandas
new_banda_1_1d = new_bandas(:,1);
new_banda_2_1d = new_bandas(:,2);
new_banda_3_1d = new_bandas(:,3);
new_banda_4_1d = new_bandas(:,4);
new_banda_5_1d = new_bandas(:,5);
new_banda_6_1d = new_bandas(:,6);

% Y le cambiamos el tamaño a su tamaño original
new_banda_1 = reshape(new_banda_1_1d, [256 256]);
new_banda_2 = reshape(new_banda_2_1d, [256 256]);
new_banda_3 = reshape(new_banda_3_1d, [256 256]);
new_banda_4 = reshape(new_banda_4_1d, [256 256]);
new_banda_5 = reshape(new_banda_5_1d, [256 256]);
new_banda_6 = reshape(new_banda_6_1d, [256 256]);

% Ahora vamos a calcular los errores.
% Primero creamos un array de índices para luego poder hacer un plot
x = 1:size(D, 1);
% Nos quedamos con los autovalores en su orden correcto
autovalores = diag(rot90(D_order));
% El error de utilizar solo la primera imagen es la suma de la diagonal 
% menos el primer valor. El error de utilizar las dos primera imágenes es
% la suma de la diagonal menos los dos primero valores, y así
% sucesivamente. Finalemente, cuando se cogen todas las imágenes, el error 
% es 0
errores=zeros(1,size(autovalores, 1));
for ii = 1:size(autovalores, 1)
    errores(ii)=sum(autovalores(ii:size(autovalores, 1)));
end

figure, subplot(2,3,1), imshow(new_banda_1(:,:,1), []), title('banda 1'), ...
    subplot(2,3,2), imshow(new_banda_2, []), title('banda 2'), ...
    subplot(2,3,3), imshow(new_banda_3, []), title('banda 3'), ...
    subplot(2,3,4), imshow(new_banda_4, []), title('banda 4'), ...
    subplot(2,3,5), imshow(new_banda_5, []), title('banda 5'), ...
    subplot(2,3,6), imshow(new_banda_6, []), title('banda 6');

% Podemos ver como la función decrece más lentamente según nos acercamos al
% final del gráfico. Esto se debe a que las últimas imágnes aportan menos
% energía.
figure, plot(x, errores), title('Error');