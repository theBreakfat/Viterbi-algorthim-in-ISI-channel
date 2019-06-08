function Y = generalDemod(X,modType,modParams)
% �ú����ڸ����������ͺ͵��Ʋ���ʵ�ֽ��
% Params��
%   X���ѵ��ź�
%   modType����������
%   modParams�����Ʋ���
% return��
%   Y���������ź�
if modType == 'pskmod'
    modOrder = modParams(1);%�ѵ��ź�����ͼ�������ĸ���,�����ƽ���
    modIniPhase = modParams(2);%���Ƴ�ʼ��λ
    Y = pskdemod(X,modOrder,modIniPhase);%�ѵ��ź�
elseif modType == 'qammod'
    modOrder = modParams(1);%�ѵ��ź�����ͼ�������ĸ���,�����ƽ���
    Y = qamdemod(X,modOrder);%�ѵ��ź�
end