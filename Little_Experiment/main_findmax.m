clear all
close all
clc

%%  函数定义

time = 10;

Fs = 256; %采样频率
T = 1 / Fs;%采样时间
L = Fs * time;  %信号长度
t = (0:L-1) * T;%时间向量
t = t';
%%   获得文件的起始更新时间并载入数据    


% dirs=dir('D:\挑战杯\程序\demo\*.txt');  
% dircell=struct2cell(dirs)' ;   
% filenames=dircell(:,1); 
% DataName=char(filenames);

raw = LoadData('colour_2018-03-09_20-50-03.txt');
     
%%   剔除字符和未完成采样过程的数据

bridge1 = raw(6:end-1,:);      
RawData = str2num (char(bridge1));
OrignData = RawData(:,[2,3]);        
Data = OrignData([(Fs * 10 + 1) : Fs * (10 + time)],:);
O1Data = Data(:,1);
O2Data = Data(:,2);


%%  去平均
O1Data = O1Data - mean(O1Data);
O2Data = O2Data - mean(O2Data);

fs=256;
n=256 * time;

base = O2Data;
y1=fft(base);
y2=fftshift(y1);
f=(0:n-1)*fs/n-fs/2; 
figure(1)
plot(t,base,'r');%原始采样图
figure(2)
plot(f,abs(y2),'b.-');%频谱图
axis([3 20 0 5000]); 
fre=abs(y2);     %求频率的绝对值
location = find(f<12&f>8);   %滤波即只要3hz到20hz的，location是它们的位置向量
x=f(location);
y=fre(location);
[xmax,index] = max(y);%找到幅值最大的点，返回的index是该点的位置
maxfre=x(index)%最大幅值的频率值
figure(3)
plot(x,y)
% axis([3 20 0 5000]); 