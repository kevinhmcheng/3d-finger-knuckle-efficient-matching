function [final_score] = compute_score_key(bitPlanesAx,bitPlanesAy,bitPlanesBx,bitPlanesBy,keyx1,keyy1,keyx2,keyy2)
kp = 10;
ks = 20;

score_map = [0.5,1,1,1,1,0,1,0.5,1,1,0,0.5,1,0.5,0.5,0];

%Rotating Planes A, Shifting Planes B
[rows, cols] = size(bitPlanesAx);
shiftLength_i = ceil(rows*0.25);
shiftLength_j = ceil(cols*0.25);
pixelNO = (rows-2*shiftLength_i)*(cols-2*shiftLength_j);

shift = zeros(kp*kp*2,2);
for p1 = 1:kp
    for p2 = 1:kp
        %key points X
        shift((p1-1)*kp+p2,:) = [keyx2(p2,1)-keyx1(p1,1), keyx2(p2,2)-keyx1(p1,2)];
        %key points Y
        shift((p1-1)*kp+p2+kp*kp,:) = [keyy2(p2,1)-keyy1(p1,1), keyy2(p2,2)-keyy1(p1,2)];
    end
end
shift = unique(shift,'rows');

%% Stage 1
score = ones(size(shift,1),1); 
new_bitPlanesAx = bitPlanesAx(1+shiftLength_i:rows-shiftLength_i,1+shiftLength_j:cols-shiftLength_j);%constant center part
new_bitPlanesAy = bitPlanesAy(1+shiftLength_i:rows-shiftLength_i,1+shiftLength_j:cols-shiftLength_j);%constant center part
for shiftIdx = 1:size(shift,1)
        shifti = shift(shiftIdx,1);
        shiftj = shift(shiftIdx,2);

        new_bitPlanesBx = bitPlanesBx(1+shiftLength_i+shifti:rows-shiftLength_i+shifti,1+shiftLength_j+shiftj:cols-shiftLength_j+shiftj);
        new_bitPlanesBy = bitPlanesBy(1+shiftLength_i+shifti:rows-shiftLength_i+shifti,1+shiftLength_j+shiftj:cols-shiftLength_j+shiftj);
        Planes = score_map(new_bitPlanesAx*8+new_bitPlanesAy*4+new_bitPlanesBx*2+new_bitPlanesBy+1);

        score(shiftIdx) = sum(Planes(:))/pixelNO;
end
[~, scoreIdx] = sort(score(:)); %1D Index Search

%% Stage 2
score_rot = ones(ks,21);
for degree = -10:1:10
    bitPlanesAx_R = imrotate(bitPlanesAx,degree,'crop');
    bitPlanesAy_R = imrotate(bitPlanesAy,degree,'crop');
        
    for good_shift = 1:ks
        shiftIdx = scoreIdx(good_shift);
        shifti = shift(shiftIdx,1);
        shiftj = shift(shiftIdx,2);

        new_bitPlanesAx = bitPlanesAx_R(1+shiftLength_i:rows-shiftLength_i,1+shiftLength_j:cols-shiftLength_j);%constant center part
        new_bitPlanesBx = bitPlanesBx(1+shiftLength_i+shifti:rows-shiftLength_i+shifti,1+shiftLength_j+shiftj:cols-shiftLength_j+shiftj);
        new_bitPlanesAy = bitPlanesAy_R(1+shiftLength_i:rows-shiftLength_i,1+shiftLength_j:cols-shiftLength_j);%constant center part
        new_bitPlanesBy = bitPlanesBy(1+shiftLength_i+shifti:rows-shiftLength_i+shifti,1+shiftLength_j+shiftj:cols-shiftLength_j+shiftj);
        Planes = score_map(new_bitPlanesAx*8+new_bitPlanesAy*4+new_bitPlanesBx*2+new_bitPlanesBy+1);

        score_rot(good_shift, degree+11) = sum(Planes(:))/pixelNO;
    end
end
final_score = min(score_rot(:));

end