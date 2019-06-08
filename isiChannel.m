function Y = isiChannel(isiChannelIR,X,SNRIndB)
% 该函数将信号X通过一个ISI信道，并加高斯白噪声，ISI信道的脉冲响应随机产生
% Params：
%   impulseResponseLen：ISI信道脉冲响应长度
%   X：信号，是一个向量
%   SNRIndB：信噪比(dB)
% return：
%   h：ISI信道的单位脉冲响应
%   Y：向量X通过ISI信道并加噪声后的向量


Y = conv(X,isiChannelIR);%信号X通过ISI信道
sigPower = sum(abs(X).^2)/length(X);
% SNR = 10^(SNRIndB/10);%计算SNR(linear)
% noisePower = sigPower/SNR;
Y = awgn(Y,SNRIndB,sigPower);%加高斯白噪声
% noise = sqrt(noisePower)*randn(1,length(Y));
% Y = Y + noise;