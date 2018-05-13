clear all
close all
clc

%%  ��������

time = 10;

Fs = 256; %����Ƶ��
T = 1 / Fs;%����ʱ��
L = Fs * time;  %�źų���
t = (0:L-1) * T;%ʱ������
t = t';
%%   ����ļ�����ʼ����ʱ�䲢��������    


% dirs=dir('D:\��ս��\����\demo\*.txt');  
% dircell=struct2cell(dirs)' ;   
% filenames=dircell(:,1); 
% DataName=char(filenames);

raw = LoadData('colour_2018-03-09_20-50-03.txt');
     
%%   �޳��ַ���δ��ɲ������̵�����

bridge1 = raw(6:end-1,:);      
RawData = str2num (char(bridge1));
OrignData = RawData(:,[2,3]);        
Data = OrignData([(Fs * 10 + 1) : Fs * (10 + time)],:);
O1Data = Data(:,1);
O2Data = Data(:,2);


%%  ȥƽ��
O1Data = O1Data - mean(O1Data);
O2Data = O2Data - mean(O2Data);

fs=256;
n=256 * time;

base = O2Data;
y1=fft(base);
y2=fftshift(y1);
f=(0:n-1)*fs/n-fs/2; 
figure(1)
plot(t,base,'r');%ԭʼ����ͼ
figure(2)
plot(f,abs(y2),'b.-');%Ƶ��ͼ
axis([3 20 0 5000]); 
fre=abs(y2);     %��Ƶ�ʵľ���ֵ
location = find(f<12&f>8);   %�˲���ֻҪ3hz��20hz�ģ�location�����ǵ�λ������
x=f(location);
y=fre(location);
[xmax,index] = max(y);%�ҵ���ֵ���ĵ㣬���ص�index�Ǹõ��λ��
maxfre=x(index)%����ֵ��Ƶ��ֵ
figure(3)
plot(x,y)
% axis([3 20 0 5000]); 