function [coste, ruta] = aestrella(G, H, origen, destino)
% AESTRELLA Algoritmo A* sobre grafo dirigido con heuristica externa.
%
%   [coste, ruta] = aestrella(G, H, origen, destino)
%
% Entradas:
%   G       : matriz NxN de costes (G(i,j) > 0 indica arco i->j de peso G(i,j)).
%   H       : matriz NxN de heuristicas (H(i,j) = estimacion del coste de i a j).
%   origen  : indice de nodo inicial (1..N).
%   destino : indice de nodo final  (1..N).
%
% Salidas:
%   coste : coste total de la ruta encontrada (Inf si no es alcanzable).
%   ruta  : vector [origen ... destino], o [] si no existe ruta.
%
% Notas:
%   - Si la heuristica H es admisible (H(n, destino) <= h*(n, destino) para
%     todo n), A* devuelve la ruta optima.
%   - Si la heuristica no es admisible (sobreestima h*), A* puede devolver
%     una ruta sub-optima.
%   - El convenio del enunciado es G(i,j) = 0 para "no hay arco". Los pesos
%     deben ser no negativos.

    %% 1) Validaciones de entrada
    G = double(G);
    H = double(H);
    n = size(G, 1);
    if size(G, 2) ~= n
        error('aestrella: G debe ser cuadrada (NxN).');
    end
    if any(size(H) ~= [n, n])
        error('aestrella: H debe ser NxN con la misma N que G.');
    end
    if any(~isfinite(G(:))) || any(G(:) < 0)
        error('aestrella: G debe contener costes finitos y no negativos.');
    end
    if any(~isfinite(H(:))) || any(H(:) < 0)
        error('aestrella: H debe contener heuristicas finitas y no negativas.');
    end
    if origen < 1 || origen > n || destino < 1 || destino > n
        error('aestrella: origen/destino fuera de rango.');
    end
    if origen == destino
        coste = 0;
        ruta = origen;
        return;
    end

    %% 2) Inicializacion
    g_score = inf(1, n);    g_score(origen) = 0;
    f_score = inf(1, n);    f_score(origen) = H(origen, destino);
    prev    = zeros(1, n);                       % 0 = sin predecesor
    abierto = false(1, n);  abierto(origen) = true;
    cerrado = false(1, n);

    %% 3) Bucle principal
    while any(abierto)
        % Selecciona el nodo abierto con menor f
        cand = find(abierto);
        [~, idx_local] = min(f_score(cand));
        u = cand(idx_local);

        % Corte temprano: destino alcanzado
        if u == destino
            break;
        end

        abierto(u) = false;
        cerrado(u) = true;

        % Relajacion de aristas u -> v
        vecinos = find(G(u, :) > 0);
        for v = vecinos
            if cerrado(v)
                continue;
            end
            g_tentativo = g_score(u) + G(u, v);
            if g_tentativo < g_score(v)
                prev(v)    = u;
                g_score(v) = g_tentativo;
                f_score(v) = g_tentativo + H(v, destino);
                abierto(v) = true;
            end
        end
    end

    %% 4) Reconstruccion de la ruta
    if isinf(g_score(destino))
        coste = Inf;
        ruta  = [];
        return;
    end

    coste = g_score(destino);
    ruta  = destino;
    while ruta(1) ~= origen
        p = prev(ruta(1));
        if p == 0
            coste = Inf;
            ruta  = [];
            return;
        end
        ruta = [p, ruta]; %#ok<AGROW>
    end
end
