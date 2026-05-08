% VALIDAR_DIJKSTRA  Reproduce los casos del enunciado de Lab-MR 4.
%
% Bloque A: grafo de ejemplo de 7 nodos del enunciado.
%           dijkstra(G, 1, 7) debe dar coste = 7, ruta = [1 2 4 6 7].
%
% Bloque B: 8 casos sobre el grafo grande de grafos.mat (matriz J,
%           25 nodos, dirigida y asimetrica).

clc; clearvars; close all;

%% ============================================================
%% BLOQUE A: Grafo de ejemplo del enunciado (7 nodos)
%% ============================================================
G = [0 2 0 0 9 0 0;
     2 0 1 2 0 0 0;
     0 1 0 5 0 0 0;
     0 2 5 0 1 2 4;
     9 0 0 1 0 4 0;
     0 0 0 2 4 0 1;
     0 0 0 4 0 1 0];

XY7 = [4.0  6.0;   % 1 (arriba)
       5.0  4.5;   % 2
       7.0  4.0;   % 3
       5.5  3.0;   % 4 (centro)
       1.5  3.0;   % 5 (izquierda)
       3.0  1.5;   % 6
       4.0  0.0];  % 7 (abajo)

fprintf('========================================\n');
fprintf('BLOQUE A: grafo del enunciado (7 nodos)\n');
fprintf('========================================\n');
[coste_A, ruta_A] = dijkstra(G, 1, 7);
fprintf('  dijkstra(G, 1, 7)\n');
fprintf('  Resultado: coste = %g, ruta = [%s]\n', coste_A, num2str(ruta_A));
fprintf('  Esperado : coste = 7, ruta = [1 2 4 6 7]\n');
ok_A = (coste_A == 7) && isequal(ruta_A, [1 2 4 6 7]);
fprintf('  Validacion: %s\n\n', ternario(ok_A, 'OK', 'FALLO'));

% Figura del bloque A: grafo de 7 nodos con la ruta resaltada
dG7 = digraph(G);
fig_A = figure('Position', [100 100 700 600], 'Color', 'w');
p = plot(dG7, 'XData', XY7(:,1), 'YData', XY7(:,2), ...
              'NodeColor', [0.85 0.85 0.85], ...
              'EdgeColor', [0.85 0.85 0.85], ...
              'EdgeLabel', dG7.Edges.Weight, ...
              'NodeFontSize', 11, 'EdgeFontSize', 9, ...
              'LineWidth', 0.8, 'MarkerSize', 7);
highlight(p, ruta_A, 'EdgeColor', 'r', 'LineWidth', 2.5, ...
                      'NodeColor', 'r', 'MarkerSize', 9);
title(sprintf('dijkstra(G, 1, 7)  —  coste = %g, ruta = [%s]', coste_A, num2str(ruta_A)));
axis equal off;
exportgraphics(fig_A, 'dijkstra_ejemplo7.jpg', 'Resolution', 200);

%% ============================================================
%% BLOQUE B: grafos.mat (matriz J, 25 nodos, dirigida y asimetrica)
%% ============================================================
data = load('grafos.mat');
J = data.J;
n = size(J, 1);
fprintf('========================================\n');
fprintf('BLOQUE B: grafos.mat - matriz J (%dx%d)\n', n, n);
fprintf('========================================\n');
fprintf('Nota: J es dirigida y asimetrica.\n\n');

casos = {
    1,  19, 16, [1 7 13 17 23 18 19];
    19, 1,  19, [19 20 15 10 5 9 8 3 2 1];
    25, 19, 11, [25 20 15 14 18 19];
    19, 25, 4,  [19 20 25];
    1,  23, 12, [1 7 13 17 23];
    23, 1,  22, [23 18 14 15 10 5 9 8 3 2 1];
    1,  24, Inf, [];
    23, 22, 40, [23 18 14 15 10 5 9 8 3 2 1 7 13 17 12 11 16 22];
};

resultados = cell(size(casos,1), 1);
todos_ok = true;
for i = 1:size(casos, 1)
    s = casos{i,1};  t = casos{i,2};
    coste_esp = casos{i,3};  ruta_esp = casos{i,4};

    [coste, ruta] = dijkstra(J, s, t);

    if isinf(coste_esp) && isinf(coste)
        ok = isempty(ruta);
    else
        ok = (coste == coste_esp) && isequal(ruta, ruta_esp);
    end
    todos_ok = todos_ok && ok;
    resultados{i} = struct('s', s, 't', t, 'coste', coste, 'ruta', ruta, 'ok', ok);

    if isinf(coste)
        fprintf('  %2d -> %2d :  coste = Inf, ruta = []  %s\n', s, t, ternario(ok, '[OK]', '[FALLO]'));
    else
        fprintf('  %2d -> %2d :  coste = %g, ruta = [%s]  %s\n', ...
                s, t, coste, num2str(ruta), ternario(ok, '[OK]', '[FALLO]'));
    end
end
fprintf('\n');
fprintf('Resultado global del bloque B: %s\n\n', ternario(todos_ok, 'TODOS OK', 'HAY FALLOS'));

%% --- Helper local ---
function s = ternario(cond, si, no)
    if cond, s = si; else, s = no; end
end
