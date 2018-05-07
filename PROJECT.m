function varargout = PROJECT(varargin)
% PROJECT MATLAB code for PROJECT.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PROJECT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PROJECT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PROJECT

% Last Modified by GUIDE v2.5 04-Dec-2014 11:22:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PROJECT_OpeningFcn, ...
                   'gui_OutputFcn',  @PROJECT_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PROJECT is made visible.
function PROJECT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PROJECT (see VARARGIN)

% Choose default command line output for PROJECT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PROJECT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PROJECT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadImageButton.
function LoadImageButton_Callback(hObject, eventdata, handles)


[filename, pathname] = uigetfile({'*.*'},'Pick an Image File'); % Load any type of image.
image = imread([pathname,filename]); % Read image of the specified name from the specified path.

axes(handles.LoadImageAxes) % Make handle to the axes1(So that we can deal with the axes1).
imshow(image); % Just show the image on axes1.

handles.image = image; % Maintian structure through handles on it(Define User data).

I = handles.image;

I1=rgb2gray(I);                             %converting color(RGB) image to Gray Image

I2=edge(I1,'roberts',0.15,'both');          %Edge detection (making edges prominent)

SE=strel('line',3,90);                      %se means Structuring Element
I3=imerode(I2,SE);                          %Erosion

SE=strel('rectangle',[25,25]);
I4=imclose(I3,SE);                          %Dilation

I5=bwareaopen(I4,2000);                     %The function bwareaopen() will delete white areas smaller than P(2000) pixels.

[y,x,z]=size(I5);
myI=double(I5);
%tic
 white_y=zeros(y,1);

 for i=1:y
    for j=1:x
             if(myI(i,j,1)==1) 
                white_y(i,1)= white_y(i,1)+1; 
                
            end  
     end       
 end
 [temp MaxY]=max(white_y);
 PY1=MaxY;
 while ((white_y(PY1,1)>=5)&&(PY1>1))
        PY1=PY1-1;
 end    
 PY2=MaxY;
 while ((white_y(PY2,1)>=5)&&(PY2<y))
        PY2=PY2+1;
 end
 IY=I(PY1:PY2,:,:);

handles.OnlyNumberPlateImage=IY;
guidata(hObject, handles);



% --- Executes on button press in ShowPlate.
function ShowPlate_Callback(hObject, eventdata, handles)

axes(handles.axes5) % Make handle to the axes1(So that we can deal with the axes1).
imshow(handles.OnlyNumberPlateImage); % Just show the image on axes1.



% --- Executes on button press in GD.
function GD_Callback(hObject, eventdata, handles)

IY=handles.OnlyNumberPlateImage;

BW=im2bw(IY,0.5);

BW = ~BW;

stats = regionprops(BW);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp=regionprops(BW);
for i=1:length(stats)-1
    for j=1:length(stats)-i
        if(stats(j).BoundingBox(2)<stats(j+1).BoundingBox(2))
            temp(1)=stats(j);
            stats(j)=stats(j+1);
            stats(j+1)=temp(1);
            %swap(stats(j),stats(j+1))
        end
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p=1;
for index=1:length(stats)
    if stats(index).Area > 300  && stats(index).BoundingBox(3)*stats(index).BoundingBox(4) < 30000
          x = ceil(stats(index).BoundingBox(1))
          y= ceil(stats(index).BoundingBox(2))
          widthX = floor(stats(index).BoundingBox(3)-1)
          widthY = floor(stats(index).BoundingBox(4)-1)
          subimage(index) = {BW(y:y+widthY,x:x+widthX,:)}; 
          %figure, imshow(subimage{index})
          myImage=subimage{index};
          %figure, imshow(myImage);
          SE=strel('rectangle',[3,3]);
          myImage=imclose(myImage,SE);
          %pause(0.5);
          %figure, imshow(myImage);  
          
          flag='false';
          [flag,result]=CHECK1(myImage);
         
          if strcmp(flag,'true')
              finds(p,1)=result;
              %figure, imshow(subimage{index});
              %figure('Name',result), imshow(myImage);  pause(1);
          
              
              p=p+1;
              %fprintf( fid, '%c',result);
          end
          
    end
end

for i=1:length(finds)
    if(finds(i,1)=='L')
        s=i;
    end
end

s=s-1;
for i=1:length(finds)
    newFinds(i,1)=finds(s+1,1);
    s=mod(s+1,length(finds));
    
end

fid = fopen( 'Number Plate.txt', 'wt' );
for i=1:length(finds)
    fprintf( fid, '%s',newFinds(i,1));
end

msgbox('Document has been created');


% --- Executes on button press in ShowNumber.
function ShowNumber_Callback(hObject, eventdata, handles)

IY=handles.OnlyNumberPlateImage;

BW=im2bw(IY,0.5);

BW = ~BW;

stats = regionprops(BW);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp=regionprops(BW);
for i=1:length(stats)-1
    for j=1:length(stats)-i
        if(stats(j).BoundingBox(2)<stats(j+1).BoundingBox(2))
            temp(1)=stats(j);
            stats(j)=stats(j+1);
            stats(j+1)=temp(1);
            %swap(stats(j),stats(j+1))
        end
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p=1;
for index=1:length(stats)
    if stats(index).Area > 300  && stats(index).BoundingBox(3)*stats(index).BoundingBox(4) < 30000
          x = ceil(stats(index).BoundingBox(1))
          y= ceil(stats(index).BoundingBox(2))
          widthX = floor(stats(index).BoundingBox(3)-1)
          widthY = floor(stats(index).BoundingBox(4)-1)
          subimage(index) = {BW(y:y+widthY,x:x+widthX,:)}; 
          %figure, imshow(subimage{index})
          myImage=subimage{index};
          %figure, imshow(myImage);
          SE=strel('rectangle',[3,3]);
          myImage=imclose(myImage,SE);
          %pause(0.5);
          %figure, imshow(myImage);  
          
          flag='false';
          [flag,result]=CHECK1(myImage);
         
          if strcmp(flag,'true')
              finds(p,1)=result;
              %figure, imshow(subimage{index});
              %figure('Name',result), imshow(myImage);  pause(1);
          
              
              p=p+1;
              %fprintf( fid, '%c',result);
          end
          
    end
end

for i=1:length(finds)
    if(finds(i,1)=='L')
        s=i;
    end
end

s=s-1;
for i=1:length(finds)
    newFinds(i,1)=finds(s+1,1);
    s=mod(s+1,length(finds));
    
end

for i=1:length(finds)
    str(i)=newFinds(i,1);
end

msgbox(str);
