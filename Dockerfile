FROM espnet/espnet:gpu-latest

RUN apt-get update
RUN apt-get install sph2pipe
