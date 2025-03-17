
clc
clear
load ("SAMPLE_Saline_CMG.mat")
% load Spike 2 FIle

x = Pressure.times;
y1 = Pressure.values;
y2 = Volume.values;
y3 = VMR.values;

Pressure_values = Pressure.values;
Pressure_times = Pressure.times;


%%Great to find Pmax, need to adjust the P value if it cant find the peak

P=90;
findpeaks(Pressure_values,Pressure_times,'MinPeakDistance',P)
[pmax,time]= findpeaks(Pressure_values,Pressure_times,'MinPeakDistance',P);
pmax
ICI= (diff(time))

%% FIND PBASE


t=eval('Pressure.times');         % time range of whole experiment
Fs=1/eval('Pressure.interval');   % sampling frequency

% Set threshold for peak detection
threshold =16.5;  % Adjust this threshold value as per your requirement

% Find peaks in the pressure signal above the threshold
[pbase, locs] = findpeaks(-Pressure_values, 'MinPeakHeight', -threshold,'MinPeakProminence', 1, ...
     'MinPeakDistance', 80 ...
     *Fs);

pbase = -pbase


% Plot the pressure signal with peak markers
figure;
plot(Pressure_times, Pressure_values);
hold on;
    plot(Pressure_times(locs), pbase, 'ro', 'MarkerSize', 8);
hold off;
title('Pbase');
xlabel('Time');
ylabel('Pressure');
legend('Pressure Signal', 'Peaks');

%% Finding void volume 

% First change the Volume curve into something that is more linear 
[AB,BC,CD,]= ischange(y2);
plot(x,BC);

%set the threshold of change to be detected between voids 
threshold = 0.01;

% calculate the differences between adjacent elements in BC
dBC = diff(BC);

% find the indices where the difference is greater than the threshold
step_change_idx = find(abs(dBC) > threshold);

% calculate the values of each step change
step_change_vals = BC(step_change_idx);

% calculate the differences between adjacent step change values
step_change_diffs = diff(step_change_vals);

% print out the indices and values of up to three step changes
num_step_changes = min(length(step_change_idx), 5);
if num_step_changes > 0;
    
    for i = 1:num_step_changes 
    end
    fprintf('Voiding Volme:\n');
    for i = 1:num_step_changes-1
        fprintf('%d to %d: %.2f\n', i, i+1, step_change_diffs(i));
    end
  
else
    fprintf('No step change detected\n');
end

 
%% CMG VMR 
Pressure_values = Pressure.values;
Pressure_times = Pressure.times;

t=eval('Pressure.times');         % time range of whole experiment
Fs=1/eval('Pressure.interval');   % sampling frequency

% Set threshold for peak detection
threshold =18.8;  % Adjust this threshold value as per your requirement

% Find peaks in the pressure signal above the threshold_ adjust distance

[pks, locs] = findpeaks(-Pressure_values, 'MinPeakHeight', -threshold,'MinPeakProminence', 1, ...
     'MinPeakDistance', 80 ...
     *Fs);

pks = -pks;


% Plot the pressure signal with peak markers
figure;
plot(Pressure_times, Pressure_values);
hold on;
plot(Pressure_times(locs), pks, 'ro', 'MarkerSize', 8);
hold off;
title('Pressure Signal with Peaks');
xlabel('Time');
ylabel('Pressure');
legend('Pressure Signal', 'Peaks');

VMR_values= VMR.values;
VMR_times = VMR.times; 

% Set the window duration in seconds
window_duration =20;

% Calculate AUC for each peak location
num_peaks = numel(locs);
auc_values = zeros(num_peaks, 1);
auc_values_clean = zeros(num_peaks, 1);

figure;
hold on;

for i = 1:num_peaks
    peak_loc = locs(i);
    start_time = peak_loc/Fs - window_duration;
    end_time = peak_loc/Fs;

    start_time_noise = peak_loc/Fs - window_duration - window_duration;
    end_time_noise = peak_loc/Fs - window_duration;
    
    % Find the indices within the specified window
    indices = find(VMR_times >= start_time & VMR_times <= end_time);
    noise_indices = find(VMR_times >= start_time_noise & VMR_times <= end_time_noise);
    
    % Extract the VMR values within the window
    window_VMR = VMR_values(indices);
    window_times = VMR_times(indices);

    window_VMR_noise = VMR_values(noise_indices);
    window_times_noise = VMR_times(noise_indices);
    
    % Plot the VMR values within the window
    plot(window_times, window_VMR);
    plot(window_times_noise, window_VMR_noise);
    
    % Calculate the AUC using the trapezoidal rule
    auc_values(i) = trapz(window_times, abs(window_VMR));
    auc_values_clean(i) = auc_values(i) - trapz(window_times_noise, abs(window_VMR_noise));
end

hold off;

% Set plot title and labels
title('VMR minus basline');
xlabel('Time');
ylabel('VMR');

auc_values_clean
 




