
function [xest,W,Nblocks] = ADwienerFilt(x,r,Lw)
%
% Wiener filter based on STFT
%   This function takes as inputs a noisy signal, x, and a reference signal, r,
%   in order to compute a bank of linear filters that provides an estimate of y
%   from x. This kind of Wiener filter based on short-time Fourier
%   transform so it can deal with non-stationary signals.
%
%   Note 1: window length (Lw) must be even
%   Note 2: overlap is fixed at 50%
%   Note 3: the filtered signal can be shortened
%
% INPUTS
% x = noisy signal
% r = reference signal
% Nw = window length
% Nblocks = total number of segments
%
% OUTPUTS
% xest = estimated signal
% W = matrix of Wiener filters

% M. Buzzoni
% Feb 2020

% window length must be even
if mod(Lw,2)~=0
    Lw = Lw - 1;
    disp('Window length must be an even number. Lw has been changed accordingly.')
end

L = length(x);
win = hanning(Lw);
overlap = Lw/2;
Nblocks = floor((L / (Lw/2) ) - 1);

Sxx = zeros(Nblocks,Lw);
Sxr = zeros(Nblocks,Lw);
W  = zeros(Nblocks,Lw);
xest = zeros(size(r));
ind = 1:Lw;

for j = 1:Nblocks
    
    temp = zeros(size(r));
        
    X = 1/Lw .* fft(x(ind));
    R = 1/Lw .* fft(r(ind));
    Sxx(j,:) = X .* conj(X);
    Sxr(j,:) = X .* conj(R);
    W(j,:) = Sxr(j,:) ./ Sxx(j,:);
        
    temp(ind) = Lw/2 * ifft(W(j,:) .* X);  
    xest = xest + temp;
        
    ind = ind + Lw/2;
    
end

ind = ind - Lw/2;

if L ~= ind(end)
    disp('Note that the length of the recovered signal has been shortened!')
end

xest((ind(end)+1):L)=[];
