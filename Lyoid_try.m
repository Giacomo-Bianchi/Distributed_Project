clear all;
close all;
clc;

% Parameters
DO_SIMULATION = true;

% Define the number of points and grid dimensions
numPoints = 4;      % Set the number of points you want to generate
dimgrid = [500 500];   % Define the height of the grid
kp = 20;

points = zeros(numPoints,2);

% Generate random positions for each point
x = rand(numPoints, 1) * 100;   % Random x coordinates
y = rand(numPoints, 1) * 100;  % Random y coordinates

points = [x,y];

% Plot the points on a figure
figure(1);
scatter(points(:,1),points(:,2));
axis([0 dimgrid(1) 0 dimgrid(2)]); 
xlabel('X Coordinate');
ylabel('Y Coordinate');
title(sprintf('Randomly Placed %d Points', numPoints));

% Compute and plot Voronoi tessellation
[vx, vy] = voronoi(points(:,1), points(:,2));

figure(2);
hold on;
plot(vx, vy, 'r-', 'LineWidth', 1.5);
axis([0 dimgrid(1) 0 dimgrid(2)]); 
scatter(points(:,1),points(:,2));
title('Voronoi Tassellation');

%% Funzione densità per incendi 

% Definizione dei parametri della densità
x_incendio = 400;
y_incendio = 400;
sigma = 30;

% Creazione della griglia di punti
[x_m, y_m] = meshgrid(1:dimgrid(1), 1:dimgrid(2));

% Calcolo della distribuzione gaussiana
G = exp(-(((x_m - x_incendio).^2) / (2 * sigma^2) + ((y_m - y_incendio).^2) / (2 * sigma^2)));

% Visualizzazione della matrice
imagesc(G);
colormap jet;
colorbar;
title('Funzione densità: Incendi');

% Visualizzazione in 3D
figure(3);
surf(x_m, y_m, G);
shading interp; % Per rendere la superficie più liscia
colormap jet;
colorbar;
xlabel('X');
ylabel('Y');
zlabel('Densità');
title('Funzione densità: Incendi');
view(3); % Vista in 3D

%% Compute Voronoi tessellation using voronoin
[areas,centroids,vel] = voronoi_function(dimgrid,points,kp,G);

sum_areas = sum(areas);
for i = 1:length(areas)
    fprintf('areas%d: %f\n',i,areas(i));
end
disp(sum_areas)
for i = 1:length(areas)
    fprintf('centroids coordinates %d: [%f,%f]\n',i,centroids(i,1),centroids(i,2));
end
disp(sum_areas)

%% Simulation 

dt = 0.01;
T_sim = 100;

trajectories = zeros(numPoints,2,T_sim);

nx = points;
trajectories(:,:,1) = nx;

% Prepare figure for simulation
figure(4);
colors = lines(numPoints);
hold on;
axis([0 dimgrid(1) 0 dimgrid(2)]);
xlabel('X Coordinate');
ylabel('Y Coordinate');
title('Lloyd Simulation');

if DO_SIMULATION
    for t = 2:T_sim

        if t > T_sim/2
            G = ones(dimgrid(1),dimgrid(2));
        end
        % Compute Voronoi tessellation and centroids
        [areas, centroids, vel] = voronoi_function(dimgrid, nx, kp, G);
        
        % Update positions using 2D velocity vectors
        nx = nx + vel * dt;
        
        % Save the updated positions into the trajectories array
        trajectories(:, :, t) = nx;
    
        % Clear the figure and replot everything using arrays of points
        % clf;  % Clear the current figure
        % hold on;
        
        % Plot the trajectory for each drone up to the current time
        for i = 1:numPoints
            % Extract the trajectory so far (squeeze the slice into a 2D array)
            traj = squeeze(trajectories(i, :, 1:t));
            plot(traj(1, :), traj(2, :), '-', 'Color', colors(i,:), 'LineWidth', 1.5);
            % Plot the current drone position as a marker
            plot(nx(i, 1), nx(i, 2), 'o', 'Color', colors(i,:), 'MarkerSize', 8, 'MarkerFaceColor', colors(i,:));
        end


        
        drawnow;  % Force MATLAB to update the figure
        % Optionally add a pause (e.g., pause(0.01)) to slow down the simulation for visualization
    end
end