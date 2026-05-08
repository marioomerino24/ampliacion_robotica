function [coste, ruta] = astar(G, nodos, origen, destino)
% ASTAR Ruta de coste minimo usando A* con heuristica euclidea.
%   [coste, ruta] = astar(G, nodos, origen, destino)
%
% Entradas:
%   G       : matriz NxN de costes (G(i,j) > 0 indica arco i->j)
%   nodos   : Nx2 (x,y) o NxM (x,y en columnas 1 y 2)
%   origen  : nodo inicial (1..N)
%   destino : nodo final (1..N)
%
% Salidas:
%   coste   : coste minimo total (Inf si no hay camino)
%   ruta    : vector [origen ... destino], o [] si no existe ruta

    G = double(G);
    n = size(G, 1);

    if size(G, 2) ~= n
        error('G debe ser cuadrada (NxN).');
    end
    if ~isnumeric(G) || any(~isfinite(G(:))) || any(G(:) < 0)
        error('G debe contener costes finitos y no negativos.');
    end
    if size(nodos, 1) ~= n || size(nodos, 2) < 2
        error('nodos debe ser Nx2 (o NxM con x,y en columnas 1 y 2).');
    end
    if origen < 1 || origen > n || destino < 1 || destino > n
        error('origen/destino fuera de rango.');
    end
    if origen == destino
        coste = 0;
        ruta = origen;
        return;
    end

    % Heuristica euclidea: consistente si G usa tambien distancia euclidea.
    h = @(i) norm(nodos(i,1:2) - nodos(destino,1:2));

    g_score = inf(1, n);
    f_score = inf(1, n);
    prev = zeros(1, n);

    abierto = false(1, n);
    cerrado = false(1, n);

    g_score(origen) = 0;
    f_score(origen) = h(origen);
    abierto(origen) = true;

    while any(abierto)
        candidatos = find(abierto);

        % Desempate: menor f y, en empate, menor h.
        fvals = f_score(candidatos);
        [~, m1] = min(fvals);
        empates = candidatos(fvals == fvals(m1));
        if numel(empates) > 1
            hvals = arrayfun(h, empates);
            [~, m2] = min(hvals);
            u = empates(m2);
        else
            u = candidatos(m1);
        end

        if u == destino
            break;
        end

        abierto(u) = false;
        cerrado(u) = true;

        vecinos = find(G(u, :) > 0);
        for v = vecinos
            if cerrado(v)
                continue;
            end

            tentative_g = g_score(u) + G(u, v);
            if ~abierto(v)
                abierto(v) = true;
            elseif tentative_g >= g_score(v)
                continue;
            end

            prev(v) = u;
            g_score(v) = tentative_g;
            f_score(v) = tentative_g + h(v);
        end
    end

    if isinf(g_score(destino))
        coste = Inf;
        ruta = [];
        return;
    end

    coste = g_score(destino);
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
