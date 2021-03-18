close all
clear
%% Task 1
raw_data = xlsread('muscle_data_2017.xlsx');        	% extracting raw data
strain = raw_data(:,3);
stress = raw_data(:,4);

h_1 = figure(1);                                        % plotting raw data
plot(strain ,stress ,'b-','Linewidth',3);
xlabel('Strain', 'fontsize', 20);
ylabel('Stress [kPa]', 'fontsize', 20);

n_y = length(stress);                       % Number of elements in data set

%% Task 2
sse_per_m = zeros(1,5);                 %initialising arrays
m = (1:1:5);                            % model order array

for k = m(1) : m(5)                     % calculating sse for every model order
    
    p = polyfit(strain, stress,m(k));
    f = polyval(p, strain);
    error_temp = (stress - f).^2;
    
    sse_per_m(k) = sum(error_temp);   	% sse for each model order
end

h_2 = figure(2);                      	% plotting sse per model order

plot(m, sse_per_m,'r-','linewidth', 3);
xlabel('Model Order', 'fontsize', 20);
ylabel('Sum Squared Error', 'fontsize', 20);

my_m = 3;                            	% chosen model order

%% Task 3
pfit_temp =  polyfit(strain, stress, my_m); % For visual conveniece
est_stress = polyval( pfit_temp, strain);   % Estimate model of order 3

figure(1);                              % Plotting chosed estimate on figure1
hold on;
plot( strain,est_stress , 'r-', 'linewidth', 2);

%% Task 4
error_m1 = (stress - est_stress);              	% Calculates error
mean_stress = mean(stress);                    	% Observed data mean
se_t = (stress - mean_stress).^2;

h_3 = figure(3);                               	% Plotting error histogram
histogram(error_m1);
xlabel('Error in Polynomial Fit', 'fontsize', 20);
ylabel('Frequency', 'fontsize', 20);

sse_t = sum(se_t);                            	% Sum Squared Error of mean
sse_r = sse_per_m(3);                          	% Sum Squared Residual
ccoef_p = (sse_t - sse_r) / sse_t;              % Coefficient of determination 1


%% Task 5
%finding coefficients a0, a1, a2 with fminsearch & the error funciton
a = fminsearch( @(x) func( x, stress, strain), [0.3;0.3;0.3]);

y_hat = 1 - a(3) - (a(1) * exp(a(2) *strain)); 	% model with fminsearch coeffs

figure(1);                                  	% plotting model2 data
plot(strain, y_hat, 'black--', 'Linewidth', 3);

legend('raw data','3rd order polyfit model', 'fminsearch model',...
        'location','NW', 'fontsize', 12 );

%% Task 6
err_nl = stress - y_hat;                    % error for model2
se_t2 = (stress - mean_stress).^2;      	% squared error
se_r2 = (stress - y_hat).^2;                % squared error of residuals

sse_t2 = sum(se_t2);                     	% Sum Squared Error of mean
sse_r2 = sum(se_r2);                       	% Sum Squared Residual

ccoef_nl = (sse_t2 - sse_r2) / sse_t2;      % Coefficient of determination (2)
standard_deviation = sqrt( sse_t2 / n_y );
standard_error = standard_deviation/ sqrt(n_y);

hist_title = ['Std error = ', num2str(standard_error), ' r = ', num2str(ccoef_nl)];

figure(3);
hold on;
histogram( err_nl);
title( hist_title, 'fontsize', 20);
legend('polyfit model', 'fminsearch model', 'location', 'NW', 'fontsize', 12);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The lines below here just check that you have addressed the variables
% required in the assignment.
%% Check my variables
if (~exist('a'))
    fprintf('\nVariable "a" does not exist.')
end;
if (~exist('err_nl'))
    fprintf('\nVariable "err_nl" does not exist.')
end;
if (~exist('ccoef_nl'))
    fprintf('\nVariable "ccoef_nl" does not exist.')
end;
if (~exist('ccoef_p'))
    fprintf('\nVariable "ccoef_p" does not exist.')
end;
if (~exist('est_stress'))
    fprintf('\nVariable "est_stress" does not exist.')
end;
if (~exist('my_m'))
    fprintf('\nVariable "my_m" does not exist.')
end;
if (~exist('sse_per_m'))
    fprintf('\nVariable "sse_per_m" does not exist.')
end;
fprintf('\n');

%% Function that calculates sse of the [ yˆk = 1 − a2 − (a0 exp(a1φk)) ] model

function sse_from_func = func(x, stress, strain)

estimate2 = zeros(1,length(strain));                            % array for storing estimate values from new model
err_temp_store = zeros(1,length(strain));                       % temporary storage of error values for summing


for k = 1:length(strain)                                        % calculating estimate values from new model
    estimate2(k) = 1 - x(3) - (x(1) * exp(x(2) * strain(k)));
end


for k = 1:length(strain)                                        % calculating sum squared error
    err_temp_store(k) = (stress(k) - estimate2(k))^2;
end

sse_from_func = sum(err_temp_store);                        	% final value of sum squred error based on model

end