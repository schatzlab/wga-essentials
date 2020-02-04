## Rebuild with: docker build github.com/schatzlab/wga-essentials

FROM ubuntu:16.04

########################################
# ROOT MODE
########################################

###### SETUP APT-FAST #####################
RUN apt-get update && apt-get install -y aria2 git \
    && git clone https://github.com/ilikenwf/apt-fast /tmp/apt-fast \
    && cp /tmp/apt-fast/apt-fast /usr/bin \
    && chmod +x /usr/bin/apt-fast \
    && cp /tmp/apt-fast/apt-fast.conf /etc

###### SETUP CURL #########################
RUN apt-fast update && apt-fast install -y curl

###### SETUP FIXUID #######################
RUN addgroup --gid 1000 docker && \
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker

RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.1/fixuid-0.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

ENTRYPOINT ["fixuid"]

###### SETUP ###############################
RUN apt-fast update && apt-fast install -y \
        build-essential \
        git \
        r-base \
        time \
        zlib1g-dev

RUN cd /tmp \
    && curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda
ENV PATH=/opt/conda/bin:$PATH
# RUN conda install -y conda=4.4.7
RUN conda config --add channels defaults \
    && conda config --add channels conda-forge \
    && conda config --add channels bioconda

RUN conda install fastqc jellyfish spades mummer samtools freebayes bcftools bowtie2
