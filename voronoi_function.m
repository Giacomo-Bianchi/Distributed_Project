function [areas, weigth_centroids, w_vel] = voronoi_function(Map, c_points, kp, G)
    % Crea una griglia di punti con le dimensioni specificate da Map
    [X, Y] = meshgrid(1:Map(1), 1:Map(2));
    voronoi_grid = [X(:), Y(:)];

    % Estrai le coordinate x e y dei punti iniziali
    c_x = c_points(:, 1);
    c_y = c_points(:, 2);

    % Calcola le distanze tra i punti iniziali e ciascun punto sulla griglia
    distances = pdist2(voronoi_grid, c_points);

    % Trova l'indice del punto iniziale più vicino per ciascun punto sulla griglia
    [~, minimum_indices] = min(distances, [], 2);

    % Assegna l'indice a ciascun punto sulla griglia
    indices_cell = reshape(minimum_indices, Map);

    % Inizializza le aree, i centroidi e i vettori di velocità
    areas = zeros(length(c_x), 1);
    centroids = zeros(length(c_x), 2);
    vel = zeros(length(c_x), 2);
    masses = zeros(length(c_x), 1);

    for i = 1:length(c_x)
        % Estrai i punti della regione assegnata al drone i
        region_points = voronoi_grid(minimum_indices == i, :); % Punti della regione

        % Calcola l'area della regione
        areas(i) = size(region_points, 1);

        weigth_region_points = zeros(size(region_points,1),2);

        % Calcolo della massa della regione
        masses(i) = sum(G(sub2ind(size(G), region_points(:,2), region_points(:,1))));

        % Calcolo del centroide pesato
        weights = G(sub2ind(size(G), region_points(:,2), region_points(:,1)));  % Estrai i pesi dalla matrice G
        weigth_centroids(i, :) = sum(region_points .* weights, 1) / masses(i);  % Formula del centroide pesato


        % for k = 1:size(region_points,1)
        %     masses(i) = masses(i) + G(region_points(k,1),region_points(k,2));
        %     weigth_region_points = region_points * G(region_points(k,1),region_points(k,2));
        % end

        % Calcola il centroide della regione
        centroids(i, :) = round(mean(region_points));
        % weigth_centroids(i,:) = round(mean(weigth_region_points));

        % Calcola il vettore di velocità
        vel(i, :) = kp * (centroids(i, :) - c_points(i, :));
        w_vel(i, :) = kp * (weigth_centroids(i, :) - c_points(i, :));

    end

    % Plot della tassellazione di Voronoi
    figure(4)
    imagesc(indices_cell);
    hold on;
    scatter(centroids(:, 1), centroids(:, 2), 60);
    % scatter(c_points(:, 1), c_points(:, 2), 60, 'x');
end