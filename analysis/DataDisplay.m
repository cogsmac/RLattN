function varargout = DataDisplay(varargin)
% DATADISPLAY M-file for DataDisplay.fig
%      DATADISPLAY, by itself, creates a new DATADISPLAY or raises the existing
%      singleton*.
%
%      H = DATADISPLAY returns the handle to a new DATADISPLAY or the handle to
%      the existing singleton*.
%
%      DATADISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATADISPLAY.M with the given input arguments.
%
%      DATADISPLAY('Property','Value',...) creates a new DATADISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataDisplay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataDisplay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataDisplay

% Last Modified by GUIDE v2.5 08-Feb-2011 13:53:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DataDisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @DataDisplay_OutputFcn, ...
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


% --- Executes just before DataDisplay is made visible.
function DataDisplay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataDisplay (see VARARGIN)

% Choose default command line output for DataDisplay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataDisplay wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%Updating gui data with User defined Input

 set(handles.uitable8,'Data', varargin{1})
 set(handles.uitable7,'Data', varargin{2})
 set(handles.uitable6,'Data', varargin{3})
 set(handles.uitable10,'Data', varargin{4})
 set(handles.uitable11,'Data', varargin{5})
set(handles.uitable12,'Data', varargin{6})
 
% --- Outputs from this function are returned to the command line.
function varargout = DataDisplay_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
