function convertAudioToMelSpec(audioDir, person)
    % Need to Adjust path
    % audioDir = './';
    outputDir = ['./mel_spectrograms/', person];
    
    % Create output dir
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % Loop through each audio file
    for i = 1:19
        if i + 5 < 10
            % Construct File
            audioFile = fullfile(audioDir, [person, '_00', num2str(i + 5), '_mic1.flac']);
        else
            % Construct File
            audioFile = fullfile(audioDir, [person, '_0', num2str(i + 5), '_mic1.flac']);
        end
        
        try
            % Reading the Audio File 
            [y,fs] = audioread(audioFile);
        catch
            warning(['File ', audioFile, ' not found.']);
            continue;
        end
       
        % Parameters For the Mel Spectrogram
        % Window Length
        winLength = round(0.025 * fs);
        hopLength = round(0.010 * fs);
        numBands = 40;
        
        figure;
        % Compute the Mel spectrogram
        melSpectrogram(y, fs, 'WindowLength', winLength,'OverlapLength', winLength - hopLength, 'NumBands', numBands);
        set(gca, 'XTick', [], 'YTick', [], 'XColor', 'none', 'YColor', 'none');
        colorbar('off');       
        set(gca, 'LooseInset', get(gca, 'TightInset'));
        set(gca, 'Position', [0 0 1 1], 'Units', 'normalized');
        
        outputFile = fullfile(outputDir, ['melSpectrogram', num2str(i),'.png']);
        saveas(gcf, outputFile);
        
        close gcf;
    end
end