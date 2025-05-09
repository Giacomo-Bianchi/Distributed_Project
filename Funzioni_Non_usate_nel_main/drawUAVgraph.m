function h = drawUAVgraph(X, Y, Theta, dim, col)
    % Returns an array of line‐object handles
    s = dim;
    h = gobjects(5,1);
    h(1) = line(...
        [X+s*cos(Theta+3*pi/5), X+s*cos(Theta-3*pi/5)], ...
        [Y+s*sin(Theta+3*pi/5), Y+s*sin(Theta-3*pi/5)], ...
        'Color', col);
    h(2) = line(...
        [X+s*cos(Theta+3*pi/5), X+1.5*s*cos(Theta)], ...
        [Y+s*sin(Theta+3*pi/5), Y+1.5*s*sin(Theta)], ...
        'Color', col);
    h(3) = line(...
        [X+1.5*s*cos(Theta), X+s*cos(Theta-3*pi/5)], ...
        [Y+1.5*s*sin(Theta), Y+s*sin(Theta-3*pi/5)], ...
        'Color', col);
    % Caster & centre:
    h(4) = line([X+s*cos(Theta), X+s*cos(Theta)], ...
                [Y+s*sin(Theta), Y+s*sin(Theta)], ...
                'Color', col);
    h(5) = line([X, X], [Y, Y], 'Color', col);
end
