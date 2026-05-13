% AMPLIACION DE ROBOTICA - Lab-MR 6: Navegacion autonoma con A*
%
% Planificacion global con A* (heuristica euclidea, matriz de costes
% reconstruida tambien con distancia euclidea para consistencia) +
% navegacion local con campos potenciales.

% Si no se limpia a veces se solapa o no lo hace bien
clear; clc; close all;

% Cargar datos
mapa2;
img = imread('mapa2.pgm');

% Pedir origen y destino
origen = input('Nodo origen: ');
destino = input('Nodo destino: ');

% =========================
% MATRIZ HEURISTICA (H)
% =========================
n = size(costes,1);
H = zeros(n);
for i = 1:n
    for j = 1:n
        xi = nodos(i,2); yi = nodos(i,3);
        xj = nodos(j,2); yj = nodos(j,3);
        H(i,j) = norm([xi yi] - [xj yj]);
    end
end

% =========================
% MATRIZ DE COSTES EUCLIDEA
% =========================
costes_euclidea = zeros(n);
for i = 1:n
    for j = 1:n
        if costes(i,j) > 0   % si hay conexion
            xi = nodos(i,2); yi = nodos(i,3);
            xj = nodos(j,2); yj = nodos(j,3);
            costes_euclidea(i,j) = norm([xi yi] - [xj yj]);
        else
            costes_euclidea(i,j) = 0;  % necesario para A*
        end
    end
end

% =========================
% A*
% =========================
[coste, ruta] = Aestrella(costes_euclidea, H, origen, destino);

% Coordenadas
coords = nodos(ruta, 2:3);

figure;
imshow(flipud(img)); hold on;
set(gca, 'YDir', 'normal');

% Camino global
plot(coords(:,1), coords(:,2), 'bo-', 'LineWidth', 2);

% Posicion inicial
pos = coords(1,:);

% NAVEGACION LOCAL
for i = 2:size(coords,1)

    objetivo = coords(i,:);

    max_iter = 1000;
    iter = 0;

    while norm(pos - objetivo) > 3 && iter < max_iter

        iter = iter + 1;

        % Fuerzas
        F_attr = fuerza_atractiva(pos, objetivo);
        F_rep  = fuerza_repulsiva(pos, img);

        F_attr = reshape(F_attr,1,2);
        F_rep  = reshape(F_rep,1,2);

        % Prioridad al objetivo
        F_total = 3*F_attr + F_rep;

        % Evitar retroceso
        if dot(F_total, (objetivo - pos)) < 0
            F_total = F_attr;
        end

        % Normalizar
        F_total = F_total / (norm(F_total) + 1e-6);

        % Movimiento
        pos = pos + 0.4 * F_total;

        % Dibujar
        plot(pos(1), pos(2), 'r.');
        drawnow limitrate;
    end

    if iter >= max_iter
        disp(['Atasco entre nodos ', num2str(i-1), ' y ', num2str(i)]);
    end
end
