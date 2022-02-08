The following flags can be passed to the CMake generation command to configure the installation step:
| CMake Flag                               | Default Value       | Values accepted     | Description   |
| ---------------------------------------- | ------------------- | ---------------------------------------------- | ------------- |
| `CMAKE_INSTALL_PREFIX`                   | platform dependent  | A path to any directory with write permissions | The location that the MATLAB Interface to Arrow will be installed.
| `MATLAB_ADD_INSTALL_DIR_TO_SEARCH_PATH`  | `ON`        | `ON` or `OFF` | Whether the path to the install directory should be added directly added to the MATLAB Search Path.
| `MATLAB_ADD_INSTALL_DIR_TO_STARTUP_FILE` | `ON`        | `ON` or `OFF` | Whether a command to add the path to the install directory should be added to the `startup.m` file located at the MATLAB `userpath`.

###### `CMAKE_INSTALL_PREFIX`   
The install command will install the interface to the location pointed to by `CMAKE_INSTALL_PREFIX`. The default value for this CMake variable is platform dependent. Default values for the location on different platforms can be found here: [`CMAKE_INSTALL_PREFIX`](https://cmake.org/cmake/help/v3.0/variable/CMAKE_INSTALL_PREFIX.html). 

###### `MATLAB_ADD_INSTALL_DIR_TO_SEARCH_PATH`   
Call `addpath` and `savepath` to modify the default `pathdef.m` file that MATLAB uses on startup. This option is on by default. However, it can only be used if CMake has the appropriate permissions to modify `pathdef.m`.

###### `MATLAB_ADD_INSTALL_DIR_TO_STARTUP_FILE`   
Add an `addpath` command to the `startup.m` file located at the [`userpath`](https://uk.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html#:~:text=on%20Search%20Path.-,userpath%20Folder%20on%20the%20Search%20Path,-The%20userpath%20folder). This option can be used if a user does not have the permissions to modify the default `pathdef.m` file. 
