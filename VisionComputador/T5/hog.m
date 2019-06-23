HOG_X_pos = generate_hog_pos();
HOG_X_neg = generate_hog_neg();
y_pos = ones(size(HOG_X_pos, 1), 1);
y_neg = zeros(size(HOG_X_neg, 1), 1) - 1;

X = [HOG_X_pos; HOG_X_neg]; 
y = [y_pos; y_neg];

ntrain = round(0.8 * length(y)); 
ntest = size(X, 1) - ntrain;
% Fijamos la semilla aleatoria
rng(1)
% Y obtenemos una permutación
idx = randperm(length(y));

X_train = X(idx(1:ntrain),:);
y_train = y(idx(1:ntrain));
X_test = X(idx(ntrain+1:length(y)),:); 
y_test = y(idx(ntrain+1:length(y)));

SVMModel = fitcsvm(X_train, y_train, 'Standardize', true, ...
    'KernelFunction', 'RBF',  'KernelScale', 'auto');

y_pred_train = predict(SVMModel,X_train);
y_pred_test = predict(SVMModel,X_test);

confusionmat(y_train, y_pred_train)
%{
ans =

    41     1
     0   318
%}
confusionmat(y_test, y_pred_test)
%{
ans =

     8     0
     1    81
%}

mean(double(y_train == y_pred_train))
%{
ans = 0.9972
%}
mean(double(y_test == y_pred_test))
%{
ans = 0.9889
%}

function hogs = generate_hog_neg()
rng(1)
D = 'data/pedestrians_neg';
% Leemos los ficheros
S = dir(fullfile(D,'*.jpg'));
for ii = 1:numel(S)
    F = fullfile(D, S(ii).name);
    I = rgb2gray(imread(F));
    % Cambiamos el tamaño a 512x512
    I = imresize(I,[512 512]);
    % Cogemos una región aleatoria de 128x64
    [n, m]= size(I);
    I_region = I(randi(n-128+1)+(0:128-1),randi(m-64+1)+(0:64-1));
    hogs(ii,:) = hog_descriptor(I_region);
end
end

function hogs = generate_hog_pos()
D = 'data/pedestrians128x64';
% Leemos los ficheros
S = dir(fullfile(D,'*.ppm'));
% Los barajamos
rng(1)
random_files_idx = randperm(length(S));
% Cogemos 400 imagenes
imagenes_idx = random_files_idx(1:400);
for ii = 1:size(imagenes_idx, 2)
    F = fullfile(D, S(imagenes_idx(ii)).name);
    I = rgb2gray(imread(F));
    hogs(ii,:) = hog_descriptor(I);
end
end

function H = hog_descriptor(I)
number_cells_row = (size(I, 1) / 8);
number_cells_col = (size(I, 2) / 8);

cells = make_cells(I);
H = block_normalization(cells, number_cells_row, number_cells_col);
end

function norm_block = normalize_L2_Hys(block)
norm_block = norm(block) + 0.0000001;
block_aux = block / norm_block;
block_aux(block_aux > 0.2) = 0.2;
norm_block = norm(block_aux) + 0.0000001;
norm_block = block_aux / norm_block;
end

function H = block_normalization(cells, number_cells_row, number_cells_col)
H = [];
for row = 1:(number_cells_row - 1)
    for col = 1:(number_cells_col - 1)
        block = cells(row : row + 1, col : col + 1, :);
        H = [H; normalize_L2_Hys(block(:))];
    end
end
end

function cells = make_cells(I)
% Imagen 128x64 -> Celdas de 8x8 -> cells va a ser 16x8
hx = [- 1, 0, 1];
hy = transpose([- 1 0 1]);

cells = zeros(size(I, 1) / 8, size(I, 2) / 8, 9);
for row = 0:(size(I, 1) / 8 - 1)
    row_despl = (row * 8) + 1;
    for col = 0:(size(I, 2) / 8 - 1)
        col_despl = (col * 8) + 1;
        row_idx = row_despl : (row_despl + 8 - 1);
        col_idx = col_despl : (col_despl + 8 - 1);
        cell = I(row_idx, col_idx);
        % Calculamos las derivadas en el eje x e y para cada pixel.
        dx = filter2(hx, double(cell));
        dy = filter2(hy, double(cell));
        % Sacamos el angulo y las magnitudes
        angulos = abs(rad2deg(atan2(dy, dx)));
        magnitudes = ((dy .^ 2) + (dx .^ 2)) .^ .5;
        cells(row + 1, col + 1, :) = get_histogram(angulos, magnitudes);
    end
end
end

function h = get_histogram(angulos, magnitudes)
bins = [20, 40, 60, 80, 100, 120, 140, 160];
h = zeros(1, 9);

for ii = 1:size(angulos, 1)
    for jj = 1:size(angulos, 2)
        if (angulos(ii, jj) >= 0) && (angulos(ii, jj) < bins(1))
            aux = [0 20 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(1) = h(1) + first_value;
            h(2) = h(2) + (magnitudes(ii, jj) - first_value);
        elseif (angulos(ii, jj) >= bins(1)) && (angulos(ii, jj) < bins(2))
            aux = [20 40 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(2) = h(2) + first_value;
            h(3) = h(3) + (magnitudes(ii, jj) - first_value);
        elseif (angulos(ii, jj) >= bins(2)) && (angulos(ii, jj) < bins(3))
            aux = [40 60 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(3) = h(3) + first_value;
            h(4) = h(4) + (magnitudes(ii, jj) - first_value);
        elseif (angulos(ii, jj) >= bins(3)) && (angulos(ii, jj) < bins(4))
            aux = [60 80 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(4) = h(4) + first_value;
            h(5) = h(5) + (magnitudes(ii, jj) - first_value);
        elseif (angulos(ii, jj) >= bins(4)) && (angulos(ii, jj) < bins(5))
            aux = [80 100 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(5) = h(5) + first_value;
            h(6) = h(6) + (magnitudes(ii, jj) - first_value);
        elseif (angulos(ii, jj) >= bins(5)) && (angulos(ii, jj) < bins(6))
            aux = [100 120 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(6) = h(6) + first_value;
            h(7) = h(7) + (magnitudes(ii, jj) - first_value);
        elseif (angulos(ii, jj) >= bins(6)) && (angulos(ii, jj) < bins(7))
            aux = [120 140 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(7) = h(7) + first_value;
            h(8) = h(8) + (magnitudes(ii, jj) - first_value);
        elseif (angulos(ii, jj) >= bins(7)) && (angulos(ii, jj) < bins(8))
            aux = [140 160 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(8) = h(8) + first_value;
            h(9) = h(9) + (magnitudes(ii, jj) - first_value);
        else
            aux = [160 180 angulos(ii, jj)];
            proportions = (aux - min(aux)) / (max(aux) - min(aux));
            bin_proportion = 1.0 - proportions(end);
            first_value = bin_proportion * magnitudes(ii, jj);
            h(9) = h(9) + first_value;
            h(1) = h(1) + (magnitudes(ii, jj) - first_value);
        end
    end
end
end