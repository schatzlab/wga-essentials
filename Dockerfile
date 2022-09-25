## Rebuild with: 
##   docker build github.com/mschatz/wga-essentials -t mschatz/wga-essentials
##   docker run -it -d -v ~:/root/source_code mschatz/wga-essentials bin/bash
##   On apple/arm run: docker run --platform=linux/amd64 -it -d -v ~:/root/source_code mschatz/wga-essentials bin/bash
##   Get long hex string -- extract first 6 characters, e.g. 92b74b
##   docker exec -it 92b74b bin/bash
##   check that it works
##   get docker id:
##   docker ps
##   docker login
##    username: mschatz
##   docker commit 92b74bf1d952 mschatz/wga-essentials

FROM --platform=linux/amd64 ubuntu

ENV DEBIAN_FRONTEND=noninteractive

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
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

#USER docker:docker
ENTRYPOINT ["fixuid"]

# ###### SETUP ############################### Something in here breaks on apple arm
# RUN apt-fast update && apt-fast install -y \
#        build-essential \
#        git \
#        r-base \
#        time \
#        zlib1g-dev

RUN cd /tmp \
    && curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda
ENV PATH=/opt/conda/bin:$PATH

RUN conda config --add channels defaults \
    && conda config --add channels conda-forge \
    && conda config --add channels bioconda

RUN conda install -y fastqc jellyfish spades mummer samtools freebayes bcftools bowtie2
