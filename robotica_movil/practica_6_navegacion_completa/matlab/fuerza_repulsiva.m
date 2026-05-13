function F = fuerza_repulsiva(pos, img)
% FUERZA_REPULSIVA  Campo repulsivo generado por los obstaculos del mapa.
%   Recorre una ventana cuadrada alrededor del robot y acumula la
%   contribucion de cada pixel obstaculo (img(y,x) == 0).
%
%   pos : posicion actual del robot [x, y]
%   img : imagen del mapa (uint8). Pixel negro (0) = obstaculo.

    K_rep = 20;     % ganancia repulsiva
    d0    = 6;      % distancia de accion

    F = [0 0];

    [x_max, y_max] = size(img);

    for i = -d0:d0
        for j = -d0:d0

            x = round(pos(1) + i);
            y = round(pos(2) + j);

            % Comprobar
            if x > 0 && x <= y_max && y > 0 && y <= x_max

                % Si es obstaculo (negro)
                if img(y, x) == 0

                    d = norm([i j]);

                    if d > 0 && d < d0
                        F = F + K_rep * (1/d - 1/d0) * (1/d^2) * ([i j]/d);
                    end
                end
            end
        end
    end
end
