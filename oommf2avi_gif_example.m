function oommf2avi_gif_example
% Example of use of omf2matlab:
% Make a movie file from micromagnetic data OOMMF from one directory DirName

%% read file names
dir_name = './Mxy/';
file_extention = '*.omf';
f_n = dir([dir_name file_extention]);
%% sort file by date
[~,idx] = sort([f_n.datenum]);
f_n = f_n(idx);
fileNames = {f_n.name};
gif_name = 'SW_via_PID.gif';
avi_obj = VideoWriter('SW_via_PID.avi');
avi_obj.Quality = 100;   % 0 -- 100
avi_obj.FrameRate = 5;  % fps
open(avi_obj)

%% get data dimentions
mult = 1e6; % switch to in um
dataOMF = omf2matlab([dir_name fileNames{1}]);
Xvector = mult* linspace(dataOMF.xmin, dataOMF.xmax, dataOMF.xnodes);
Yvector = mult* linspace(dataOMF.ymin, dataOMF.ymax, dataOMF.ynodes);
Zvector = mult* linspace(dataOMF.zmin, dataOMF.zmax, dataOMF.znodes);
dataX_zerotime = dataOMF.datax;
dataZ_zerotime = dataOMF.dataz;
theta0 = atan(dataZ_zerotime./dataX_zerotime);

bwr = @(n)interp1([1 2 3 4 5], [215,25,28; 252,141,89; 255 255 255; 145,207,96; 26,150,65]/255, linspace(1, 5, n), 'linear');
% https://colorbrewer2.org/ is used for nice colormap
h = figure;
colormap(bwr(64));
%% get data from files
for ff = 1:length(fileNames)
    dataOMF = omf2matlab([dir_name fileNames{ff}]);
    Magn_x = dataOMF.datax;% - 1*dataZ_zerotime;
    Magn_z = dataOMF.dataz;% - 1*dataZ_zerotime;
    theta = atan(Magn_z./Magn_x) - theta0;
    time_vect(ff) = dataOMF.time*1e9;
%     time_vect(ff) = (ff-1)*0.01;
    % imagesc(Xvector, Yvector, Magn_z');
    imagesc(Xvector, Yvector, theta);
    axis equal;
    xlim([min(Xvector) max(Xvector)]);
    ylim([min(Yvector) max(Yvector)]);
    maxZ = max(max(abs(Magn_z)));
    % clim([-200 200]);
    clim([-1 1]*1e-2 - 0.005);
    title(['time = ' num2str(time_vect(ff),'%.2f') ' ns']);
    xlabel('x (\mum)');
    ylabel('y (\mum)');
    set(gca,'FontSize', 18);
    clb = colorbar;
    % set(get(clb,'label'),'string','$m_{z}$ (A/m)', 'Interpreter','latex','Rotation',-90);
    set(get(clb,'label'),'string','$m_{z}$ (rad)', 'Interpreter','latex','Rotation',-90);
    drawnow;

    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if ff == 1
        imwrite(imind,cm,gif_name,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,gif_name,'gif','WriteMode','append');
    end;
    % Write AVI file
    writeVideo(avi_obj,frame);
end;
close(avi_obj);
end