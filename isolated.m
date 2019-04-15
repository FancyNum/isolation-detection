% [n,~] = size(mpc.bus);
clear
clc
unDir_B = [0 0 0 0 0 1 1 0 0 0;0 0 0 0 0 0 0 0 0 0;...    %adjacency matrix with no direction
            0 0 0 1 0 0 0 1 1 0;0 0 1 0 1 0 0 0 1 1;...
            0 0 0 1 0 0 0 0 0 1;1 0 0 0 0 0 1 0 0 0;...
            1 0 0 0 0 1 0 0 0 0;0 0 1 0 0 0 0 0 0 0;...
            0 0 1 1 0 0 0 0 0 0;0 0 0 1 1 0 0 0 0 0];
[n,~] = size(unDir_B);
A = unDir_B;
for i = 1:n
    if i == 1
        temp_A = A;
        temp_P = A;
    else
        temp_A = temp_A * A;
        temp_P = temp_P | temp_A;
    end
end
P = temp_P;

temp_index = 1:n;
% class = [];
class = {};
while(1)
    blank = [];
    temp_value = temp_index(1);
    P_class1 = P(temp_value,:);
    for i = 1:max(size(temp_index))
        P_class2 = P(temp_index(i),:);
        if isequal(P_class1,P_class2)
            blank = [blank,temp_index(i)];
            temp_index(i) = 0;
        end
    end
    removal_line = any(P_class1);
    if ~removal_line     %the vector is zero
%         blank = [];
    else
        class = [class;{blank}];
    end
    temp_index(temp_index == 0) = [];
    if isempty(temp_index)
        break
    end
end

K = [1 0 0 0 0 -1 -2 -2 -2 -2];   %1 represent the node is connected to sources; 0 is the normal node;-1 is the load;-2 is the DG.
P1 = P(class{1}(1),:).*K;
P2 = P(class{2}(1),:).*K;
