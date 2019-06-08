function Y = generalMod(X,modType,modParams)
% 该函数在给定调制类型和调制参数实现调制
% Params：
%   X：调制信号
%   modType：调制类型
%   modParams：调制参数
% return：
%   Y：已调信号
if modType == 'pskmod'
    modOrder = modParams(1);%已调信号星座图中星座的个数,即调制阶数
    modIniPhase = modParams(2);%调制初始相位
    Y = pskmod(X,modOrder,modIniPhase);%已调信号
elseif modType == 'qammod'
    modOrder = modParams(1);%已调信号星座图中星座的个数,即调制阶数
    Y = qammod(X,modOrder);%已调信号
end