function [coste, ruta] = Aestrella(G, H, origen, destino)
% AESTRELLA Algoritmo A* sobre grafo dirigido con heuristica externa.
%
%   [coste, ruta] = Aestrella(G, H, origen, destino)
%
% Entradas:
%   G       : matriz NxN de costes (G(i,j) > 0 indica arco i->j).
%   H       : matriz NxN de heuristicas (H(i,j) = estimacion de coste i->j).
%   origen  : nodo inicial (1..N).
%   destino : nodo final  (1..N).
%
% Salidas:
%   coste : coste minimo total (Inf si no hay camino).
%   ruta  : vector [origen ... destino], o [] si no existe ruta.

    N = size(G,1);

    abiertos = origen;          % Lista de nodos abiertos
    cerrados = [];              % Lista de nodos cerrados

    g = inf(1,N);               % Coste real desde origen
    f = inf(1,N);               % Coste total estimado
    padre = zeros(1,N);         % Para reconstruir camino

    g(origen) = 0;
    f(origen) = H(origen,destino);

    while ~isempty(abiertos)

        % Nodo con menor f
        [~, idx] = min(f(abiertos));
        actual = abiertos(idx);

        % Si llegamos al destino, reconstruir camino
        if actual == destino
            ruta = actual;
            while actual ~= origen
                actual = padre(actual);
                ruta = [actual ruta]; %#ok<AGROW>
            end
            coste = g(destino);
            return;
        end

        % Mover nodo a cerrados
        abiertos(idx) = [];
        cerrados = [cerrados actual]; %#ok<AGROW>

        % Explorar vecinos
        for vecino = 1:N
            if G(actual,vecino) > 0  % Hay conexion

                if ismember(vecino, cerrados)
                    continue;
                end

                coste_temp = g(actual) + G(actual,vecino);

                if ~ismember(vecino, abiertos)
                    abiertos = [abiertos vecino]; %#ok<AGROW>
                elseif coste_temp >= g(vecino)
                    continue;
                end

                % Mejor camino encontrado
                padre(vecino) = actual;
                g(vecino) = coste_temp;
                f(vecino) = g(vecino) + H(vecino,destino);
            end
        end
    end

    % Si no hay solucion
    coste = inf;
    ruta = [];
end
