% AMPLIACION DE ROBOTICA — Lab-MR 6: Navegacion completa
% Planificacion global (Dijkstra) + navegacion local reactiva (campos potenciales).
%
% Genera automaticamente cuatro figuras:
%   nav_dijkstra_1_a_12_sin_mejora.jpg
%   nav_dijkstra_1_a_12_con_mejora.jpg
%   nav_dijkstra_24_a_32_sin_mejora.jpg
%   nav_dijkstra_24_a_32_con_mejora.jpg

clc; clearvars; close all;

%% 0) Carga del mapa y el grafo topologico
img  = imread(fullfile('datos', 'mapa2.pgm'));
% flipud: las filas de imagen crecen hacia abajo; binaryOccupancyMap espera
% fila 1 = y maximo. Con flipud la fila de imagen R queda en world y ≈ R.
mapa = binaryOccupancyMap(flipud(imbinarize(imcomplement(img))));
run(fullfile('datos', 'mapa2.m'));   % define: nodos [id,x,y], costes

XY = nodos(:, 2:3);   % coordenadas mundo (x, y) de cada nodo

%% 1) Parametros del campo potencial
p.v        = 1.0;          % avance por iteracion (celdas)
p.D        = 7.0;          % radio de influencia repulsiva
p.alfa     = 1.5;          % ganancia campo atractivo
p.beta     = 6.0;          % ganancia campo repulsivo (con promediado por N_hit)
p.angulos  = linspace(-pi, pi - 2*pi/72, 72)';  % 72 rayos, 360 grados
p.goal_tol = 2.0;          % tolerancia para dar subobjetivo por alcanzado
p.max_iter = 4000;         % iteraciones maximas por tramo
p.margin   = 0.1;          % radio de seguridad (corridores de 3px requieren margen minimo)
% Deteccion de estancamiento
p.win      = 200;          % ventana de observacion (iteraciones)
p.min_prog = 0.5;          % avance minimo hacia el objetivo en la ventana (celdas)
p.max_stuck = 4;           % maximo de eventos de escape (Inf = sin mejora, desactiva escape)
% Maniobra de escape (solo actua si max_stuck < Inf)
p.esc_step = 3.0;          % longitud del paso de escape
p.n_esc    = 36;           % direcciones de prueba

%% 2) Demo 1: nodo 1 a nodo 12 (parte superior derecha del mapa)
fprintf('=== Demo 1: nodo 1 -> nodo 12 ===\n');
[~, ruta_12] = dijkstra(costes, 1, 12);
fprintf('Ruta Dijkstra: %s\n', num2str(ruta_12));

p_sin = p; p_sin.max_stuck = inf;   % sin mejora: sin limite de escapes
[tray_sm, log_sm] = navegar(mapa, XY, ruta_12, p_sin);
[tray_cm, log_cm] = navegar(mapa, XY, ruta_12, p);

imprimir_log(log_sm, 'Sin mejora 1->12');
imprimir_log(log_cm, 'Con mejora 1->12');

guardar_figura(mapa, XY, costes, ruta_12, tray_sm, log_sm, ...
               'nav_dijkstra_1_a_12_sin_mejora.jpg', 'Sin mejora');
guardar_figura(mapa, XY, costes, ruta_12, tray_cm, log_cm, ...
               'nav_dijkstra_1_a_12_con_mejora.jpg', 'Con mejora');

%% 3) Demo 2: nodo 24 a nodo 32 (zona conflictiva inferior derecha)
fprintf('\n=== Demo 2: nodo 24 -> nodo 32 (zona conflictiva) ===\n');
[~, ruta_32] = dijkstra(costes, 24, 32);
fprintf('Ruta Dijkstra: %s\n', num2str(ruta_32));

[tray_sm2, log_sm2] = navegar(mapa, XY, ruta_32, p_sin);
[tray_cm2, log_cm2] = navegar(mapa, XY, ruta_32, p);

imprimir_log(log_sm2, 'Sin mejora 24->32');
imprimir_log(log_cm2, 'Con mejora 24->32');

guardar_figura(mapa, XY, costes, ruta_32, tray_sm2, log_sm2, ...
               'nav_dijkstra_24_a_32_sin_mejora.jpg', 'Sin mejora');
guardar_figura(mapa, XY, costes, ruta_32, tray_cm2, log_cm2, ...
               'nav_dijkstra_24_a_32_con_mejora.jpg', 'Con mejora');

fprintf('\nFiguras generadas.\n');


%% =====================================================================
%%  FUNCIONES LOCALES
%% =====================================================================

% --- Navegacion completa sobre una ruta de subobjetivos ---------------
function [tray, seg_log] = navegar(mapa, XY, ruta, p)
    pos   = [XY(ruta(1),1), XY(ruta(1),2), 0];
    tray  = pos;
    seg_log = {};
    for k = 2:numel(ruta)
        goal = XY(ruta(k), :);
        [pos, seg_tray, motivo] = navegar_tramo(pos, goal, mapa, p);
        tray = [tray; seg_tray]; %#ok<AGROW>
        seg_log{end+1} = sprintf('Tramo %d->%d: %s', ruta(k-1), ruta(k), motivo); %#ok<AGROW>
        if ~strcmp(motivo, 'ok')
            break;
        end
    end
end

% --- Navegacion de un tramo (pos_ini hasta goal) ----------------------
function [pos, tray, motivo] = navegar_tramo(pos_ini, goal, mapa, p)
    pos    = pos_ini;
    tray   = pos;
    motivo = 'max_iter';
    stuck_events = 0;
    d_hist = nan(p.win, 1);

    for it = 1:p.max_iter
        xy     = pos(1:2);
        d_goal = norm(goal - xy);

        % Condicion de llegada
        if d_goal <= p.goal_tol
            motivo = 'ok';
            return;
        end

        % ---- Campos de fuerza ----
        % Atractivo (unitario hacia el subobjetivo)
        F_att = p.alfa * (goal - xy) / max(d_goal, eps);

        % Repulsivo: lidar 360 grados, promediado por numero de impactos
        pts  = rayIntersection(mapa, pos, p.angulos, p.D);
        F_rep = [0, 0];
        N_hit = 0;
        for i = 1:size(pts, 1)
            if ~isnan(pts(i, 1))
                di = norm(pts(i,:) - xy);
                if di > 1e-4
                    N_hit = N_hit + 1;
                    v_rep = (xy - pts(i,:)) / di;
                    F_rep = F_rep + p.beta * (1/di - 1/p.D) / di^2 * v_rep;
                end
            end
        end
        if N_hit > 0
            F_rep = F_rep / N_hit;
        end

        % Fuerza resultante
        F = F_att + F_rep;
        if norm(F) < 1e-4
            F = F_att;
        end
        dir   = F / norm(F);
        paso  = min(p.v, d_goal);
        theta = atan2(dir(2), dir(1));

        % Mover en la direccion deseada; si hay colision, reducir el paso
        for escala = [1.0, 0.5, 0.25, 0.1]
            cand = xy + paso * escala * dir;
            if ~en_colision(cand, mapa, p.margin)
                pos  = [cand, theta];
                tray = [tray; pos]; %#ok<AGROW>
                break;
            end
        end

        % ---- Deteccion de estancamiento ----
        d_hist = [d_hist(2:end); norm(goal - pos(1:2))];
        if all(isfinite(d_hist)) && (d_hist(1) - d_hist(end)) < p.min_prog
            stuck_events = stuck_events + 1;
            d_hist(:) = nan;
            % Con mejora: intenta escapar del minimo local
            if isfinite(p.max_stuck)
                if stuck_events >= p.max_stuck
                    motivo = 'minimo_local';
                    return;
                end
                [pos_esc, ok] = escapar(pos, goal, mapa, p);
                if ok
                    pos  = pos_esc;
                    tray = [tray; pos]; %#ok<AGROW>
                end
            end
        end
    end
end

% --- Maniobra de escape desde un minimo local -------------------------
function [pos_out, ok] = escapar(pos, goal, mapa, p)
    ok      = false;
    pos_out = pos;
    angs    = linspace(-pi, pi - 2*pi/p.n_esc, p.n_esc);
    best    = -inf;
    for a = angs
        cand = pos(1:2) + p.esc_step * [cos(a), sin(a)];
        if en_colision(cand, mapa, p.margin), continue; end
        cl = estimar_clearance(cand, mapa, p);
        sc = 0.5*cl - 0.5*norm(goal - cand);
        if sc > best
            best    = sc;
            theta_c = atan2(goal(2)-cand(2), goal(1)-cand(1));
            pos_out = [cand, theta_c];
            ok      = true;
        end
    end
end

% --- Clearance media estimada con lidar simulado ----------------------
function c = estimar_clearance(cand, mapa, p)
    pose = [cand(1), cand(2), 0];
    pts  = rayIntersection(mapa, pose, p.angulos, p.D);
    d    = sqrt(sum((pts - cand).^2, 2));
    d    = d(isfinite(d));
    if isempty(d), c = p.D; else, c = median(d); end
end

% --- Comprobacion de colision (muestreo circular) ---------------------
function b = en_colision(pos, mapa, m)
    s  = m / sqrt(2);
    muestras = [0 0; m 0; -m 0; 0 m; 0 -m; s s; s -s; -s s; -s -s];
    pts = bsxfun(@plus, muestras, pos(1:2));
    occ = getOccupancy(mapa, pts);
    b   = any(occ > 0.5 | isnan(occ));
end

% --- Impresion del log de tramos --------------------------------------
function imprimir_log(seg_log, etiqueta)
    fprintf('[%s]\n', etiqueta);
    for i = 1:numel(seg_log)
        fprintf('  %s\n', seg_log{i});
    end
end

% --- Exportar figura --------------------------------------------------
function guardar_figura(mapa, XY, costes, ruta, tray, seg_log, fname, sufijo)
    fig = figure('Visible','off','Position',[50 50 900 900]);
    show(mapa);
    hold on; axis equal;

    n = size(XY, 1);

    % Aristas del grafo (gris claro)
    for i = 1:n
        for j = i+1:n
            if costes(i,j) > 0 || costes(j,i) > 0
                plot([XY(i,1) XY(j,1)], [XY(i,2) XY(j,2)], ...
                     '-', 'Color', [0.72 0.72 0.72], 'LineWidth', 0.5);
            end
        end
    end

    % Nodos
    plot(XY(:,1), XY(:,2), 'o', 'Color', [0.2 0.45 0.9], ...
         'MarkerFaceColor', [0.2 0.45 0.9], 'MarkerSize', 5);
    for i = 1:n
        text(XY(i,1)+0.8, XY(i,2)+0.8, num2str(i), ...
             'FontSize', 6.5, 'Color', [0 0.15 0.6]);
    end

    % Ruta global Dijkstra (amarillo discontinuo)
    plot(XY(ruta,1), XY(ruta,2), 'y--', 'LineWidth', 2);

    % Trayectoria real del robot (rojo)
    if size(tray, 1) > 1
        plot(tray(:,1), tray(:,2), 'r-', 'LineWidth', 1.6);
    end

    % Origen (verde) y destino (magenta)
    plot(XY(ruta(1),1),   XY(ruta(1),2),   'go', ...
         'MarkerFaceColor','g','MarkerSize',10);
    plot(XY(ruta(end),1), XY(ruta(end),2), 'mo', ...
         'MarkerFaceColor','m','MarkerSize',10);

    % Titulo con resultado del ultimo tramo
    if isempty(seg_log)
        estado = 'sin tramos';
    else
        estado = seg_log{end};
    end
    title(sprintf('%s  |  %d \\rightarrow %d  |  %s', ...
                  sufijo, ruta(1), ruta(end), estado), ...
          'Interpreter', 'tex');

    exportgraphics(fig, fname, 'Resolution', 200);
    fprintf('Exportado: %s\n', fname);
    close(fig);
end
