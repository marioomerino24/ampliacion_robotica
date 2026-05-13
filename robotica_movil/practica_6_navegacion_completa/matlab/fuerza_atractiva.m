function F = fuerza_atractiva(pos, objetivo)
% FUERZA_ATRACTIVA  Campo atractivo lineal hacia el objetivo.
%   F = K_att * (objetivo - pos)
%
%   pos      : posicion actual del robot [x, y]
%   objetivo : posicion del subobjetivo  [x, y]
%   F        : vector fuerza atractiva   [Fx, Fy]

    K_att = 2;          % ganancia del campo atractivo
    F = K_att * (objetivo - pos);
end
