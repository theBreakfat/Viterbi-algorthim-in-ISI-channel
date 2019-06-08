function graphNodeIndex = graphNode2Index(graphNode,modType,modParams)
% 该函数将给定的网格图节点映射为该节点在所有网格图节点中的下标(即自上向下的位置)
% 将解调后的网格图节点映射为下标，由于解调后的网格图节点可看作以调制阶数为进制的多进制数组，所
% 以选择映射方法为将解调后的网格图节点转化为十进制数，该十进制数即下标，可见此映射为一一映射
% Params：
%   graphNode：给定的网格图节点
%   modType：调制类型
%   modParams：调制参数
% return：
%   graphNodeIndex：该节点在所有网格图不重复节点中的下标
graphNodeDemod = generalDemod(graphNode,modType,modParams);%得到解调后的网格图节点
graphNodeIndex = 1;%MATLAB下标从1开始
modOrder = modParams(1);%获取调制阶数
graphNodeLen = length(graphNode);
for index = 1:graphNodeLen
    %modOrder进制转十进制：
    graphNodeIndex = graphNodeIndex + modOrder^(graphNodeLen-index)*graphNodeDemod(index);
end
