% AMPLIACION DE ROBOTICA - Lab-MR 6: Navegacion autonoma con Dijkstra
%
% Planificacion global con Dijkstra + navegacion local con campos
% potenciales. El programa pregunta nodo de origen y destino, muestra el
% mapa con la ruta planificada y la trayectoria real del robot.

% Si no se limpia a veces se solapa o no lo hace bien
clear; clc; close all;

% Cargar datos
mapa2;
img = imread('mapa2.pgm');

% Pedir origen y destino
origen = input('Nodo origen: ');
destino = input('Nodo destino: ');

% Dijkstra
[coste, ruta] = dijkstra(costes, origen, destino);

% Coordenadas
coords = nodos(ruta, 2:3);

% Mostrar mapa
figure;
imshow(flipud(img)); hold on;
set(gca, 'YDir', 'normal');

% Dibujar camino global
plot(coords(:,1), coords(:,2), 'bo-', 'LineWidth', 2);

% Posicion inicial
pos = coords(1,:);

% Recorrer la ruta
for i = 2:size(coords,1)

    objetivo = coords(i,:);

    max_iter = 1000;
    iter = 0;

    while norm(pos - objetivo) > 3 && iter < max_iter

        iter = iter + 1;

        % Fuerzas
        F_attr = fuerza_atractiva(pos, objetivo);
        F_rep  = fuerza_repulsiva(pos, img);

        % Asegurar formato correcto
        F_attr = reshape(F_attr,1,2);
        F_rep  = reshape(F_rep,1,2);

        % Prioridad al objetivo
        F_total = 3*F_attr + F_rep;

        % Evitar retroceso (mejora frente a minimos locales)
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

    % Aviso si no llega
    if iter >= max_iter
        disp(['Atasco entre nodos ', num2str(i-1), ' y ', num2str(i)]);
    end
end
