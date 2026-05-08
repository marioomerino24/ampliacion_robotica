% VALIDAR_AESTRELLA  Reproduce los tres casos del enunciado de Lab-MR 5.
%
%   Caso 1: aestrella(G, H, 1, 7)  -> debe dar coste = 7, ruta = [1 2 4 6 7]
%   Caso 2: aestrella(G, H, 7, 4)  -> da resultado SUB-OPTIMO
%                                     (la H del enunciado no es admisible
%                                      para el destino 4)
%   Caso 3: aestrella(G, H', 7, 4) -> con una H' admisible, recupera el
%                                     camino optimo 7 -> 6 -> 4 (coste 3).

clc; clearvars; close all;

%% Datos del enunciado
G = [0 2 0 0 9 0 0;
     2 0 1 2 0 0 0;
     0 1 0 5 0 0 0;
     0 2 5 0 1 2 4;
     9 0 0 1 0 4 0;
     0 0 0 2 4 0 1;
     0 0 0 4 0 1 0];

H = [0 2 5 5 5 6 9;
     2 0 2 3 6 6 8;
     5 2 0 2 6 6 7;
     5 3 2 0 5 4 6;
     5 6 6 5 0 1 5;
     6 6 6 4 1 0 1;
     9 8 7 6 5 1 0];

% Coordenadas aproximadas para el dibujo (segun el grafo del enunciado)
XY = [ 4.0  6.0;   % 1 (arriba)
       5.0  4.5;   % 2
       7.0  4.0;   % 3
       5.5  3.0;   % 4 (centro)
       1.5  3.0;   % 5 (izquierda)
       3.0  1.5;   % 6
       4.0  0.0];  % 7 (abajo)

%% Caso 1: 1 -> 7 con H del enunciado
fprintf('========================================\n');
fprintf('Caso 1: aestrella(G, H, 1, 7)\n');
[coste1, ruta1] = aestrella(G, H, 1, 7);
fprintf('  Resultado obtenido: coste = %g, ruta = [%s]\n', coste1, num2str(ruta1));
fprintf('  Resultado esperado: coste = 7, ruta = [1 2 4 6 7]\n');
ok1 = (coste1 == 7) && isequal(ruta1, [1 2 4 6 7]);
fprintf('  Validacion: %s\n\n', ternario(ok1, 'OK', 'FALLO'));

%% Caso 2: 7 -> 4 con H del enunciado (NO optimo)
fprintf('========================================\n');
fprintf('Caso 2: aestrella(G, H, 7, 4)\n');
[coste2, ruta2] = aestrella(G, H, 7, 4);
fprintf('  Resultado obtenido: coste = %g, ruta = [%s]\n', coste2, num2str(ruta2));
fprintf('  Optimo real (Dijkstra): coste = 3, ruta = [7 6 4]\n');
fprintf('  Observacion: H(7,4) = %d sobreestima el coste real (3).\n', H(7,4));
fprintf('               La heuristica NO es admisible para destino 4 ->\n');
fprintf('               A* devuelve una ruta sub-optima.\n\n');

%% Caso 3: 7 -> 4 con H' admisible
% Heuristica admisible: en la columna del destino 4 sustituimos los
% valores que sobreestiman h*(i, 4) por los valores reales (calculados
% con Dijkstra sobre G; aqui los listamos directamente).
fprintf('========================================\n');
fprintf('Caso 3: aestrella(G, H_admisible, 7, 4)\n');
H_adm = H;
H_adm(:, 4) = [4; 2; 3; 0; 1; 2; 3];   % h*(:,4) calculado con Dijkstra sobre G
[coste3, ruta3] = aestrella(G, H_adm, 7, 4);
fprintf('  Heuristica corregida (columna del destino 4):\n');
fprintf('    H_adm(:,4) = [%s]''\n', num2str(H_adm(:,4)'));
fprintf('  Resultado obtenido: coste = %g, ruta = [%s]\n', coste3, num2str(ruta3));
fprintf('  Resultado esperado: coste = 3, ruta = [7 6 4]\n');
ok3 = (coste3 == 3) && isequal(ruta3, [7 6 4]);
fprintf('  Validacion: %s\n\n', ternario(ok3, 'OK', 'FALLO'));

%% Figura: tres paneles del grafo con cada ruta resaltada
fig = figure('Position', [100 100 1500 500], 'Color', 'w');

paneles = {
    struct('titulo', 'Caso 1:  1 \rightarrow 7  con H  (optimo)', ...
           'ruta',   ruta1, 'extremos', [1 7]);
    struct('titulo', 'Caso 2:  7 \rightarrow 4  con H  (sub-optimo, H no admisible)', ...
           'ruta',   ruta2, 'extremos', [7 4]);
    struct('titulo', 'Caso 3:  7 \rightarrow 4  con H'' admisible  (optimo)', ...
           'ruta',   ruta3, 'extremos', [7 4]);
};

dG = digraph(G);
for k = 1:3
    subplot(1, 3, k);
    p = plot(dG, 'XData', XY(:,1), 'YData', XY(:,2), ...
                 'NodeColor', [0.85 0.85 0.85], ...
                 'EdgeColor', [0.85 0.85 0.85], ...
                 'EdgeLabel', dG.Edges.Weight, ...
                 'NodeLabel', arrayfun(@num2str, 1:size(G,1), 'UniformOutput', false), ...
                 'NodeFontSize', 11, 'EdgeFontSize', 9, ...
                 'LineWidth', 0.8, 'MarkerSize', 7);
    if ~isempty(paneles{k}.ruta)
        highlight(p, paneles{k}.ruta, 'EdgeColor', 'r', 'LineWidth', 2.5, ...
                                       'NodeColor', 'r', 'MarkerSize', 9);
    end
    highlight(p, paneles{k}.extremos(1), 'NodeColor', [0 0.6 0]);
    highlight(p, paneles{k}.extremos(2), 'NodeColor', [0.7 0 0.7]);
    title(paneles{k}.titulo);
    axis equal off;
end
sgtitle('Lab-MR 5 — Validacion de A* sobre el grafo del enunciado');

%% Exportar
exportgraphics(fig, 'aestrella_casos.jpg', 'Resolution', 200);
fprintf('Figura exportada como aestrella_casos.jpg\n');

%% --- Helper local ---
function s = ternario(cond, si, no)
    if cond, s = si; else, s = no; end
end
