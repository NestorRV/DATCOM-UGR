%% Alumno: Néstor Rodríguez Vico. 75573052C. nrv23@correo.ugr.es

%% Ejercicio 5
%{
    Crea una animación en la que, dada una imagen, se pueda ver como van 
    ciclando los colores. Para ello, cada fotograma se obtendrá sumando un 
    pequeño incremento a la componente H del fotograma anterior. Para ello 
    puedes usar las funciones im2frame y movie.
%}

length = 255;
I = imread('p2_imagenes/rosa2.jpg');
pelicula = construirPelicula(I, 255);
movie(pelicula);


function pelicula = construirPelicula(I, length)
    pelicula(length) = struct('cdata', {[]}, 'colormap', {[]});

    y=rgb2hsv((I));
    z=y;
    for i = 1:length
        z(:,:,1) = mod(y(:,:,1)+i/255.0,0.99);
        pelicula(i) = im2frame((hsv2rgb(z)));
    end
end