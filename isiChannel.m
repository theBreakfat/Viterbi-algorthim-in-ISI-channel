function Y = isiChannel(isiChannelIR,X,SNRIndB)
% �ú������ź�Xͨ��һ��ISI�ŵ������Ӹ�˹��������ISI�ŵ���������Ӧ�������
% Params��
%   impulseResponseLen��ISI�ŵ�������Ӧ����
%   X���źţ���һ������
%   SNRIndB�������(dB)
% return��
%   h��ISI�ŵ��ĵ�λ������Ӧ
%   Y������Xͨ��ISI�ŵ����������������


Y = conv(X,isiChannelIR);%�ź�Xͨ��ISI�ŵ�
sigPower = sum(abs(X).^2)/length(X);
% SNR = 10^(SNRIndB/10);%����SNR(linear)
% noisePower = sigPower/SNR;
Y = awgn(Y,SNRIndB,sigPower);%�Ӹ�˹������
% noise = sqrt(noisePower)*randn(1,length(Y));
% Y = Y + noise;