function graphNodeIndex = graphNode2Index(graphNode,modType,modParams)
% �ú���������������ͼ�ڵ�ӳ��Ϊ�ýڵ�����������ͼ�ڵ��е��±�(���������µ�λ��)
% ������������ͼ�ڵ�ӳ��Ϊ�±꣬���ڽ���������ͼ�ڵ�ɿ����Ե��ƽ���Ϊ���ƵĶ�������飬��
% ��ѡ��ӳ�䷽��Ϊ������������ͼ�ڵ�ת��Ϊʮ����������ʮ���������±꣬�ɼ���ӳ��Ϊһһӳ��
% Params��
%   graphNode������������ͼ�ڵ�
%   modType����������
%   modParams�����Ʋ���
% return��
%   graphNodeIndex���ýڵ�����������ͼ���ظ��ڵ��е��±�
graphNodeDemod = generalDemod(graphNode,modType,modParams);%�õ�����������ͼ�ڵ�
graphNodeIndex = 1;%MATLAB�±��1��ʼ
modOrder = modParams(1);%��ȡ���ƽ���
graphNodeLen = length(graphNode);
for index = 1:graphNodeLen
    %modOrder����תʮ���ƣ�
    graphNodeIndex = graphNodeIndex + modOrder^(graphNodeLen-index)*graphNodeDemod(index);
end
