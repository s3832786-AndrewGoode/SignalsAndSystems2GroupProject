function convertAudioToMelSpec(audioDir)
    % Need to Adjust path
    % audioDir = './';
    outputDir = './mel_spectrograms/';
    
    % Create output dir
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % Loop through each audio file
    for i = 1:19
       % Construct File
       audioFile = fullfile(audioDir, ['audio',num2str(i),'.wav']);
       
       % Reading the Audio File 
       [y,fs] = audioread(audioFile);
       
       % Parameters For the Mel Spectrogram
       % Window Legth
       winLength = round(0.025 * fs);
       hopLength = round(0.010 * fs);
       numBands = 40;
       
       % Compute the Mel spectrogram
        melSpec = melSpectrogram(y, fs, 'WindowLength', winLength,'OverlapLength', winLength - hopLength, 'NumBands', numBands);
        
        figure
        melSpec(y, fs, 'WindowLength', winLength,'OverlapLength', winLength - hopLength, 'NumBands', numBands);
        
        outputFile = fullfile(outputDir, ['melSpectrogram', num2str(i),'.png']);
        saveas(gcf, outputFile);
    end
end