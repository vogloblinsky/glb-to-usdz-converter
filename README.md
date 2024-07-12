# glb to usdz converter using Docker, [PixarAnimationStudios USD](https://github.com/PixarAnimationStudios/OpenUSD) and [usd_from_gltf](https://github.com/google/usd_from_gltf)

## Requirements

Docker

## Process

-   build the Dockerfile
-   create a docker container with the image build, the input file is copied inside the docker image
-   run the docker container, the conversion is done, the container exit himself
-   run the command to copy the converted file on your computer

## Commands

##

    git clone https://github.com/vogloblinsky/glb-to-usdz-converter

##

    cd glb-to-usdz-converter

##

    copy your glb file here, and rename it input-file.glb

##

    docker build --tag 'glb-to-usdz' .

##

    docker run -it --name glbtousdz 'glb-to-usdz'

##

    docker cp glbtousdz:/usr/app/input-file.usdz ./output-file.usdz
