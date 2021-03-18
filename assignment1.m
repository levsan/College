close all
clear
%% PART 1                                                                   Plot the measured values of velocity versus time from the JumpData.CSV file
jumpdata = csvread('RedBullJumpData.csv');                                      % Read data from file
t_redbull = jumpdata(:,1);                                                      % First column is time in secs
v_redbull = jumpdata(:,2);                                                      % Second column is velocity
terminal_velocity = jumpdata(:,3);                                              % Third column is theoretical terminal velocity at that time
N_timestamps = length(t_redbull);

figure(1);
h_part1 = plot(t_redbull, v_redbull, 'r-x', 'linewidth', 2.0);                  %plot
shg;
hold on;

grid on;                                                                        % This is how to put on a grid
axis([0 180 0 400]);                                                            % This is how to fix an axis to a desired size

%% PART 2                                                                   Calculate and plot freefall velocity without drag effects
g = 9.81;
v_freefall = t_redbull * g;                                                     %Freefall velocity vector calculation

h_part2 = plot(t_redbull, v_freefall, 'b--','linewidth',2.0);
shg;

title('Figure 1','fontsize',25);                                                % Setting the fontsize and label of the graph 
ylabel('Velocity (m/s)','fontsize',24,'color','b');
xlabel('Time (sec)','fontsize',24,'color','b');

%% PART 3                                                                   Estimate the time at which Mr. B. starts to enter the atmosphere.
close_v_values=find(abs(v_freefall-v_redbull) > (v_redbull*0.05),1);            % Finds values of terminal v and actual v within a tolerance of 0.05 i.e 5%
hit_instant = t_redbull(close_v_values);                                        % This is fixed :)

fprintf('\nMr. B hits the earth''s atmoshpere at %d secs after he jumps\n\n',hit_instant);

%% PART 4                                                                   Now starting from the velocity at t = 56 let's update and calculate v
v_numerical_1 = zeros(1, N_timestamps);
drag_constant = 3/60;
start = find(t_redbull == 56);                                                  % Finding the desired t value location in array

v_numerical_1(1:start) = v_redbull(1:start);

for k = start: (N_timestamps-1)
    update = (g - drag_constant*v_numerical_1(k)) * (t_redbull(k+1)-t_redbull(k));
    v_numerical_1(k+1) = v_numerical_1(k) + update;
end

h_part4 = plot(t_redbull, v_numerical_1, 'g--','linewidth',2.0);shg             % Plot using the dashed green line

%% PART 5                                                                   Calculate the percentage error as required
s_64 = find(t_redbull == 64);                                                   % Finding the desired t value locations in array
s_170 = find(t_redbull == 170);
error_64 = 100 * ( abs(v_numerical_1(s_64)-v_redbull(s_64))/ v_redbull(s_64));  % Calculating percentage error
error_170 = 100 * ( abs(v_numerical_1(s_170)-v_redbull(s_170))/ v_redbull(s_170));

per_error = [error_64 error_170];                                               % Assigning error values to array
fprintf('Percentage error at 64 & 170 sec is %1.1f and ', per_error(1));
fprintf('%3.1f  respectively \n\n', per_error(2));

%% PART 6                                                                   Calculating v with a different drag constant (personal estimate)
est_drag_constant = 0.0556501;                                                  % my estimated value for drag_constant based on % error reading at t = 69
start2 = find(t_redbull == 56);
v_numerical_2(1:start2) = v_redbull(1:start2);                                  % setting up array for euler solution

for k = start2: (N_timestamps-1)
    update = (g - est_drag_constant*v_numerical_2(k)) * (t_redbull(k+1)-t_redbull(k));
    v_numerical_2(k+1) = v_numerical_2(k) + update;
end
                                                                                % Handle plot for part 6
h_part6 = plot(t_redbull(start2:end), v_numerical_2(start2:end), 'black--', 'linewidth', 2.0);
shg

s_69 = find(t_redbull==69);                                                     % finding the desired t value loaction
est_error = 100 * ( abs(v_numerical_2(s_69)-v_redbull(s_69))/ v_redbull(s_69));
fprintf('The error at t = 69 secs using my estimated drag constant (%f) is %f\n\n', est_drag_constant,est_error);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DO NOT EDIT BELOW THIS LINE THIS IS TO MAKE SURE YOU HAVE USED THE
% VARIABLES THAT WE ASKED FOR
% Check for existence of variables
if (~exist('v_freefall', 'var'))
    error('The variable v_freefall does not exist.')
end
if (~exist('hit_instant', 'var'))
    error('The variable hit_instant does not exist.')
end
if (~exist('per_error', 'var'))
    error('The variable per_error does not exist.')
end
if (exist('per_error', 'var'))
    l = size(per_error);
    if ( sum(l - [1 2]) ~= 0)
        error('per_error is not a 2 element vector. Please make it so.')
    end
end
if (~exist('v_numerical_1', 'var'))
    error('The variable v_numerical_1 does not exist.')
end
if (~exist('est_error', 'var'))
    error('The variable est_error does not exist.')
end
if (~exist('h_part1', 'var'))
    error('The plot handle h_part11 is missing. Please create it as instructed.')
end
if (~exist('h_part2', 'var'))
    error('The plot handle h_part11 is missing. Please create it as instructed.')
end
if (~exist('h_part4', 'var'))
    error('The plot handle h_part11 is missing. Please create it as instructed.')
end
if (~exist('h_part6', 'var'))
    error('The plot handle h_part11 is missing. Please create it as instructed.')
end