%This removes the noise at target frequencies

Audiofile = 'videoplayback.wav'; 
% Name of the Input Audio Signal

[Input_Signal, Sampling_frequency]=audioread(Audiofile);
% Audio signal's Sample Amplitude is stored in "Input_signal" ---
% Audio signal's Sampling Frequency is stored "Sampling_frequency"

Col1 = Input_Signal(:,1);
Col2 = Input_Signal(:,2);

figure(1)
spectrogram(Col1);
% Show the Time-Frequency plot of input signal

xlabel('STFT of Input Signal')

sound(Input_Signal,Sampling_frequency)
% Play Input Audio file that contain noise 

pause(10)
% Pause the execution of further code------

% In the STFT plot at .4535 pi radian per sample There is constant
% ammplitude beep that can be removed using a notch filter

%A notch filter is designed to target the unwanted frequency (e.g., at 0.4535? radians/sample).
%iirnotch function generates the filter’s numerator (Num) and denominator (Den) coefficients.
%Bandwidth controls the sharpness of the notch around Wc.

Wc = 0.4535;  Bandwidth = Wc/35;
% wo is the cutoff frequency and bw is the bandwidth

[Num,Den] = iirnotch(Wc,Bandwidth);
% Filter Coefficients calculated 

figure(2)
freqz(Num,Den)
% Display Filter Amplitude and phase response

xlabel('Notch Bandstop filter response')

Filtered_Signal=filter(Num,Den,Input_Signal);  
% Passing a signal through Designed Notch filter

figure(3)
spectrogram(Filtered_Signal(:,1))
xlabel('Spectrogram After filtering')

sound(Filtered_Signal,Sampling_frequency)
% Play Filtered Audio signal