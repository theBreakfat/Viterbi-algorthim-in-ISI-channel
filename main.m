% �ó���ʵ�ַ��Ͷ˷ֱ����BPSK��QPSK���ƣ�
% �źž���ISI�ŵ������ն���ά�ر��㷨���գ�ͳ��ͨ��ϵͳ
% ��������ʡ�

modTypeSeq = {'pskmod','pskmod'};%��ʼ��BPSK��QPSK��������
modParamsSeq = {[2,pi],[4,pi/4]};%��ʼ��BPSK��QPSK���Ʋ���
isiChannelIRLen = 3;%����ISI�ŵ���λ������Ӧ����
isiChannelIR = randi([0,3],1,isiChannelIRLen);%�������ISI�ŵ��ĵ�λ������Ӧ
SNRIndBSeq = [-10:0];%SNR(dB)����
sourceLenSeq = [1e3,1e3,1e3,1e3,1e4,1e4,1e4,1e5,1e5,1e6,1e6];
symErrorPrSeq = zeros(length(modTypeSeq),length(SNRIndBSeq));%��ʼ�������������

for modIndex = 1:length(modTypeSeq)
    modType = modTypeSeq{modIndex};
    modParams = modParamsSeq{modIndex};
    modOrder = modParams(1);
    for SNRIndex = 1:length(SNRIndBSeq)
        SNRIndB = SNRIndBSeq(SNRIndex);
        sourceLen = sourceLenSeq(SNRIndex);%����SNR��С�����������Դ����
        data = randi([0,modOrder-1],1,sourceLen);%������Դ
        txSig = generalMod(data,modType,modParams);%����
        rxSig = isiChannel(isiChannelIR,txSig,SNRIndB);%�ѵ��ź�ͨ��ISI�ŵ�
        recovSig = vertebiRecv(rxSig,modType,modParams,isiChannelIR);%����ά�رȽ���
        dataOut = generalDemod(recovSig,modType,modParams);%���
        [errorNum,symErrorPrSeq(modIndex,SNRIndex)] = symerr(data,dataOut(1:sourceLen));
    end
end
%��ͼ������
plotOptionSeq = {'-rx','-bo','-kd'};
semilogy(SNRIndBSeq,symErrorPrSeq(1,:),plotOptionSeq{1},'linewidth',1);hold on;
semilogy(SNRIndBSeq,symErrorPrSeq(2,:),plotOptionSeq{2},'linewidth',1);hold on;
% semilogy(SNRIndBSeq,symErrorPrSeq(3,:),plotOptionSeq(3),'linewidth',1);
xlabel('SNR/dB');ylabel('������Pr');title('����������');grid on;
legend("BPSK","QPSK","16QAM");