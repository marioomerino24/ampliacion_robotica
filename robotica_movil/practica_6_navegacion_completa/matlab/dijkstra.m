function [coste, ruta] = dijkstra(G, origen, destino)
% DIJKSTRA Calcula la ruta de coste minimo en un grafo dirigido.
%   [coste, ruta] = dijkstra(G, origen, destino)
%
% Entradas:
%   G       : matriz NxN de costes (G(i,j) > 0 indica arco i->j)
%   origen  : nodo inicial (1..N)
%   destino : nodo final (1..N)
%
% Salidas:
%   coste   : coste minimo total (Inf si no hay camino)
%   ruta    : vector [origen ... destino], o [] si no existe ruta
%
% Nota para grafos.mat:
%   Las matrices (G, H, J, F, E, K) usan 0 para "sin arco".
%   El algoritmo asume precisamente ese convenio.
%   Si se pasa el struct de load(...), se usa J por defecto (si existe).

    %% 1) Validaciones basicas
    if isstruct(G)
        if isfield(G, 'J')
            G = G.J;
        else
            f = fieldnames(G);
            found = false;
            for i = 1:numel(f)
                A = G.(f{i});
                if isnumeric(A) && ismatrix(A) && size(A,1) == size(A,2)
                    G = A;
                    found = true;
                    break;
                end
            end
            if ~found
                error('El struct no contiene ninguna matriz de costes NxN.');
            end
        end
    end

    G = double(G);
    n = size(G, 1);
    if size(G, 2) ~= n
        error('G debe ser cuadrada (NxN).');
    end
    if ~isnumeric(G) || any(~isfinite(G(:))) || any(G(:) < 0)
        error('G debe contener costes numericos finitos y no negativos.');
    end
    if any(diag(G) ~= 0)
        warning('La diagonal de G no es cero; se ignoraran autolazos con coste 0.');
    end
    if origen < 1 || origen > n || destino < 1 || destino > n
        error('origen/destino fuera de rango.');
    end
    if origen == destino
        coste = 0;
        ruta = origen;
        return;
    end

    %% 2) Inicializacion de estructuras
    dist = inf(1, n);
    prev = zeros(1, n);      % 0 = sin predecesor
    visitado = false(1, n);
    dist(origen) = 0;

    %% 3) Bucle principal de Dijkstra
    while true
        no_visitados = find(~visitado);
        if isempty(no_visitados)
            break;
        end

        [~, idx_local] = min(dist(no_visitados));
        u = no_visitados(idx_local);

        % Si el menor ya es infinito, el resto es inalcanzable
        if isinf(dist(u))
            break;
        end

        visitado(u) = true;

        % Corte temprano al llegar al destino
        if u == destino
            break;
        end

        % Relajacion de aristas salientes u -> v
        % Convenio del enunciado: G(u,v) > 0 implica arco u->v.
        vecinos = find(G(u, :) > 0);
        for v = vecinos
            if visitado(v)
                continue;
            end

            alt = dist(u) + G(u, v);
            if alt < dist(v)
                dist(v) = alt;
                prev(v) = u;
            end
        end
    end

    %% 4) Reconstruccion de ruta
    if isinf(dist(destino))
        coste = Inf;
        ruta = [];
        return;
    end

    coste = dist(destino);
    ruta = destino;
    while ruta(1) ~= origen
        p = prev(ruta(1));
        if p == 0
            coste = Inf;
            ruta = [];
            return;
        end
        ruta = [p, ruta]; %#ok<AGROW>
    end
end
