# wga-essentials

## Whole Genome Assembly (WGA) essentials tools and packages.

Initial version from: https://github.com/srivathsapv/wga-essentials

This docker image contains essential packages and tools for whole genome assembly and alignment. The following are the packages
that are available in this docker image:

* fastqc
* jellyfish
* spades
* mummer
* samtools
* freebayes
* bcftools
* bowtie2

### Installation Guide

#### Docker

Follow the below links to install Docker on various operating systems

* [OS X](https://docs.docker.com/v1.10/mac/)
* [Linux](https://docs.docker.com/v1.10/linux/)
* [Windows](https://docs.docker.com/v1.10/windows/)

The below steps worked on MacBook Pro (OS X High Sierra)

#### Pull docker image

```
$ docker pull schatzlab/wga-essentials
```

#### Run the docker image

```
$ docker run -it -d -v <source_code_path>:/root/source_code schatzlab/wga-essentials bin/bash
```

**Note**: The `<source_code_path>` can be your working directory in your host machine (local machine). This enables the docker
container to access your local files (code and reads/reference genome files)

The above command will print a long hexadecimal string. Ex:

```
50c27954340f691c1e63655302a58349d48018b1610b8fe0092ba94a07e5914a
```

Take the first 6 characters of this string and execute

```
$ docker exec -it 50c279 bin/bash
```

This will take you to the bash of the docker container. To go inside the source code folder execute

```
# cd /root/source_code
```

#### Test the docker installation

Assume you have a `ref.fa` file in your `source_code` folder. Then run the following command

```
# samtools faidx ref.fa
```

If this command executes successfully, it means your setup process is complete.

**Acknowledgement**:

Many thanks to [phizaz/bioconda](https://hub.docker.com/r/phizaz/bioconda/) from where I took the base images for **python3**
and **miniconda**.
