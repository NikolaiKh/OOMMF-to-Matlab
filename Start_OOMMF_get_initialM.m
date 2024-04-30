
clear all

Hext = '50'; % in mT
cellsize = '100.0e-9'; % in m
cellscount = '2048'; % N of cells 

currentFolder = pwd;
oommf_initial_file = [char(34) pwd '\ME1_2DPBC_initM.mif' char(34)];
oommf_tcl_file = [char(34) 'd:\oommf_20b0\oommf.tcl' char(34)];
num_of_cores = getenv('NUMBER_OF_PROCESSORS'); % number of logical cores on CPU

phiangles = 0; %not play a role
for phi_ii = 1:length(phiangles)
    phi_angle = phiangles(phi_ii) * pi/180; % in radians
    phi_deg = num2str( phi_angle*180/pi, '%3.1f' );

    basename_init = ['./Initial_states/init_phi' phi_deg '_H' Hext '_cell' cellsize];

    command0=['tclsh ' oommf_tcl_file ' boxsi ' oommf_initial_file ...
        ' -threads ' num_of_cores...
        ' -parameters ' char(34) 'Hext ' Hext...
        ' cellscount ' cellscount...
        ' phi_angle ' num2str(phi_angle) ' cellsize ' cellsize...
        ' basename ' basename_init char(34)];
    system(command0);
end
