function data1 = sampleDATA()
% sampleIMAGES
% Returns 10000 patches for training

% % load IMAGES;    % load images from disk 
% % 
% % patchsize = 8;  % we'll use 8x8 patches 
% % numpatches = 10000;

% Initialize patches with zeros.  Your code will fill in this matrix--one
% column per patch, 10000 columns. 
data1 = zeros(44,237);

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Fill in the variable called "patches" using data 
%  from IMAGES.  
%  
%  IMAGES is a 3D array containing 10 images
%  For instance, IMAGES(:,:,6) is a 512x512 array containing the 6th image,
%  and you can type "imagesc(IMAGES(:,:,6)), colormap gray;" to visualize
%  it. (The contrast on these images look a bit off because they have
%  been preprocessed using using "whitening."  See the lecture notes for
%  more details.) As a second example, IMAGES(21:30,21:30,1) is an image
%  patch corresponding to the pixels in the block (21,21) to (30,30) of
%  Image 1

% % counter = 1;
% % ranimg = ceil(rand(1, numpatches) * 10);
% % ranpix = ceil(rand(2, numpatches) * (512 - patchsize));
% % ranpixm = ranpix + patchsize - 1;
% % while(counter <= numpatches)
% % whichimg = ranimg(1, counter);
% % whichpix = ranpix(:, counter);
% % whichpixm = ranpixm(:, counter);
% % patch = IMAGES(whichpix(1):whichpixm(1), whichpix(2):whichpixm(2), whichimg);
% % repatch = reshape(patch, patchsize * patchsize, 1);
% % patches(:, counter) = repatch;
% % counter = counter + 1;
% % end


IMP5 = xlsread('Series27');

IMP5 = IMP5.'; %Input matrix
Nwindow = 10; %Number of Window
Noverlap = 3; % number of overlap time steps
alpha = .01; % Learning Rate
T = [ones(1,200);zeros(1,200)];
[NC TT] = size(IMP5);
count =1;
for i = 1:Noverlap:(TT - Nwindow)
      seg = IMP5(:,i:(i+ Nwindow));
      data1(:,count)=reshape(seg,[NC*(Nwindow+1),1]); %New Input matrix after data preprocessed
      count = count+1;
end
%% ---------------------------------------------------------------
% For the autoencoder to work well we need to normalize the data
% Specifically, since the output of the network is bounded between [0,1]
% (due to the sigmoid activation function), we have to make sure 
% the range of pixel values is also bounded between [0,1]
data1 = normalizeData(data1);
 
end











%% ---------------------------------------------------------------
function data1 = normalizeData(data1)

% Squash data to [0.1, 0.9] since we use sigmoid as the activation
% function in the output layer

% Remove DC (mean of images). 
data1 = bsxfun(@minus, data1, mean(data1));

% Truncate to +/-3 standard deviations and scale to -1 to 1
pstd = 3 * std(data1(:));
data1 = max(min(data1, pstd), -pstd) / pstd;

% Rescale from [-1,1] to [0.1,0.9]
data1 = (data1 + 1) * 0.4 + 0.1;

end
