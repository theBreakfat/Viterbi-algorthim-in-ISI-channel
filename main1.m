% �ó���ʵ�ַ��Ͷ˷ֱ����BPSK��QPSK��16QAM���ƣ�
% �źž���ISI�ŵ������ն���ά�ر��㷨���գ�ͳ��ͨ��ϵͳ
% ��������ʡ�

modType = 'pskmod';%��ʼ��BPSK��QPSK��16QAM��������
modParams = [2,pi];%��ʼ��BPSK��QPSK��16QAM���Ʋ���
isiChannelIRSeq = {randi([0,3],1,3);randi([0,3],1,5)};%�������ISI�ŵ��ĵ�λ������Ӧ
SNRIndBSeq = [-10:0];%SNR(dB)����
sourceLenSeq = [1e3,1e3,1e3,1e3,1e4,1e4,1e4,1e5,1e5,1e6,1e6];
symErrorPrSeq = zeros(length(modTypeSeq),length(SNRIndBSeq));%��ʼ�������������

for IRIndex = 1:size(isiChannelIRSeq,1)
    isiChannelIR = isiChannelIRSeq{IRIndex};
    modOrder = modParams(1);
    for SNRIndex = 1:length(SNRIndBSeq)
        SNRIndB = SNRIndBSeq(SNRIndex);
        sourceLen = sourceLenSeq(SNRIndex);%����SNR��С�����������Դ����
        data = randi([0,modOrder-1],1,sourceLen);%������Դ
        txSig = generalMod(data,modType,modParams);%����
        rxSig = isiChannel(isiChannelIR,txSig,SNRIndB);%�ѵ��ź�ͨ��ISI�ŵ�
        recovSig = vertebiRecv(rxSig,modType,modParams,isiChannelIR);%����ά�رȽ���
        dataOut = generalDemod(recovSig,modType,modParams);%���
        [errorNum,symErrorPrSeq(IRIndex,SNRIndex)] = symerr(data,dataOut(1:sourceLen));
    end
end
%��ͼ������
plotOptionSeq = {'-rx','-bo','-kd'};
semilogy(SNRIndBSeq,symErrorPrSeq(1,:),plotOptionSeq{1},'linewidth',1);hold on;
semilogy(SNRIndBSeq,symErrorPrSeq(2,:),plotOptionSeq{2},'linewidth',1);hold on;
% semilogy(SNRIndBSeq,symErrorPrSeq(3,:),plotOptionSeq(3),'linewidth',1);
xlabel('SNR/dB');ylabel('������Pr');title('����������');grid on;
legend("IR len = 3","IR len = 5");