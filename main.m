% 该程序实现发送端分别进行BPSK、QPSK调制，
% 信号经过ISI信道，接收端用维特比算法接收，统计通信系统
% 的误符号率。

modTypeSeq = {'pskmod','pskmod'};%初始化BPSK、QPSK调制类型
modParamsSeq = {[2,pi],[4,pi/4]};%初始化BPSK、QPSK调制参数
isiChannelIRLen = 3;%设置ISI信道单位脉冲响应长度
isiChannelIR = randi([0,3],1,isiChannelIRLen);%随机生成ISI信道的单位脉冲响应
SNRIndBSeq = [-10:0];%SNR(dB)序列
sourceLenSeq = [1e3,1e3,1e3,1e3,1e4,1e4,1e4,1e5,1e5,1e6,1e6];
symErrorPrSeq = zeros(length(modTypeSeq),length(SNRIndBSeq));%初始化误比特率序列

for modIndex = 1:length(modTypeSeq)
    modType = modTypeSeq{modIndex};
    modParams = modParamsSeq{modIndex};
    modOrder = modParams(1);
    for SNRIndex = 1:length(SNRIndBSeq)
        SNRIndB = SNRIndBSeq(SNRIndex);
        sourceLen = sourceLenSeq(SNRIndex);%根据SNR大小估计所需的信源长度
        data = randi([0,modOrder-1],1,sourceLen);%产生信源
        txSig = generalMod(data,modType,modParams);%调制
        rxSig = isiChannel(isiChannelIR,txSig,SNRIndB);%已调信号通过ISI信道
        recovSig = vertebiRecv(rxSig,modType,modParams,isiChannelIR);%进行维特比接收
        dataOut = generalDemod(recovSig,modType,modParams);%解调
        [errorNum,symErrorPrSeq(modIndex,SNRIndex)] = symerr(data,dataOut(1:sourceLen));
    end
end
%绘图参数：
plotOptionSeq = {'-rx','-bo','-kd'};
semilogy(SNRIndBSeq,symErrorPrSeq(1,:),plotOptionSeq{1},'linewidth',1);hold on;
semilogy(SNRIndBSeq,symErrorPrSeq(2,:),plotOptionSeq{2},'linewidth',1);hold on;
% semilogy(SNRIndBSeq,symErrorPrSeq(3,:),plotOptionSeq(3),'linewidth',1);
xlabel('SNR/dB');ylabel('误码率Pr');title('误码率曲线');grid on;
legend("BPSK","QPSK","16QAM");