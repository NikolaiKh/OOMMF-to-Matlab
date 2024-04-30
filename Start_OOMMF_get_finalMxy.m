clear all

currentFolder = pwd;
oommf_tcl_file = [char(34) 'd:\oommf_20b0\oommf.tcl' char(34)];
num_of_cores = getenv('NUMBER_OF_PROCESSORS'); % number of logical cores on CPU

Hext = '50'; % in mT
deltaMs = '0.2';
deltaKuni = '0.488';
% cellsize = '100.0e-9'; % in m
sigma_Gauss = '30.0e-6'; % in m. sigma of Gauss excitation in space
timestep = '100e-15'; % in seconds
stoptime = '0.3e-9'; % in seconds

phiangles = 0;
for phi_ii = 1:length(phiangles)
    phi_angle = phiangles(phi_ii) * pi/180; % in radians
    phi_deg = num2str( phi_angle*180/pi, '%3.1f' );

    files = dir('.\Initial_states\*.omf'); % takes all filenames in directory

    % Going though the files' list
    initial_omf = '';  
    for i = 1:length(files)
        if contains(files(i).name, ['phi' phi_deg]) && contains(files(i).name, ['H' Hext])
            initial_omf = ['./Initial_states/' files(i).name];
            break;  % Break the loop if name is found
        end
    end

    dataOMF = omf2matlab(initial_omf);
    cellscount = num2str(dataOMF.xnodes); 
    cellsize = num2str(dataOMF.xstepsize);
    Ms0 = num2str( sqrt( dataOMF.datax(1,1,1)^2 + dataOMF.datay(1,1,1)^2 + dataOMF.dataz(1,1,1)^2 ) );

    % start dynamic calculations
    basename_torque = ['./Mxy/Mxy_phi' phi_deg '_H' Hext '_sigma' sigma_Gauss '_dM' deltaMs...
        '_dKu' deltaKuni '_cellsize' cellsize '_stoptime' stoptime];
    oommf_torque_file = [char(34) pwd '\ME1_2DPBC_nonuniform_M_Ku_getMxy.mif' char(34)];
    command_torque=['tclsh ' oommf_tcl_file ' boxsi ' oommf_torque_file...
        ' -threads ' num_of_cores...
        ' -parameters ' char(34) 'Hext ' Hext...
        ' phi_angle ' num2str(phi_angle) ' cellsize ' cellsize...
        ' initial_omf ' initial_omf ' cellscount ' cellscount...
        ' Ms0 ' Ms0...
        ' deltaMs ' deltaMs ' deltaKuni ' deltaKuni...
        ' sigma_Gauss ' sigma_Gauss...
        ' timestep ' timestep ' stoptime ' stoptime...
        ' basename ' basename_torque char(34)];
    system(command_torque);
end
