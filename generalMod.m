function Y = generalMod(X,modType,modParams)
% �ú����ڸ����������ͺ͵��Ʋ���ʵ�ֵ���
% Params��
%   X�������ź�
%   modType����������
%   modParams�����Ʋ���
% return��
%   Y���ѵ��ź�
if modType == 'pskmod'
    modOrder = modParams(1);%�ѵ��ź�����ͼ�������ĸ���,�����ƽ���
    modIniPhase = modParams(2);%���Ƴ�ʼ��λ
    Y = pskmod(X,modOrder,modIniPhase);%�ѵ��ź�
elseif modType == 'qammod'
    modOrder = modParams(1);%�ѵ��ź�����ͼ�������ĸ���,�����ƽ���
    Y = qammod(X,modOrder);%�ѵ��ź�
end