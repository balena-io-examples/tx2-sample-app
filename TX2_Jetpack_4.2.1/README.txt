STEPS FOR RUNNING THIS SAMPLE FOR JETSON TX2 Jetpack 4.2.1 (L4T 32.2)

1) Install NVidia SDK and download the packages for TX Jetpack 4.2.1. Select TX2 needs to be selected as device and Jetpack 4.2.1 as release software. DO NOT flash the board using NVidia SDK.

2) Ensure you have a BalenaOS installed on the TX2 that is compatible with Jetpack 4.2.1. TX2 board needs to have been flashed previously with L4T 32.2 partitions so that the SD-card BalenaOS flasher image can be loaded.

3) Copy the cuda repo deb package from ~/Downloads/nvidia/sdkm_downloads near the Dockerfile. See Dockerfile for instructions.

4) Build Dockerfile. All cuda 10 samples are built, therefore the resulting image is around 3.7GB. The cuda libraries including ALL built examples are around 3GB.

5) To further shrink down the image as needed, Dockerfile can be customized to:
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
