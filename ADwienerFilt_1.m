clear all
clc
close all

% Load the audio file
[audio_signal, fs] = audioread('videoplayback.wav'); % replace with your audio file name
audio_signal = audio_signal(:,1); % Use first channel if stereo
T = length(audio_signal) / fs; % Duration of the audio in seconds
t = (0:1/fs:T - 1/fs)'; % Time vector

sound(audio_signal,fs)
pause(10)

% Add Gaussian noise (optional for demonstration)
SNR = -18; % Signal-to-Noise Ratio
noise_amplitude = rms(audio_signal) / (10^(SNR/20));
wnoise = noise_amplitude * randn(size(audio_signal));
x = audio_signal + wnoise; % Noisy signal

% Display Spectrograms
figure
subplot(1,2,1)
spectrogram(audio_signal, 256, 250, 256, fs);
view(-45,65)
colormap bone
title('Original Signal')

subplot(1,2,2)
spectrogram(x, 256, 250, 256, fs);
view(-45,65)
colormap bone
title('Noisy Signal')

% Wiener Filter Parameters
Lw = 256; % Length of filter window

% Apply Adaptive Wiener Filter (assuming ADwienerFilt function exists)
[xest, B, Nblocks] = ADwienerFilt(x, audio_signal, Lw);

% Display Spectrogram of the Filtered Signal
figure
spectrogram(xest, 256, 250, 256, fs);
view(-45,65)
colormap bone
title('Filtered Signal (Estimated)')

% Play the filtered audio
sound(xest, fs)
pause(length(xest)/fs) % Pause for playback duration
