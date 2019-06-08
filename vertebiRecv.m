function recovSig = vertebiRecv(rxSig,modType,modParams,isiChannelIR)
% 该函数实现对ISI信道的维特比接收。
% Params：
%   rxSig：收到的信号
%   modType：调制类型
%   modParams：调制参数
%   isiChannelIR：ISI信道单位脉冲响应
% return：
%   recovSig：维特比算法恢复后的信号
registerNum = length(isiChannelIR) - 1;%计算寄存器个数
modOrder = modParams(1);%已调信号星座图中星座的个数，即调制阶数
modSigInLaw = generalMod(0:modOrder-1,modType,modParams);%计算所有合法的调制信号
registerIniStatus = generalMod(0,modType,modParams)*ones(1,registerNum);%计算寄存器初始状态

graphAllNodes = zeros(modOrder^registerNum,registerNum);graphAllNodes(1,:)=registerIniStatus;%初始化网格图所有不重复节点
graphNodesHaveBeenExtended = zeros(1,modOrder^registerNum);graphNodesHaveBeenExtended(1) = 1;%用于指示网格图中的不重复节点是否已被扩展到
lastGraphAllNodesMeasure = ones(1,modOrder^registerNum)*inf;lastGraphAllNodesMeasure(1) = 0;%初始化上一时序网格图中节点的度量
routeMemory = cell(1,length(rxSig));%初始化路径存储器

for routeDepth = 1:length(rxSig)
    nextGraphAllNodeMeasure = ones(1,modOrder^registerNum)*inf;%初始化下一时序网格图中节点的度量
    for lastGraphNodeIndex = 1:size(graphAllNodes,1)
        if graphNodesHaveBeenExtended(lastGraphNodeIndex)==0
            continue;
        end
        lastGraphNode = graphAllNodes(lastGraphNodeIndex,:);
        for arrivalSymIndex = 1:modOrder%遍历可能到达的符号
            arrivalSym = modSigInLaw(arrivalSymIndex);
            nextGraphNode = [arrivalSym,lastGraphNode];%在第一位寄存器存入新的符号
            branchMeasure = abs(nextGraphNode*isiChannelIR' - rxSig(routeDepth))^2;%计算分支度量
            nextGraphNode(registerNum+1) = [];%弹出最后一位寄存器的内容
            nextGraphNodeIndex = graphNode2Index(nextGraphNode,modType,modParams);%将下一时序的节点映射为该节点在图中所有不重复节点中的下标
            if nextGraphAllNodeMeasure(nextGraphNodeIndex)>lastGraphAllNodesMeasure(lastGraphNodeIndex) + branchMeasure
                if routeDepth<=registerNum%只有在路径深度小于寄存器长度时才会扩展时序图的节点，大于寄存器长度时网格图所有节点均已被扩展
                    graphAllNodes(nextGraphNodeIndex,:) = nextGraphNode;
                    graphNodesHaveBeenExtended(nextGraphNodeIndex) = 1; 
                end
                nextGraphAllNodeMeasure(nextGraphNodeIndex) = lastGraphAllNodesMeasure(lastGraphNodeIndex) + branchMeasure;
                routeMemory{routeDepth}(nextGraphNodeIndex,:) = lastGraphNode;%以树的结构存储路径
            end
        end
    end
    lastGraphAllNodesMeasure = nextGraphAllNodeMeasure;
end
GraphAllNodesMeasure = lastGraphAllNodesMeasure;%最终网格图中各节点的度量
[minMeasure,minMeasureIndex] = min(GraphAllNodesMeasure);%比较出网格图中度量最小的节点(下标)
% 从路径存储器中回溯得到最似然的路径(即最可能的码字)
recovSig = zeros(1,length(rxSig));
recovSig(length(rxSig)) = graphAllNodes(minMeasureIndex,1);
for sigIndex = length(rxSig):-1:2
    recovSig(sigIndex-1) = routeMemory{sigIndex}(minMeasureIndex,1);
    minMeasureIndex = graphNode2Index(routeMemory{sigIndex}(minMeasureIndex,:),modType,modParams);
end
