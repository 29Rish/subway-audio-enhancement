% Example of time varying Wiener filter function
% Need spectrogram matlab function!

clear all
clc
close all

% Synthetized signal
% Sampling frequency 1 kHz
% Chirp: start at 50 Hz and cross 450 Hz at 10 s with strong Gussian background noise (SNR -18 dB)

fs = 1000;
T = 10;
t=0:1/fs:T;
r=chirp(t,50,T,450);
L = length(r);
wnoise = 6 .* randn(size(r));
x = wnoise + r;

figure
spectrogram(r,256,250,256,1E3);
view(-45,65)
colormap bone
title('Reference signal')


figure
subplot(1,2,1)
spectrogram(x,256,250,256,1E3);
view(-45,65)
colormap bone
title('Noisy signal')

Lw = 256;
[xest,B,Nblocks] = ADwienerFilt(x,r,Lw);

subplot(1,2,2)
spectrogram(xest,256,250,256,1E3);
view(-45,65)
colormap bone
title('Estimated signal')