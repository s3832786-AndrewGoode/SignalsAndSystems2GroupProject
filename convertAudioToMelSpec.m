function convertAudioToMelSpec(audioDir, person)
    outputDir = ['./mel_spectrograms/', person];
    
    % Create output dir
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    D = dir(audioDir);
    
    % Loop through each audio file
    for i = 1:size(D, 1)
        if endsWith(D(i).name, ".flac", 'IgnoreCase', true) || endsWith(D(i).name, ".m4a", 'IgnoreCase', true)
            try
                % Reading the Audio File 
                [y,fs] = audioread([audioDir, '/', D(i).name]);
            catch
                warning(['File ', D(i).name, ' not found.']);
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
            colormap(hot(256));
            set(gca, 'XTick', [], 'YTick', [], 'XColor', 'none', 'YColor', 'none');
            colorbar('off');       
            set(gca, 'LooseInset', get(gca, 'TightInset'));
            set(gca, 'Position', [0 0 1 1], 'Units', 'normalized');

            outputFile = fullfile(outputDir, ['melSpectrogram', num2str(i),'.png']);
            saveas(gcf, outputFile);

            close gcf;
        end
    end
end