% AMPLIACION DE ROBOTICA
% LAB-MR 6: Navegacion completa
% Integracion de navegacion global (Dijkstra / A*) con navegacion local
% reactiva por campos potenciales.

clc;
clearvars;
close all;

%% 0) Carga de mapa y grafo
f_mapa = fullfile('datos', 'mapa2.pgm');
f_grafo = fullfile('datos', 'mapa2.m');

if ~isfile(f_mapa)
    error('Falta %s', f_mapa);
end
if ~isfile(f_grafo)
    error('Falta %s', f_grafo);
end

img = imread(f_mapa);
map_bin = imbinarize(imcomplement(img));
% flipud: image rows grow downward, but binaryOccupancyMap world-y grows upward.
% Node coordinates in mapa2.m use image-row convention, so we flip the matrix
% so that world y ≈ image row (both increase in the same direction).
mapa = binaryOccupancyMap(flipud(map_bin));

run(f_grafo); % Espera: nodos y costes

if ~exist('nodos', 'var') || ~exist('costes', 'var')
    error('mapa2.m debe definir las variables ''nodos'' y ''costes''.');
end

% nodos esperado: [id, x, y]
if size(nodos, 2) >= 3
    node_ids = nodos(:, 1);
    XY = nodos(:, 2:3);
elseif size(nodos, 2) == 2
    node_ids = (1:size(nodos, 1))';
    XY = nodos;
else
    error('Formato de nodos no valido. Esperado Nx3 (id,x,y) o Nx2 (x,y).');
end

C = double(costes);
n = size(C, 1);
if size(C, 2) ~= n || size(XY, 1) ~= n
    error('Dimensiones incompatibles entre nodos y matriz de costes.');
end

%% 1) Entradas de usuario
fprintf('\n===== LAB-MR 6: NAVEGACION COMPLETA =====\n');

id_recomendado_origen = 1;
id_recomendado_destino = node_ids(argmax(XY(:,1) + XY(:,2))); % zona superior-derecha

planner_mode = input('Planificador global [1=Dijkstra, 2=A*] (defecto 1): ');
if isempty(planner_mode)
    planner_mode = 1;
end
if ~ismember(planner_mode, [1, 2])
    error('Modo de planificador invalido.');
end

id_origen = input(sprintf('Nodo origen (defecto %d): ', id_recomendado_origen));
if isempty(id_origen)
    id_origen = id_recomendado_origen;
end
id_destino = input(sprintf('Nodo destino (defecto %d): ', id_recomendado_destino));
if isempty(id_destino)
    id_destino = id_recomendado_destino;
end

usar_mejora = input('Usar mejora anti-minimos locales [1=Si, 0=No] (defecto 1): ');
if isempty(usar_mejora)
    usar_mejora = 1;
end

idx_origen = find(node_ids == id_origen, 1);
idx_destino = find(node_ids == id_destino, 1);
if isempty(idx_origen) || isempty(idx_destino)
    error('Nodo origen/destino no existe en la lista de nodos.');
end

%% 2) Planificacion global
coste_global = inf;
ruta_idx = [];

if planner_mode == 1
    t0 = tic;
    [coste_global, ruta_idx] = dijkstra(C, idx_origen, idx_destino);
    t_plan = toc(t0);
    nombre_planificador = 'Dijkstra';
else
    C_eucl = construir_costes_euclideos(C, XY);
    t0 = tic;
    [coste_global, ruta_idx] = astar(C_eucl, XY, idx_origen, idx_destino);
    t_plan = toc(t0);
    nombre_planificador = 'A* (heuristica euclidea consistente)';
end

if isempty(ruta_idx)
    fprintf('\nNo existe ruta global entre nodo %d y nodo %d.\n', id_origen, id_destino);
    return;
end

ruta_ids = node_ids(ruta_idx);

fprintf('\nPlanificador: %s\n', nombre_planificador);
fprintf('Tiempo planificacion: %.6f s\n', t_plan);
fprintf('Coste global: %.4f\n', coste_global);
fprintf('Ruta (IDs): %s\n\n', mat2str(ruta_ids'));

%% 3) Navegacion local sobre subobjetivos (campos potenciales)
params = struct();
params.v = 0.7;                   % avance lineal por iteracion
params.D = 4.0;                   % rango de influencia repulsiva
params.alfa = 2.0;                % peso atraccion
params.beta = 0.3;                % peso repulsion — reducido para corridores estrechos
params.gamma_tan = 1.0;           % peso campo tangencial (mejora anti-minimos)
if ~usar_mejora
    params.gamma_tan = 0;         % desactiva campo tangencial
end
params.max_rango = 12;            % rango lidar simulado
params.angulos = -pi:(pi/180):pi; % 360° — evita oscilacion por lidar unilateral
params.goal_tol = 1.5;            % tolerancia de llegada a subobjetivo
params.max_iter_seg = 5000;
params.min_force = 1e-3;
params.progress_window = 100;     % ventana amplia: captura centering + avance en corredor
params.min_progress = -1.0;       % permite algo de retroceso (centering en corredor estrecho)
params.max_stuck_events = 8;
if ~usar_mejora
    params.max_stuck_events = inf;   % desactiva maniobra de escape por estancamiento
end
params.escape_step = 0.8;         % longitud del paso de escape
params.max_escape_trials = 24;
params.collision_margin = 0.35;   % radio de seguridad para colision

robot = [XY(idx_origen, 1), XY(idx_origen, 2), 0];
trayectoria = robot;

seg_log = {};
fallo = false;

for k = 2:numel(ruta_idx)
    subgoal = XY(ruta_idx(k), :);
    [robot, path_seg, reached, motivo] = navegar_hasta_subobjetivo(robot, subgoal, mapa, params);

    trayectoria = [trayectoria; path_seg]; %#ok<AGROW>
    seg_log{end+1} = sprintf('Tramo %d -> nodo %d: %s', k-1, ruta_ids(k), motivo); %#ok<AGROW>

    if ~reached
        fallo = true;
        break;
    end
end

%% 4) Visualizacion y resultado
figure('Name', 'Lab-MR 6 - Navegacion completa');
show(mapa);
hold on;
axis equal;
grid on;

% Grafo
h_nodes = plot(XY(:,1), XY(:,2), 'bo', 'MarkerFaceColor', [0.2 0.4 1], 'MarkerSize', 5);
for i = 1:n
    text(XY(i,1) + 0.8, XY(i,2) + 0.8, sprintf('%d', node_ids(i)), ...
        'FontSize', 7, 'Color', [0 0.2 0.7]);
end

dibujar_aristas(C, XY);
h_global = plot(XY(ruta_idx,1), XY(ruta_idx,2), 'y--', 'LineWidth', 1.5);

% Trayectoria real
h_local = plot(trayectoria(:,1), trayectoria(:,2), 'r', 'LineWidth', 1.8);
h_origen = plot(XY(idx_origen,1), XY(idx_origen,2), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 8);
h_destino = plot(XY(idx_destino,1), XY(idx_destino,2), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);

legend([h_nodes, h_global, h_local, h_origen, h_destino], ...
       {'Nodos', 'Ruta global', 'Trayectoria local', 'Origen', 'Destino'}, ...
       'Location', 'bestoutside');

if usar_mejora
    sufijo_mejora = 'con mejora';
else
    sufijo_mejora = 'sin mejora';
end
if ~fallo
    fprintf('Resultado: destino alcanzado.\n');
    title(sprintf('Destino alcanzado (%s, %s)', nombre_planificador, sufijo_mejora));
else
    fprintf('Resultado: no se ha podido llegar al destino.\n');
    title(sprintf('Fallo local (%s, %s)', nombre_planificador, sufijo_mejora));
end

% Exportacion automatica con nombre descriptivo
nombre_plan_corto = lower(strtok(nombre_planificador));
sufijo_archivo = strrep(sufijo_mejora, ' ', '_');
fichero_salida = sprintf('nav_%s_%d_a_%d_%s.jpg', ...
                          nombre_plan_corto, id_origen, id_destino, sufijo_archivo);
exportgraphics(gcf, fichero_salida, 'Resolution', 200);
fprintf('Figura exportada: %s\n', fichero_salida);

fprintf('\n--- Log por tramo ---\n');
for i = 1:numel(seg_log)
    fprintf('%s\n', seg_log{i});
end

%% 5) Comprobacion del caso del enunciado (24 -> 32)
if any(ruta_ids == 24) && any(ruta_ids == 32)
    fprintf('\nAviso: la ruta global pasa por la zona conflictiva entre nodos 24 y 32.\n');
else
    fprintf('\nNota: para forzar la zona conflictiva, prueba destinos del cuadrante inferior derecho.\n');
end


%% ==================== FUNCIONES LOCALES ====================
function [robot, path, reached, motivo] = navegar_hasta_subobjetivo(robot_in, subgoal, mapa, p)
    robot = robot_in;
    path = robot;
    reached = false;
    motivo = 'max_iter';

    d_hist = nan(p.progress_window, 1);
    stuck_events = 0;

    for it = 1:p.max_iter_seg
        d_goal = norm(subgoal - robot(1:2));
        if d_goal <= p.goal_tol
            reached = true;
            motivo = 'ok';
            return;
        end

        obs = rayIntersection(mapa, robot, p.angulos, p.max_rango);
        [F_att, F_rep, F_tan] = calcular_campos(robot, subgoal, obs, p);
        F_res = F_att + F_rep + F_tan;

        if norm(F_res) < p.min_force
            [robot_try, ok] = maniobra_escape(robot, subgoal, mapa, p);
            if ~ok
                motivo = 'fuerza_nula_sin_escape';
                return;
            end
            robot = robot_try;
            path = [path; robot]; %#ok<AGROW>
            continue;
        end

        theta = atan2(F_res(2), F_res(1));
        step = min(p.v, d_goal);
        cand = [robot(1) + step*cos(theta), robot(2) + step*sin(theta), theta];

        if hay_colision(cand(1:2), mapa, p.collision_margin)
            [robot_try, ok] = maniobra_escape(robot, subgoal, mapa, p);
            if ~ok
                motivo = 'colision_sin_escape';
                return;
            end
            robot = robot_try;
            path = [path; robot]; %#ok<AGROW>
            continue;
        end

        robot = cand;
        path = [path; robot]; %#ok<AGROW>

        d_hist = [d_hist(2:end); d_goal];
        if all(isfinite(d_hist))
            progreso = d_hist(1) - d_hist(end);
            if progreso < p.min_progress
                stuck_events = stuck_events + 1;
                [robot_try, ok] = maniobra_escape(robot, subgoal, mapa, p);
                if ok
                    robot = robot_try;
                    path = [path; robot]; %#ok<AGROW>
                    d_hist(:) = nan;
                end
            end
        end

        if stuck_events >= p.max_stuck_events
            motivo = 'minimo_local';
            return;
        end
    end
end

function [F_att, F_rep, F_tan] = calcular_campos(robot, subgoal, obs, p)
    pos = robot(1:2);

    % Atractivo hacia subobjetivo
    v_goal = subgoal - pos;
    F_att = p.alfa * v_goal / max(norm(v_goal), eps);

    % Puntos validos de lidar
    d = sqrt((obs(:,1)-pos(1)).^2 + (obs(:,2)-pos(2)).^2);
    valid = isfinite(obs(:,1)) & isfinite(obs(:,2)) & (d < p.D) & (d > 1e-6);

    obs_c = obs(valid, :);
    d_c = d(valid);

    % Repulsivo
    F_rep = [0, 0];
    for i = 1:size(obs_c, 1)
        di = max(d_c(i), 1e-3);
        v_rep = pos - obs_c(i,:);
        F_rep = F_rep + p.beta * (1/di - 1/p.D) * (1/di^2) * (v_rep / max(norm(v_rep), eps));
    end

    % Tangencial (mejora para evitar minimos locales): rodear obstaculos
    F_tan = [0, 0];
    if ~isempty(obs_c)
        [~, idx_near] = min(d_c);
        v_obs = obs_c(idx_near,:) - pos;
        v_goal_u = v_goal / max(norm(v_goal), eps);
        cross_z = v_goal_u(1)*v_obs(2) - v_goal_u(2)*v_obs(1);
        giro = sign(cross_z);
        if giro == 0
            giro = 1;
        end

        v_obs_u = v_obs / max(norm(v_obs), eps);
        if giro > 0
            tan_u = [-v_obs_u(2), v_obs_u(1)];
        else
            tan_u = [v_obs_u(2), -v_obs_u(1)];
        end

        factor = max(0, 1 - d_c(idx_near)/p.D);
        F_tan = p.gamma_tan * factor * tan_u;
    end
end

function [robot_out, ok] = maniobra_escape(robot, subgoal, mapa, p)
    ok = false;
    robot_out = robot;

    base = atan2(subgoal(2)-robot(2), subgoal(1)-robot(1));
    angs = base + linspace(-pi, pi, p.max_escape_trials);

    best_score = -inf;
    best_pose = robot;

    for a = angs
        cand = [robot(1) + p.escape_step*cos(a), robot(2) + p.escape_step*sin(a), a];
        if hay_colision(cand(1:2), mapa, p.collision_margin)
            continue;
        end

        clearance = estimar_clearance(cand, mapa, p);
        score = 0.4 * clearance - 0.6 * norm(subgoal - cand(1:2));

        if score > best_score
            best_score = score;
            best_pose = cand;
            ok = true;
        end
    end

    if ok
        robot_out = best_pose;
    end
end

function c = estimar_clearance(pose, mapa, p)
    obs = rayIntersection(mapa, pose, p.angulos, p.max_rango);
    d = sqrt((obs(:,1)-pose(1)).^2 + (obs(:,2)-pose(2)).^2);
    d = d(isfinite(d));
    if isempty(d)
        c = p.max_rango;
    else
        c = median(d);
    end
end

function b = hay_colision(pos, mapa, margen)
    muestras = [
        0, 0;
        margen, 0; -margen, 0;
        0, margen; 0, -margen;
        margen/sqrt(2), margen/sqrt(2);
        margen/sqrt(2), -margen/sqrt(2);
        -margen/sqrt(2), margen/sqrt(2);
        -margen/sqrt(2), -margen/sqrt(2)
    ];

    pts = pos + muestras;
    occ = getOccupancy(mapa, pts);
    b = any(occ > 0.5 | isnan(occ));
end

function C_e = construir_costes_euclideos(C, XY)
    n = size(C, 1);
    C_e = zeros(size(C));

    for i = 1:n
        vecinos = find(C(i,:) > 0);
        for j = vecinos
            C_e(i,j) = norm(XY(i,:) - XY(j,:));
        end
    end
end

function dibujar_aristas(C, XY)
    n = size(C, 1);
    for i = 1:n
        for j = i+1:n
            if C(i,j) > 0 || C(j,i) > 0
                plot([XY(i,1), XY(j,1)], [XY(i,2), XY(j,2)], '-', ...
                     'Color', [0.75 0.75 0.75], 'LineWidth', 0.5);
            end
        end
    end
end

function idx = argmax(v)
    [~, idx] = max(v);
end
