

clear all
close all
clc

time =5;

Fs = 512; %����Ƶ��
T = 1 / Fs;%����ʱ��
L = Fs * time;  %�źų���
t = (0:L-1) * T;%ʱ������
t = t';
%%  ��������    
while 1
    
    fid = fopen('Data.txt' , 'r');
    line_count = LineNumber(fid);
    raw = cell(line_count,1);
    frewind(fid);
    line = 1;
    while feof(fid) == 0
        raw{line,1} = fgetl(fid);
        line = line+1;
    end
    fclose(fid); 
    


    if line==512*time+1

        raw = raw;
      

        bridge1 = raw;  
        try
            RawData = str2num (char(bridge1));
        catch
            continue;
        end
        
        OrignData = RawData;        

        Data = OrignData;
        
        Lin_hai_hangshu = size(Data , 1);
%%������ԴΪһ��ͨ����������һ��ͨ�������ݽ��в�ִ���Ȼ����Ч
        for i = 1:(Lin_hai_hangshu/2)
            O1Data(i) = Data(i);
            O2Data(i) = Data(i+1);
        end




        %%  ȥƽ��
        % Data = Data - mean(Data);
         O1Data = O1Data - mean(O1Data);
         O2Data = O2Data - mean(O2Data);

        fs=Fs;
        N=Fs * time;

        %% (�ֺ�д)�ϲ�����ͨ��������
         Lin_hai_hangshu = size(Data , 1);
         
         for i = 1:(Lin_hai_hangshu/2)
             O_Data(2*i-1) = O1Data(i);
             O_Data(2*i) = O2Data(i);
         end

        %%   ���ֺ�д��������ͨ�˲�
        New = O_Data;
        NumChan = size(New,2);
        SampleRate = Fs;
        SampleSiteNum = size(New,1);
        n = 0 : SampleSiteNum-1; 
        TimeSeries = n / SampleRate;                         %ʱ������
        FrequencySeries = n * SampleRate / SampleSiteNum;          %Ƶ������


        Passband = [5*2 35*2];%����ͨ��5Hz��35Hz
        butterTrad3 = Passband / SampleRate;
        [butterTrad1,butterTrad2] = butter(5,butterTrad3);
        FilterNew = filtfilt (butterTrad1,butterTrad2,New); 
        %%    ��ͼ
        base = FilterNew;
        y1=fft(base);
        y2=fftshift(y1);
        % N=N*2;
        N = N ;
        f=(0:N-1)*fs/N-fs/2; 


        fre=abs(y2);     %��Ƶ�ʵķ���ֵ��y�ᣩ
        location = find(f<12&f>8);   %�˲���ֻҪ9hz��12hz�ģ�location�����ǵ�λ������
        x=f(location);
        try
            y=fre(location);
        catch
            continue;
        end
        
        [xmax,index] = max(y);%�ҵ���ֵ���ĵ㣬���ص�index�Ǹõ��λ��
        maxfre=x(index)%����ֵ��Ƶ��ֵ
        
    %% ��ָ��д��Result.txt��
    fid = fopen('Result.txt','w');  
    fprintf( fid,'%s',int2str(maxfre) );   
    fclose(fid);
    
    end

end
