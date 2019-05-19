%% Check Image Data Folder Exists
imageFolder = '../SegmentadesBasic';
if ~exist(imageFolder,'dir')
    disp('Image folder not found, please change imageFolder var');
end

%% Load Images
imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames', ...
    'IncludeSubfolders',true, 'FileExtensions', '.jpg');
tbl = countEachLabel(imds)
% Determine the smallest amount of images in a category
minSetCount = min(tbl{:,2});
% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');
% Notice that each set now has exactly the same number of images.
countEachLabel(imds)

%% Prepare Training and Test Image Sets
[trainSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');

%% Extract Training Features
nFeatures = 1;
[nTrain, ~] = size(trainSet.Labels);
trainFeatures = zeros(nFeatures, nTrain);
%Color Mean
for i = 1:nTrain
    tmp = readimage(imds,i);
    trainFeatures(1,i) = mean(tmp(:))/255;
end

%% Train A Multiclass SVM Classifier Using Flower Features
% Get training labels from the trainSet
trainLabels = trainSet.Labels;

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
classifier = fitcecoc(trainFeatures, trainLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');

%% Evaluate Classifier
nFeatures = 1;
[nTest, ~] = size(testSet.Labels);
testFeatures = zeros(nFeatures, nTest);
%Color Mean
for i = 1:nTest
    tmp = readimage(imds,i);
    testFeatures(1,i) = mean(tmp(:))/255;
end

% Pass image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))

% Display the mean accuracy
mean(diag(confMat))

