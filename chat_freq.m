% Step 1: Read the audio file
[audioIn, fs] = audioread('videoplayback.wav');

% Step 2: Apply STFT
window = hamming(1024); % Use a Hamming window of size 1024
overlap = 512; % 50% overlap
nfft = 1024; % FFT size

[S, f, t] = stft(audioIn, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', nfft);

% Step 3: Frequency filtering
% Define the frequency range to remove (e.g., between 1000 Hz and 3000 Hz)
freqLower = 1000; % Lower bound in Hz
freqUpper = 3000; % Upper bound in Hz

% Find the indices corresponding to the desired frequency range
freqIndices = (f >= freqLower) & (f <= freqUpper);

% Zero out the specified frequency range
S(freqIndices, :) = 0; % This will remove the specified frequencies

% Step 4: Apply inverse STFT
audioOut = istft(S, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', nfft);

% Step 5: Normalize and save the output
audioOut = audioOut / max(abs(audioOut)); % Normalize the output
audiowrite('filtered_audio.wav', audioOut, fs);

% Optional: Plot the original and filtered signals for comparison
figure;
subplot(2, 1, 1);
plot((1:length(audioIn)) / fs, audioIn);
title('Original Audio');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot((1:length(audioOut)) / fs, audioOut);
title('Filtered Audio');
xlabel('Time (s)');
ylabel('Amplitude');
