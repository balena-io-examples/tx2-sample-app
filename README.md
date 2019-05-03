README
------

Add BalenaOS application to this repository and execute:
$ git push balena master

After the Application is built and downloaded successfully to the TX2, open a container console and compile the deviceQuery application:

$ cd /usr/local/cuda/samples/1_Utilities/deviceQuery/

$ make && ./deviceQuery

You should see Result = PASS

$ cd /usr/local/cuda/samples/0_Simple/clock

$ make && ./clock

To test GPU computing:

$ cd /usr/local/cuda/samples/6_Advanced/eigenvalues

$ make && ./eigenvalues

You should see "Test succeeded"

Other example:

$ cd /usr/local/cuda/samples/7_CUDALibraries/jpegNPP

$ make && ./jpegNPP

A scaled down file scaled.jpeg should be produced

OpenCV example:

$ /src/opencv/build/bin/opencv_test_cudafilters
