img = imread(fullfile('datos','mapa2.pgm'));
mapa = binaryOccupancyMap(flipud(imbinarize(imcomplement(img))));
run(fullfile('datos','mapa2.m'));
XY = nodos(:,2:3);
pos1 = [XY(1,1), XY(1,2), 0];
pos2 = XY(2,:);

fprintf('Node 1: (%.1f, %.1f)  Node 2: (%.1f, %.1f)\n', pos1(1),pos1(2),pos2(1),pos2(2));
d12 = norm(pos2-pos1(1:2));
fprintf('Direction 1->2: (%.3f, %.3f)\n', (pos2(1)-pos1(1))/d12, (pos2(2)-pos1(2))/d12);

fprintf('\nOccupancy grid around node 1 (x=1..8, y=142..150):\n');
fprintf('      x: 1 2 3 4 5 6 7 8\n');
for y = 150:-1:142
    row_str = sprintf('y=%3d: ', y);
    for x = 1:8
        occ = getOccupancy(mapa, [x, y]);
        if isnan(occ)||occ>0.5, row_str = [row_str 'X ']; else row_str = [row_str '. ']; end
    end
    fprintf('%s\n', row_str);
end

angulos = linspace(-pi, pi-2*pi/72, 72)';
pts = rayIntersection(mapa, pos1, angulos, 7.0);
F_att = 1.5*(pos2-pos1(1:2))/max(d12,eps);
F_rep = [0,0]; N_hit = 0;
for i=1:size(pts,1)
    if ~isnan(pts(i,1))
        di = norm(pts(i,:)-pos1(1:2));
        if di>1e-4
            N_hit=N_hit+1;
            v=(pos1(1:2)-pts(i,:))/di;
            F_rep=F_rep+6*(1/di-1/7)/di^2*v;
        end
    end
end
if N_hit>0, F_rep=F_rep/N_hit; end
F_tot=F_att+F_rep;
fprintf('\nAt node 1: N_hit=%d\n', N_hit);
fprintf('  F_att = (%.3f, %.3f)  |F|=%.3f\n', F_att(1),F_att(2),norm(F_att));
fprintf('  F_rep = (%.3f, %.3f)  |F|=%.3f\n', F_rep(1),F_rep(2),norm(F_rep));
fprintf('  F_tot = (%.3f, %.3f)  |F|=%.3f\n', F_tot(1),F_tot(2),norm(F_tot));
dir = F_tot/norm(F_tot);
fprintf('  Direction: (%.3f, %.3f)\n', dir(1), dir(2));

step = pos1(1:2) + dir;
occ_step = getOccupancy(mapa, step);
fprintf('  Step to (%.2f, %.2f), occ=%.0f\n', step(1),step(2), occ_step);

% Try several step candidates
fprintf('\nCandidates from node 1 (step=1):\n');
test_angs = linspace(-pi, pi, 17); test_angs = test_angs(1:end-1);
for a = test_angs
    cand = pos1(1:2) + [cos(a), sin(a)];
    occ = getOccupancy(mapa, cand);
    fprintf('  angle=% .1f deg -> (%.1f,%.1f), occ=%s\n', a*180/pi, cand(1),cand(2), num2str(occ));
end
