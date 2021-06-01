part = 1;
thread = 1;

%session2_matching_protocol
    type = 'forefinger';
    session = 1;
    subject_NO = 2; set_NO = 2;
    score_matrix = 999*ones(ceil(subject_NO/thread)*set_NO, subject_NO*set_NO); %session1 with session2
    %downsample_factor = 0.1980/0.4235; %for getting [70x100] depth map for matching
    
    %% Data Loading
    bwx = zeros([70,100,subject_NO,set_NO]);
    bwy = zeros([70,100,subject_NO,set_NO]);
    kp = 10;
    keyX = zeros([kp,2,subject_NO,set_NO]);
    keyY = zeros([kp,2,subject_NO,set_NO]);
    for subjectID = 1:subject_NO
        for setID = 1:set_NO
                load(['feature/subject' num2str(subjectID) '/session' num2str(session) '/' type '/set' num2str(setID) '/NDx.mat']);
                load(['feature/subject' num2str(subjectID) '/session' num2str(session) '/' type '/set' num2str(setID) '/NDy.mat']);
                bwx(:,:,subjectID,setID) = NDx;
                bwy(:,:,subjectID,setID) = NDy;
                load(['feature/subject' num2str(subjectID) '/session' num2str(session) '/' type '/set' num2str(setID) '/key.mat']);
                keyX(:,:,subjectID,setID) = keyx;
                keyY(:,:,subjectID,setID) = keyy;
        end
    end
            
    %% Matching
    for subjectID = (part-1)*ceil(subject_NO/thread)+1:part*ceil(subject_NO/thread)
        if(subjectID > subject_NO)
            break;
        end
        for setID = 1:set_NO
            bwx1 = squeeze(bwx(:,:,subjectID,setID));
            bwy1 = squeeze(bwy(:,:,subjectID,setID));
            keyx1 = squeeze(keyX(:,:,subjectID,setID));
            keyy1 = squeeze(keyY(:,:,subjectID,setID));
            
            for subjectID_2 = 1:subject_NO
                for setID_2 = 1:set_NO
                    disp([num2str(subjectID) ',' num2str(setID) ',' num2str(subjectID_2) ',' num2str(setID_2) '...'])
                    bwx2 = squeeze(bwx(:,:,subjectID_2,setID_2));
                    bwy2 = squeeze(bwy(:,:,subjectID_2,setID_2));
                    keyx2 = squeeze(keyX(:,:,subjectID_2,setID_2));
                    keyy2 = squeeze(keyY(:,:,subjectID_2,setID_2));
                    
                     [result] = compute_score_key(bwx1,bwy1,bwx2,bwy2,keyx1,keyy1,keyx2,keyy2);
                     score_matrix((subjectID-1)*set_NO+setID, (subjectID_2-1)*set_NO+setID_2) = result;
                end
            end
        end
    end
    save([num2str(type) '_' 'score_matrix' num2str(part) '.mat'], 'score_matrix')