README
------

Important: For Jetpack 4.2.1 - L4T 32.2 please see and use the instructions and Dockerfile from TX2_Jetpack_4.2.1 directory

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

To display images from Cuda or OpenCV examples from the container,
ensure a HDMI display is connected to the board and start the X display
server:

$ startx

In another container terminal please type:

$ export DISPLAY=:0

$ cd /usr/local/cuda/samples/2_Graphics/marchingCubes

$ make && ./marchingCubes

NOTE: Some OpenCV test samples construct a GStreamer pipeline. If you encounter
an error regarding specific gstreamer symbols not being found, please try to re-run
the sample application. This happens only for the first run if GStreamer did not build-up
its internal plugin cache yet.
