video = VideoReader('data/sujeto5_miriam.mp4');
sampling_rate = video.FrameRate;

signal_RGB = acquire_RGB(video);
mean_hr_RGB = process(signal_RGB, sampling_rate);

signal_R = acquire_R(video);
%mean_hr_R = process(signal_R, sampling_rate);

[psnr,mse,~,~] = measerr(signal_R, signal_RGB)

function signal = acquire_RGB(video)
    numFrames = video.NumberOfFrames;
    means_R = zeros(1, numFrames);
    means_G = zeros(1, numFrames);
    means_B = zeros(1, numFrames);

    for i=1:numFrames
        frame = read(video, i);
        % Obtenemos la media de cada banda
        means_R(i)=sum(sum(frame(:,:,1)))/(size(frame,1)*size(frame,2));
        means_G(i)=sum(sum(frame(:,:,2)))/(size(frame,1)*size(frame,2));
        means_B(i)=sum(sum(frame(:,:,3)))/(size(frame,1)*size(frame,2));
    end

    % Guardamos las medias en una matriz
    means = transpose([means_R; means_G; means_B]);
    norm_means_R=transpose((means(:,1)-mean(means(:,1)))/std(means(:,1)));
    norm_means_G=transpose((means(:,2)-mean(means(:,2)))/std(means(:,2)));
    norm_means_B=transpose((means(:,3)-mean(means(:,3)))/std(means(:,3)));
    means_standar=transpose([norm_means_R; norm_means_G; norm_means_B]);

    % Y la multiplicamos por su traspuesta, así tenemos una matriz [3 3]
    X = transpose(means_standar) * means_standar;
    % Calculamos sus autovalores y autovectores
    [V, D] = eig(X);
    % Ordenamos los autovalores de mayor a menos valor
    [~, idx] = sort(diag(D), 'descend');
    % El mejor autovector es el correspontiende al autovalor más grande
    best = transpose(V(:,idx(1)));
    % Aplicamos la fórmula signal=autovector*(X-media(X))
    signal = best*(transpose(means_standar)-mean(means_standar(:)));
end

function signal = acquire_R(video)
    numFrames = video.NumberOfFrames;
    signal = zeros(1, numFrames);
    for i=1:numFrames
        frame = read(video, i);
        redPlane = frame(:, :, 1);
        signal(i) = sum(sum(redPlane)) / (size(frame, 1) * size(frame, 2));
    end
end

function mean_hr = process(y, fps)
    % Parameters to play with
    % [s] Sliding window length
    WINDOW_SECONDS = 6;
    % [s] Time between heart rate estimations
    BPM_SAMPLING_PERIOD = 0.5;
    % [bpm] Valid heart rate range
    BPM_L = 40; BPM_H = 230;
    % [s] Filter startup transient
    FILTER_STABILIZATION_TIME = 1;
    % [s] Initial signal period to cut off
    CUT_START_SECONDS = 5;
    % [bpm] Separation between test tones for smoothing
    FINE_TUNING_FREQ_INCREMENT = 1;

    % [] This makes the animation run faster or slower than real time
    ANIMATION_SPEED_FACTOR = 2;

    % Build and apply input filter
    % Pasos: BPM_L/60 ya que bpm son beep por minuto obtenemos beep por
    % segundo. Al dividirlo por fps corresponde a beep por frame.
    % Multiplicarlo por 2 es por Nyquist. Para obtener objetos de una
    % frecuencia tenemos que tener dos muestra. Lo que quiere decir que la
    % frecuencia real es por 2.
    [b, a] = butter(2, [(((BPM_L)/60)/fps*2) (((BPM_H)/60)/fps*2)]);
    yf = filter(b, a, y); %filtramos la señal entera
    %si fps=30 frames por segundo y siendo FILTER_STABILIZATION_TIME=2
    %desechamos los 30 primero frames para estabilizar la señal.
    y = yf((fps * max(FILTER_STABILIZATION_TIME, CUT_START_SECONDS))+1:size(yf, 2));

    % Some initializations and precalculations
    %num_window_samples: numero de frames que entran en una ventana de 6
    %segundos
    num_window_samples = round(WINDOW_SECONDS * fps);
    %cada ventana se toma cada 15 frames siendo fps=30 ya
    %BPM_SAMPLING_PERIOD=0.5
    bpm_sampling_period_samples = round(BPM_SAMPLING_PERIOD * fps);
    %Cuantas ventas de 6 segundos tenemos
    num_bpm_samples = floor((size(y, 2) - num_window_samples) / bpm_sampling_period_samples);
    fcl = BPM_L / 60; fch = BPM_H / 60;
    orig_y = y;
    bpm = [];
    bpm_smooth = [];

    max_freq_plot_amplitude = 0;
    max_time_plot_bpm = 100;
    min_time_plot_bpm = 50;

    for i=1:num_bpm_samples
        % Fill sliding window with original signal
        window_start = (i-1)*bpm_sampling_period_samples+1;
        ynw = orig_y(window_start:window_start+num_window_samples);
        % Use Hanning window to bring edges to zero. In this way, no 
        % artificial high frequencies appear when the signal is treated as 
        % periodic by the FFT
        y = ynw .* hann(size(ynw, 2))';
        gain = abs(fft(y));

        % FFT indices of frequencies where the human heartbeat is
        %fcl son beep por segundo del rango inferior de beep. Al dividir
        %el total de frames por fps=30 no quedamos en cuantos segundos 
        %corresponde a cada grupo de 30 y multiplicar ahora por fcl 
        %no dice el numero de beeps minimo que corresponde a un grupo de 30
        %frames. E igual con fch (en definitiva que frecuencia minimo y
        %frecuencia maxima
        
    
        il = floor(fcl * (size(y, 2) / fps))+1; ih = ceil(fch * (size(y, 2) / fps))+1;
        index_range = il:ih;
        
        % Plot the amplitude of the frequencies of interest
        figure(1);
        subplot(2, 1, 1);
        hold off;
        %pintamos la magnitud del dft en ese rango de frecuencias 
        fft_plot = plot((index_range-1) * (fps / size(y, 2)) * 60, gain(index_range), 'b', 'LineWidth', 2);
        hold on;    
        max_freq_plot_amplitude = max(max_freq_plot_amplitude, max(gain(index_range)));
        axis([BPM_L BPM_H 0 max_freq_plot_amplitude]);
        grid on;
        xlabel('Heart rate (BPM)');
        ylabel('Amplitude');
        title('Frequency analysis and time evolution of heart rate signal');

        % Find peaks in the interest frequency range and locate the highest
        [pks, locs] = findpeaks(gain(index_range));
        [max_peak_v, max_peak_i] = max(pks);
        %donde se encuentra ese maximo en las frecuencias
        max_f_index = index_range(locs(max_peak_i));
        %volvemos a beep por minuto
        bpm(i) = (max_f_index-1) * (fps / size(y, 2)) * 60;
        
        % Smooth the highest peak frequency by finding the frequency that
        % best "correlates" in the resolution range around the peak
        freq_resolution = 1 / WINDOW_SECONDS;
        lowf = bpm(i) / 60 - 0.5 * freq_resolution;
        freq_inc = FINE_TUNING_FREQ_INCREMENT / 60;
        test_freqs = round(freq_resolution / freq_inc);
        power = zeros(1, test_freqs);
        freqs = (0:test_freqs-1) * freq_inc + lowf;
        for h = 1:test_freqs
            re = 0; im = 0;
            for j = 0:(size(y, 2) - 1)
                phi = 2 * pi * freqs(h) * (j / fps);
                re = re + y(j+1) * cos(phi);
                im = im + y(j+1) * sin(phi);
            end
            power(h) = re * re + im * im;
        end
        [max_peak_v, max_peak_i] = max(power);
        bpm_smooth(i) = 60*freqs(max_peak_i);

        % Plot amplitudes in the fine-tuning interval
        hold on;
        smoothing_plot = plot(freqs*60, sqrt(power), 'r', 'LineWidth', 2);

        % Plot legend
        set(fft_plot, 'Displayname', 'FFT modulus');
        set(smoothing_plot, 'Displayname', 'Peak smoothing');
        legend('Location', 'NorthEast');
        
        % Plot BPM over time
        subplot(2, 1, 2);
        t = (0:i-1) * ((size(orig_y, 2) / fps) / (num_bpm_samples - 1));
        hold off;
        plot(t, bpm_smooth, 'r', 'LineWidth', 2);
        max_time_plot_bpm = max(max_time_plot_bpm, max(bpm_smooth));
        min_time_plot_bpm = min(min_time_plot_bpm, min(bpm_smooth));
        axis([0 ((size(orig_y, 2)-1) / fps) min_time_plot_bpm max_time_plot_bpm]);
        grid on;
        xlabel('Time (s)');
        ylabel('Heart rate (BPM)');

        % Print speed factor over real time
        box = uicontrol('style', 'text');
        set(box, 'String', [num2str(ANIMATION_SPEED_FACTOR) 'x']);
        set(box, 'Position', [512-42, 7, 40, 38]);
        set(box, 'FontName', 'Ubuntu Condensed');
        set(box, 'ForegroundColor', hex2dec({'88' '88' '88'})/255);
        set(box, 'FontSize', 22);
        set(box, 'BackgroundColor', hex2dec({'cc' 'cc' 'cc'})/255);

        drawnow();  % Flush graphics    
        pause(BPM_SAMPLING_PERIOD / ANIMATION_SPEED_FACTOR);
            
    end

    mean_hr = num2str(mean(bpm_smooth));
end