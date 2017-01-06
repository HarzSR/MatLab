function JigSaw
close all;clc
global status h s D1 m Im
status=0;
[file path]=uigetfile('*');
Im=imread([path,file]);
m=3;
s=size(Im);
dr=floor(s(1)/m);dc=floor(s(2)/m);
for i=1:m
    for j=1:m
        D{i,j}=Im(dr*(i-1)+1:dr*i,dc*(j-1)+1:dc*j,:);
    end
end
R=rand(m^2,1);[V,I]=sort(R);D1=D;
for i=1:length(I);D1{i}=D{I(i)};end
h=figure('menubar','none',...
    'numbertitle','off',...
    'paperunit','points',...
    'name','Jigsaw',...
    'PaperSize',[s(1),s(2)],...
    'PaperUnits','points',...
    'WindowButtonDownFcn',@Down,...
    'WindowButtonUpFcn',@Up,...
    'WindowButtonMotionFcn',@Motion);
imshow(cell2mat(D1))
function Down(varargin)
global status x1 y1 s h m
status=1;
p=get(h,'currentpoint');
c=p(1);
r=s(1)-p(2);
if r>0 && c>0 && r<=s(1) && c<=s(2)
    x1=ceil(r/(s(1)/m));
    y1=ceil(c/(s(2)/m));
    if x1==m+1;x1=m;end
    if y1==m+1;y1=m;end
end
function Up(varargin)
global status x1 y1 x2 y2 s h m D1
status=0;
p=get(h,'currentpoint');
c=p(1);
r=s(1)-p(2);
if r>0 && c>0 && r<=s(1) && c<=s(2)
    x2=ceil(r/(s(1)/m));
    y2=ceil(c/(s(2)/m));
    if x2==m+1;x2=m;end
    if y2==m+1;y2=m;end
end
temp=D1{x1,y1};
D1{x1,y1}=D1{x2,y2};
D1{x2,y2}=temp;
imshow(cell2mat(D1));drawnow
function Motion(varargin)
global status x1 y1 s h m D1 im im1 im2
if status
    im=cell2mat(D1);
    im1=im;
    clc
    p=get(h,'currentpoint')
    r=s(1)-p(2);
    c=p(1);
    if r>0 && c>0 && r<=s(1) && c<=s(2)
        x=ceil(r/(s(1)/m));
        y=ceil(c/(s(2)/m));
        if x==m+1;x=m;end
        if y==m+1;y=m;end
    end
    try im2=im((x1-1)*s(1)/m+1:x1*s(1)/m,(y1-1)*s(2)/m+1:y1*s(2)/m,:);end
    [p q w]=size(im2);
    if ((r>=p/2) && (c>=q/2) && (r<=s(1)-p/2) && (c<=s(2)-q/2))
        try
            im1(r-p/2:r+p/2-1,c-q/2:c+q/2-1,:)=im2;
            imshow(im1);drawnow
        end
    end
end
