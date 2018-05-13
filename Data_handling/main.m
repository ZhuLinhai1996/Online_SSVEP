

clear all
close all
clc

time =5;

Fs = 512; %采样频率
T = 1 / Fs;%采样时间
L = Fs * time;  %信号长度
t = (0:L-1) * T;%时间向量
t = t';
%%  载入数据    
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
%%数据来源为一个通道，但将这一个通道的数据进行拆分处理竟然有奇效
        for i = 1:(Lin_hai_hangshu/2)
            O1Data(i) = Data(i);
            O2Data(i) = Data(i+1);
        end




        %%  去平均
        % Data = Data - mean(Data);
         O1Data = O1Data - mean(O1Data);
         O2Data = O2Data - mean(O2Data);

        fs=Fs;
        N=Fs * time;

        %% (林海写)合并两个通道的数据
         Lin_hai_hangshu = size(Data , 1);
         
         for i = 1:(Lin_hai_hangshu/2)
             O_Data(2*i-1) = O1Data(i);
             O_Data(2*i) = O2Data(i);
         end

        %%   （林海写）再来带通滤波
        New = O_Data;
        NumChan = size(New,2);
        SampleRate = Fs;
        SampleSiteNum = size(New,1);
        n = 0 : SampleSiteNum-1; 
        TimeSeries = n / SampleRate;                         %时间序列
        FrequencySeries = n * SampleRate / SampleSiteNum;          %频率序列


        Passband = [5*2 35*2];%设置通带5Hz到35Hz
        butterTrad3 = Passband / SampleRate;
        [butterTrad1,butterTrad2] = butter(5,butterTrad3);
        FilterNew = filtfilt (butterTrad1,butterTrad2,New); 
        %%    画图
        base = FilterNew;
        y1=fft(base);
        y2=fftshift(y1);
        % N=N*2;
        N = N ;
        f=(0:N-1)*fs/N-fs/2; 


        fre=abs(y2);     %求频率的幅度值（y轴）
        location = find(f<12&f>8);   %滤波即只要9hz到12hz的，location是它们的位置向量
        x=f(location);
        try
            y=fre(location);
        catch
            continue;
        end
        
        [xmax,index] = max(y);%找到幅值最大的点，返回的index是该点的位置
        maxfre=x(index)%最大幅值的频率值
        
    %% 将指令写入Result.txt中
    fid = fopen('Result.txt','w');  
    fprintf( fid,'%s',int2str(maxfre) );   
    fclose(fid);
    
    end

end
