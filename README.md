# OOMMF-to-Matlab
Files to start and convert OOMMF calculations of ultrafast demagnetization and anisotropy quenching

### Files description:

ME1_2DPBC_initM.mif -- mif file to get initial magnetization distribution. Calculations with energy minimization

ME1_2DPBC_nonuniform_M_Ku_getMxy.mif -- mif file to get magnetization dynamics and save Mz(t) to folder 'Mxy'. Options are nedded for correct save for MatLab postprocessing. More info: https://thebrickinthesky.wordpress.com/2013/11/06/oommf-2/

Start_OOMMF_......m -- Maltab files to start corresponding mif-files

omf2matlab.m -- Matlab wrap to read .mif files. More info here: [https://www.mathworks.com/matlabcentral/fileexchange/129674-load-oommf-file-to-matlab-array](https://www.mathworks.com/matlabcentral/fileexchange/129674-load-oommf-file-to-matlab-array)

oommf2avi_gif_example.m -- Matlab script to make video from OOMMF output files
