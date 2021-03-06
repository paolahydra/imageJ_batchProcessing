% This script allows to select one or more multichannel images on black
% background, and to invert them such that the main channel will appear
% black on white background, and one other channel can be red (on white
% background). It works with max two channels (black and red).
% 
% written by Paola Patella, FMI - 2021


%% define output channels
blackCH = 2; % this channel will become black over white background

redCH = 3; % this channel will become red over white background
greenCH = 0; % use zero if you don't want any data shown in this channel
blueCH = 0;  % use zero if you don't want any data shown in this channel

% note that you may have to adjust values in the stretchlim function (for
% each channel) depending on the quality of your own image


%% interactively select files to process
% imagefiles = uipickfiles('Output', 'struct');
[file,path] = uigetfile('*.*');

%% do it
% for i = 1:length(imagefiles)
%     fname_original = imagefiles(i).name;
fname_original = fullfile(path, file);
    extension_i = strfind(fname_original, '.');
    assert(~isempty(extension_i),'Is the file extension not specified?')
    extension_i = extension_i(end);
    fname_2save = [fname_original(1:extension_i-1), '_blackred', fname_original(extension_i:end)];
       
    %% load image
    INFO = imfinfo(fname_original);
    
    cdata = imread(fname_original); 
    if size(cdata,3)~=length(INFO)
        for c = 1:length(INFO)
            cdata(:,:,c) = imread(fname_original,c);
        end
    end
    if ~isa(cdata, 'uint8')
        cdata = im2uint8(cdata);
    end
    clear newcdata
    
    %% split in channels
    clear ch
    for c = 1:size(cdata,3)
        ch(c).data = cdata(:,:,c);
    end
    white = uint8(255*ones(size(ch(1).data)));
    
    %% convert black channel
    im = ch(blackCH).data;
    lowhigh = stretchlim(im, [0.7 0.9999]); % saturate the white a bit. Check that the values suit your images
    im = imadjust(im,lowhigh);
    
    black_b = repmat(im,1,1,3);
    black_w = uint8(abs(double(black_b) - 255));
    
    %% convert color channels
    %first reorganize channels according to user directions
    CH = [redCH, greenCH, blueCH];
    for c = 1:size(cdata,3)
        if CH(c)~=0
            newcdata(:,:,c) = cdata(:,:,CH(c));
        else
            newcdata(:,:,c) = uint8(zeros(size(white)));
        end
    end
    
    MC = zeros(size(newcdata));
    for c = 1:size(newcdata,3)
        im = newcdata(:,:,c);
        lowhigh = stretchlim(im, [0.6 0.9999]);   % saturate the white in this channel! Check that the values suit your images
        im = imadjust(im,lowhigh);
        MC(:,:,setdiff(1:3, c)) = MC(:,:,setdiff(1:3, c)) + double(repmat(imcomplement(im),1,1,2));
    end
    MC = MC./2;
    MC = uint8(MC);
    M = min(MC, black_w);
%     figure; imshow(M); 
    
    %% save image
    imwrite(M, fname_2save);
% end

