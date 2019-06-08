function recovSig = vertebiRecv(rxSig,modType,modParams,isiChannelIR)
% �ú���ʵ�ֶ�ISI�ŵ���ά�رȽ��ա�
% Params��
%   rxSig���յ����ź�
%   modType����������
%   modParams�����Ʋ���
%   isiChannelIR��ISI�ŵ���λ������Ӧ
% return��
%   recovSig��ά�ر��㷨�ָ�����ź�
registerNum = length(isiChannelIR) - 1;%����Ĵ�������
modOrder = modParams(1);%�ѵ��ź�����ͼ�������ĸ����������ƽ���
modSigInLaw = generalMod(0:modOrder-1,modType,modParams);%�������кϷ��ĵ����ź�
registerIniStatus = generalMod(0,modType,modParams)*ones(1,registerNum);%����Ĵ�����ʼ״̬

graphAllNodes = zeros(modOrder^registerNum,registerNum);graphAllNodes(1,:)=registerIniStatus;%��ʼ������ͼ���в��ظ��ڵ�
graphNodesHaveBeenExtended = zeros(1,modOrder^registerNum);graphNodesHaveBeenExtended(1) = 1;%����ָʾ����ͼ�еĲ��ظ��ڵ��Ƿ��ѱ���չ��
lastGraphAllNodesMeasure = ones(1,modOrder^registerNum)*inf;lastGraphAllNodesMeasure(1) = 0;%��ʼ����һʱ������ͼ�нڵ�Ķ���
routeMemory = cell(1,length(rxSig));%��ʼ��·���洢��

for routeDepth = 1:length(rxSig)
    nextGraphAllNodeMeasure = ones(1,modOrder^registerNum)*inf;%��ʼ����һʱ������ͼ�нڵ�Ķ���
    for lastGraphNodeIndex = 1:size(graphAllNodes,1)
        if graphNodesHaveBeenExtended(lastGraphNodeIndex)==0
            continue;
        end
        lastGraphNode = graphAllNodes(lastGraphNodeIndex,:);
        for arrivalSymIndex = 1:modOrder%�������ܵ���ķ���
            arrivalSym = modSigInLaw(arrivalSymIndex);
            nextGraphNode = [arrivalSym,lastGraphNode];%�ڵ�һλ�Ĵ��������µķ���
            branchMeasure = abs(nextGraphNode*isiChannelIR' - rxSig(routeDepth))^2;%�����֧����
            nextGraphNode(registerNum+1) = [];%�������һλ�Ĵ���������
            nextGraphNodeIndex = graphNode2Index(nextGraphNode,modType,modParams);%����һʱ��Ľڵ�ӳ��Ϊ�ýڵ���ͼ�����в��ظ��ڵ��е��±�
            if nextGraphAllNodeMeasure(nextGraphNodeIndex)>lastGraphAllNodesMeasure(lastGraphNodeIndex) + branchMeasure
                if routeDepth<=registerNum%ֻ����·�����С�ڼĴ�������ʱ�Ż���չʱ��ͼ�Ľڵ㣬���ڼĴ�������ʱ����ͼ���нڵ���ѱ���չ
                    graphAllNodes(nextGraphNodeIndex,:) = nextGraphNode;
                    graphNodesHaveBeenExtended(nextGraphNodeIndex) = 1; 
                end
                nextGraphAllNodeMeasure(nextGraphNodeIndex) = lastGraphAllNodesMeasure(lastGraphNodeIndex) + branchMeasure;
                routeMemory{routeDepth}(nextGraphNodeIndex,:) = lastGraphNode;%�����Ľṹ�洢·��
            end
        end
    end
    lastGraphAllNodesMeasure = nextGraphAllNodeMeasure;
end
GraphAllNodesMeasure = lastGraphAllNodesMeasure;%��������ͼ�и��ڵ�Ķ���
[minMeasure,minMeasureIndex] = min(GraphAllNodesMeasure);%�Ƚϳ�����ͼ�ж�����С�Ľڵ�(�±�)
% ��·���洢���л��ݵõ�����Ȼ��·��(������ܵ�����)
recovSig = zeros(1,length(rxSig));
recovSig(length(rxSig)) = graphAllNodes(minMeasureIndex,1);
for sigIndex = length(rxSig):-1:2
    recovSig(sigIndex-1) = routeMemory{sigIndex}(minMeasureIndex,1);
    minMeasureIndex = graphNode2Index(routeMemory{sigIndex}(minMeasureIndex,:),modType,modParams);
end
