function videoGradient(PathInput,scales,fileseq)


if PathInput(end) == '/'
    PathInput = PathInput(1:end-1);
end

DirInput = dir(PathInput);

numOfFrames = 0;

for i=1:size(DirInput,1)
    if strfind(DirInput(i,1).name, '.ppm') > 0
        numOfFrames = numOfFrames + 1;
        ImRGBSeq(:,:,:,numOfFrames) = imread([PathInput,'/',DirInput(i,1).name]);
    end
end

ImRGBSeq=double(ImRGBSeq)/255;

%ImRGBSeq=(ImRGBSeq-min(ImRGBSeq(:)))/(max(ImRGBSeq(:))-min(ImRGBSeq(:)));

dd=squeeze(ImRGBSeq(:,:,1,:));
siz=size(dd);

svname=['temp/file_',num2str(fileseq),'_siz.mat'];
save(svname,'siz');


matlabpool 3;
parfor i = 1:3;
	data=squeeze(ImRGBSeq(:,:,i,:));
	multiscale_grads(data,scales,fileseq,i);
end
matlabpool close;





