%==========================================================================
%                     ParaTUS Mask Generation
%==========================================================================
f_square = [2.5]; 
dc_square = [50]; 
weights_square = [1]
f_pure = [7000 500];
weights_pure = [1 1]; 
weights_noise = .5; 
fs = 44100; 
duration = 1.5; 
t = 0:1/fs:duration-1/fs;


squareWaves = zeros(length(f_square), length(t)); 
sinWaves = zeros(length(f_pure), length(t)); 

% Generate square waves
for i = 1:length(f_square)
    frequency = f_square(i);
    dutyCycle = dc_square(i);
    squareWaves(i, :) = (square(2 * pi * frequency * t, dutyCycle) + 1);
    squareWaves(i, :) = squareWaves(i, :)-1 * weights_square(i); 
    
    figure
    plot(squareWaves(i,:))
end


% Generate sinusoidal waves
for i = 1:length(f_pure)
    frequency = f_pure(i);
    sinWaves(i, :) = sin(2 * pi * frequency * t) * weights_pure(i);
    
    figure
    plot(sinWaves(i,:))
end


% Generate Gaussian white noise 
noiseWave = randn(1,length(t)); 
noiseWave = noiseWave./max(max(noiseWave)); 
noiseWave = noiseWave*weights_noise; 
figure 
plot(noiseWave)

% Combine signals
combined_signal = zeros(1,length(t)); 
for i = 1:size(squareWaves,1)
    combined_signal = combined_signal+squareWaves(i,:); 
end 
for i = 1:size(sinWaves,1)
    combined_signal = combined_signal.*sinWaves(i,:); 
end 
figure
plot(combined_signal)

combined_signal = combined_signal + noiseWave
figure
plot(combined_signal)

maxAbsValue = max(abs(combined_signal));
if maxAbsValue > 1
    combined_signal = combined_signal / maxAbsValue;
end
figure
plot(combined_signal)


figure
plot(t, combined_signal, 'LineWidth',0.5); % Plot the square wave
xlabel('Time (s)');
ylabel('Amplitude');
title('');
axis([0 1 -1.2 1.2]); % Adjust the axis to better visualize the wave
grid on; % Add a grid for easier visualization
% Save the waveform as a WAV file
filename = 'mask_v1.wav';
audiowrite(filename, combined_signal, fs);

sound(combined_signal, fs);
