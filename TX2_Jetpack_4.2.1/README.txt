STEPS FOR RUNNING THESE SAMPLE APPS FOR JETSON TX2 Jetpack 4.2.1 (L4T 32.2)

CUDA 10 Samples:
---------------
1) Install NVidia SDK and download the packages for TX Jetpack 4.2.1. Select TX2 needs to be selected as device and Jetpack 4.2.1 as release software. DO NOT flash the board using NVidia SDK.

2) Ensure you have a BalenaOS installed on the TX2 that is compatible with Jetpack 4.2.1. TX2 board needs to have been flashed previously with L4T 32.2 partitions so that the SD-card BalenaOS flasher image can be loaded.

3) Copy the cuda repo deb package from ~/Downloads/nvidia/sdkm_downloads near Dockerfile.cuda10samples. See Dockerfile.cuda10samples for instructions.

4) Build Dockerfile.cuda10samples. All cuda 10 samples are built, therefore the resulting image is around 3.7GB. The cuda libraries including ALL built examples are around 3GB.

5) To further shrink down the image as needed, Dockerfile.cuda10samples can be customized to:
 - install only the cuda packages that are needed (use --no-install-recommends)
 - not build the examples, instead delete them in the builder container before they are copied to the final container
 - delete the sample files from cuda directory

6) Some samples running:

 - /usr/local/cuda-10.0/samples/2_Graphics/bindlessTexture/bindlessTexture
    CUDA bindlessTexture Starting...

    GPU Device 0: "NVIDIA Tegra X2" with compute capability 6.2

    Device 0: < NVIDIA Tegra X2 >, Compute SM 6.2 detected
    Loaded './data/flower.ppm', 600 x 450 pixels
    Loaded './data/person.ppm', 600 x 450 pixels
    Loaded './data/sponge.ppm', 640 x 480 pixels
    Press space to toggle animation
    Press '+' and '-' to change lod level
    Press 'r' to randomize virtual atlas

 - /usr/local/cuda-10.0/samples/2_Graphics/marchingCubes/marchingCubes
    [./marchingCubes] - Starting...
    MarchingCubes
    GPU Device 0: "NVIDIA Tegra X2" with compute capability 6.2

    grid: 32 x 32 x 32 = 32768 voxels
    max verts = 102400
    Read './data/Bucky.raw', 32768 bytes

 - /usr/local/cuda-10.0/samples/3_Imaging/bicubicTexture/bicubicTexture
    Starting bicubicTexture
    [CUDA BicubicTexture] (OpenGL Mode)
    GPU Device 0: "NVIDIA Tegra X2" with compute capability 6.2

    CUDA device [NVIDIA Tegra X2] has 2 Multi-Processors
    Loaded 'lena_bw.pgm', 512 x 512 pixels

Gstreamer Pipeline Sample with hardware decoding:
------------------------------------------------

The resulting image for this app is around 1.3G.

No other files need to be added to the repository to build this sample application.

Dockerfile.gstreamer pulls, installs and sets up all the prerequisites for running
a sample pipeline.

1) Start X display server:
   $ X &

2) Create pipeline:
   $ gst-launch-1.0 videotestsrc ! 'video/x-raw, format=(string)I420,width=(int)640, height=(int)480' ! omxh264enc ! 'video/x-h264, stream-format=(string)byte-stream' ! h264parse ! omxh264dec ! nvoverlaysink -e
