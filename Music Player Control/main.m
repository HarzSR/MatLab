clc                      
close all
fprintf('wait please\n');            
imaqreset                   
clear all                     
vidobj = videoinput('winvideo',1);     
set(vidobj,'ReturnedColorSpace','RGB');  
set(vidobj,'FramesPerTrigger',1);
set(vidobj,'TriggerRepeat',inf);        
triggerconfig(vidobj,'manual');
start(vidobj);
range=20;
fprintf('Bring Markers....\n');          
delay(2000);
fprintf('Thresolding for GREEN Marker\n');
im = getsnapshot(vidobj);          
fprintf('Resolution is ');
size(im)                      
[GR_M_R GR_M_G GR_M_B] = get_MY_THRESHOLDING(im);
delay(300);
close all;
m=figure;
h=actxcontrol('WMPlayer.OCX.7', [0 0 500 550], m);
[filename pathname] = uigetfile('*.*','Please select a file');
h.URL=[pathname filename];
h.controls.play;
i=0;j=0;
set(h.settings,'volume',i);    
figure;
i=0;
while(1)
    trigger(vidobj);                 
    im=getdata(vidobj);             
    [r c d]=size(im);
    output_image_g=zeros(r,c);         
    for i1=1:r
      for i2=1:c
        if( (im(i1,i2,1)>GR_M_R-range) && (im(i1,i2,1)<GR_M_R+range) && (im(i1,i2,2)>GR_M_G-range) && (im(i1,i2,2)<GR_M_G+range) && (im(i1,i2,3)>GR_M_B-range) && (im(i1,i2,3)<GR_M_B+range) )
            output_image_g(i1,i2)=1;
        end
      end
    end
   imshow(output_image_g);
      [r_cent_g c_cent_g]=centroid1(output_image_g);       
      total_pix=sum(sum(output_image_g));              
   if (total_pix>500)
       h.controls.pause;
       disp('Media Paused');
   elseif (c_cent_g>(90))   % My camera resolution = 120*160
            disp('Volume Up');
            i=i+3;
            h.controls.play;
   elseif (c_cent_g<(70))   % My camera resolution = 120*160
            disp('Volume Down');
            i=i-3;
            h.controls.play;
   else
            h.controls.play;
            disp('Playing');
   end
     if(i<2)            % to restrict min. volume as 2
         i=2;
     end
 set(h.settings,'volume',i); 
end
