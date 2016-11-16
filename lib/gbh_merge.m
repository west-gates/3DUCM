function gbh_merge(fileseq,foldername,PathInput)

mkdir(['ibsr_level0/',foldername]);



if PathInput(end) == '/'
    PathInput = PathInput(1:end-1);
end

DirInput = dir(PathInput);

numOfFrames = 0;

for i=1:size(DirInput,1)
    if strfind(DirInput(i,1).name, '.ppm') > 0
        numOfFrames = numOfFrames + 1;
        ImLabSeq(:,:,:,numOfFrames) = RGB2Lab(imread([PathInput,'/',DirInput(i,1).name]));
    end
end

L=squeeze(ImLabSeq(:,:,1,:));
A=squeeze(ImLabSeq(:,:,2,:));
B=squeeze(ImLabSeq(:,:,3,:));
clear ImLabSeq;

tic;
[nodex,nodey,edgevalue,wnb]=get_svx_map(fileseq,L,A,B);
toc;

level=0;

svname=['ibsr_level0/',foldername,'/level_',num2str(level),'.mat'];
save(svname,'wnb');
