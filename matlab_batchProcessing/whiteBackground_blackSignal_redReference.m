% This script allows to select one or more multichannel images on black
% background, and to invert them such that the main channel will appear
% black on white background, and one other channel can be red (on white
% background). It works with max two channels (black and red).
% 
% written by Paola Patella, FMI - 2021


%% define channel output
blackCH = 2; % this channel will become black over white background
redCH = 1; % this channel will become red over white background

% note that you may have to adjust values in the stretchlim function (for
% each channel) depending on the quality of your own image

%% interactively select files to process and do it
imagefiles = uipickfiles('Output', 'struct');

for i = 1:length(imagefiles)
    fname_original = imagefiles(i).name;
    extension_i = strfind(imagefiles(i).name, '.');
    assert(~isempty(extension_i),'Is the file extension not specified?')
    extension_i = extension_i(end);
    fname_2save = [fname_original(1:extension_i-1), '_blackred', fname_original(extension_i:end)];
    
    %% load image(s)
    cdata = imread(fname_original);

    %% split in channels
    for c = 1:size(cdata,3)
        ch(c).data = cdata(:,:,c);
    end
    white = uint8(255*ones(size(ch(1).data)));
    
    %% convert black channel
    im = ch(blackCH).data;
    lowhigh = stretchlim(im, [0.2 1]); % saturate the white a bit. Check that the values suit your images
    im = imadjust(im,lowhigh);
    
    black_b = repmat(im,1,1,3);
    black_w = uint8(abs(double(black_b) - 255));
    
    %% convert red channel
    im = ch(redCH).data;
    lowhigh = stretchlim(im, [0.6 1]);   % saturate the white in this channel! Check that the values suit your images
    im = imadjust(im,lowhigh);
    
    red_w_single = uint8(abs(double(im) - 255));
    red_w = cat(3, white, red_w_single, red_w_single);
    
    %% fuse colors and save image
    M = min(red_w, black_w);
    imwrite(M, fname_2save);
end

