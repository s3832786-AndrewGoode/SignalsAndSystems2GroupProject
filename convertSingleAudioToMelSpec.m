function convertSingleAudioToMelSpec(audioDir, person)
    outputDir = './Testing/';
    
    % Create output dir
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    try
        % Reading the Audio File 
        [y,fs] = audioread(audioDir);
    catch
        warning(['File ', audioDir, ' not found.']);
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

    outputFile = fullfile(outputDir, [person, '.png']);
    saveas(gcf, outputFile);

    close gcf;
end