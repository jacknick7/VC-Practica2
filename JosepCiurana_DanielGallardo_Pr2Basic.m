%% Check Image Data Folder Exists
imageFolder = '../SegmentadesBasic';
if ~exist(imageFolder,'dir')
    disp('Image folder not found, please change imageFolder var');
end

%% Load Images
disp('Reading image DB...');
imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames', ...
    'IncludeSubfolders',true, 'FileExtensions', '.jpg');
disp('Done!');
imageDB = countEachLabel(imds)
% Determine the smallest amount of images in a category
% minSetCount = min(tbl{:,2});
% Use splitEachLabel method to trim the set.
% imds = splitEachLabel(imds, minSetCount, 'randomize');
% countEachLabel(imds)

%% Prepare Training and Test Image Sets
[trainSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');
disp('Train/test random split with ratio 7:3');
trainDB = countEachLabel(trainSet)
testDB = countEachLabel(testSet)

%% Extract Training Features
nFeatures = 13;
[nTrain, ~] = size(trainSet.Labels);
disp('Extracting train features...');
trainFeatures = createFeatureMat(nFeatures, nTrain, trainSet);
disp('Done!');

%% Train A Multiclass SVM Classifier Using Flower Features
% Get training labels from the trainSet
trainLabels = trainSet.Labels;

% Train multiclass SVM classifier using a fast linear solver, and set
% 'ObservationsIn' to 'columns' to match the arrangement used for training
% features.
disp('Training SVM...');
classifier = fitcecoc(trainFeatures, trainLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');
disp('Done!');

%% Evaluate Classifier
[nTest, ~] = size(testSet.Labels);
disp('Extracting test features...');
testFeatures = createFeatureMat(nFeatures,nTest,testSet);
disp('Done!');

% Pass image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');

% Get the known labels
testLabels = testSet.Labels;

% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2));

% Print confusion matrix with labels
labels = cellstr(classifier.ClassNames);
array2table(confMat,'RowNames',labels,'VariableNames',labels)

% Display the mean accuracy
accuracy = mean(diag(confMat))

