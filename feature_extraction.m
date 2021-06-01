type = 'forefinger';
session = 1;
basedir1 = 'data/subject';
out_dir1 = 'feature/subject';
downsample_factor = 0.1980/0.4235; %for getting [70x100] depth map for matching
row = 70;
col = 100;
shiftLength_i = floor(18/2);%must be less than/equal to half of 18
shiftLength_j =  floor(25/2);%must be less than/equal to half of 25
mask = false(row,col);
mask(ceil(row/2)-shiftLength_i:ceil(row/2)+shiftLength_i,col/2-shiftLength_j:col/2+shiftLength_j) = 1;
kp = 10;

basedir2 = ['/session' num2str(session) '/' type '/set'];
for subjectID = 1:2
    for setID = 1:2
        disp([num2str(subjectID) ',' num2str(setID) '...'])
        load([basedir1 num2str(subjectID) basedir2 num2str(setID) '/surfNormal.mat']);
        N = reshape(surfNormal,212,149,3);
        N = imresize(N, downsample_factor);
        N2 = permute(N,[2 1 3]);

        %% Normal Derivative
        Nx = N2(:,:,1)./abs(N2(:,:,3));
        Ny = N2(:,:,2)./abs(N2(:,:,3));
        [Nxx, Nxy] = gradient(Nx);
        [Nyx, Nyy] = gradient(Ny);

        NDx = Nxx<0;
        NDy = Nyy<0;
        
        %% Key Points Detection
        rx = Nxx.*mask;
        rx(rx==0) = 999;
        ry = Nyy.*mask;
        ry(ry==0) = 999;
        rxs = sort(rx(:));
        rys = sort(ry(:));
        for i = 1:kp
            if(rxs(i)~=999)
                [keyx(i,1), keyx(i,2)] = find(rx==rxs(i)); %2D Index Search
                [keyy(i,1), keyy(i,2)] = find(ry==rys(i));
            else %invalid->image center
                keyx(i,1) = ceil(row/2); 
                keyx(i,2) = ceil(col/2);
                keyy(i,1) = ceil(row/2); 
                keyy(i,2) = ceil(col/2);
            end
        end

        mkdir([out_dir1 num2str(subjectID) basedir2 num2str(setID)]);
        save([out_dir1 num2str(subjectID) basedir2 num2str(setID) '/NDx.mat'],'NDx')
        save([out_dir1 num2str(subjectID) basedir2 num2str(setID) '/NDy.mat'],'NDy')
        imwrite(NDx,[out_dir1 num2str(subjectID) basedir2 num2str(setID) '/NDx.bmp'])
        imwrite(NDy,[out_dir1 num2str(subjectID) basedir2 num2str(setID) '/NDy.bmp'])
        
        save([out_dir1 num2str(subjectID) basedir2 num2str(setID) '/key.mat'],'keyx','keyy')
    end
end