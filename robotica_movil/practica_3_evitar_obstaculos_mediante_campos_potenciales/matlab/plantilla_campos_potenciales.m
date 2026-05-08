% AMPLIACION DE ROBOTICA
% LAB-MR 3: Navegacion local con campos potenciales
% Evitar obstaculos

clc
clearvars
close all
%% Carga del mapa de ocupacion

map_img=imread('mapa1_150.png');
map_neg=imcomplement(map_img);
map_bin=imbinarize(map_neg);
mapa=binaryOccupancyMap(map_bin);
show(mapa);

% Marcar los puntos de inicio y destino
hold on;
title('Señala los puntos inicial y final de la trayectoria del robot');
origen=ginput(1);
plot(origen(1), origen(2), 'go','MarkerFaceColor','green');  % Dibujamos el origen
destino=ginput(1);
plot(destino(1), destino(2), 'ro','MarkerFaceColor','red');  % Dibujamos el destino

% Configuracion del sensor (laser de barrido)
max_rango=10;
angulos=-pi/2:(pi/180):pi/2; % resolucion angular barrido laser

% Caracteristicas del vehiculo y parametros del metodo
v=0.4;            % Velocidad del robot
D=1.5;           % Rango del efecto del campo de repulsión de los obstáculos
alfa=1;           % Coeficiente de la componente de atracción
beta=100;      % Coeficiente de la componente de repulsión

%% Inicialización

robot=[origen 0];     % El robot empieza en la posición de origen (orientacion cero)
path = [];                 % Se almacena el camino recorrido
path = [path; robot]; % Se añade al camino la posicion actual del robot
iteracion=0;              % Se controla el nº de iteraciones por si se entra en un minimo local

%% Calculo de la trayectoria

while norm(destino-robot(1:2)) > v && iteracion<1000    % Hasta menos de una iteración de la meta (10 cm)

    % --- 1. Obtener puntos de impacto del sensor laser en coordenadas del mapa ---
    obs = SimulaLidar(robot, mapa, angulos, max_rango);

    % --- 2. Filtrar obstaculos dentro del rango de influencia D ---
    % Los rayos sin impacto devuelven NaN; los demas son coordenadas absolutas
    distancias = sqrt((obs(:,1)-robot(1)).^2 + (obs(:,2)-robot(2)).^2);
    validos = ~isnan(obs(:,1)) & distancias < D;  % mascara: NaN y fuera de rango -> false
    obs_cercanos = obs(validos, :);               % coordenadas (x,y) de obstaculos cercanos
    dist_cercanos = distancias(validos);           % distancias correspondientes

    % --- 3. Fuerza de atraccion hacia el destino ---
    % Vector unitario desde el robot al destino, escalado por alfa
    vec_atr = destino - robot(1:2);
    F_atr = alfa * vec_atr / norm(vec_atr);

    % --- 4. Fuerza de repulsion de los obstaculos cercanos ---
    F_rep = [0, 0];
    for i = 1:size(obs_cercanos, 1)
        d = dist_cercanos(i);
        vec_rep = robot(1:2) - obs_cercanos(i,:);          % vector del obstaculo al robot
        % Magnitud: crece cuando d->0, se anula cuando d=D
        % Direccion: unitaria, alejandose del obstaculo
        F_rep = F_rep + beta * (1/d - 1/D) * (1/d^2) * vec_rep / norm(vec_rep);
    end

    % --- 5. Fuerza resultante y movimiento del robot ---
    F_res = F_atr + F_rep;                                         % suma vectorial
    theta = atan2(F_res(2), F_res(1));                             % direccion de movimiento
    robot = [robot(1) + v*cos(theta), robot(2) + v*sin(theta), theta]; % avanzar v metros



   

    path = [path;robot];	% Se añade la nueva posición al camino seguido
    plot(path(:,1),path(:,2),'r');
    drawnow

    iteracion=iteracion+1;
end

if iteracion==1000   % Se ha caído en un mínimo local
    fprintf('No se ha podido llegar al destino.\n')
else
    fprintf('Destino alcanzado.\n')
end

%% funcion para simular el sensor
function [obs]=SimulaLidar(robot, mapa, angulos, max_rango)
    obs=rayIntersection(mapa,robot,angulos, max_rango);
    % plot(obs(:,1),obs(:,2),'*r') % Puntos de interseccion lidar
    % plot(robot(1),robot(2),'ob') % Posicion del robot
    % for i = 1:length(angulos)
    %     plot([robot(1),obs(i,1)],...
    %         [robot(2),obs(i,2)],'-b') % Rayos de interseccion
    % end
    % % plot([robot(1),robot(1)-6*sin(angulos(4))],...
    % %     [robot(2),robot(2)+6*cos(angulos(4))],'-b') % Rayos fuera de
    % %     rango
end