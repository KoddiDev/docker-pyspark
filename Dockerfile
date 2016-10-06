FROM ubuntu:latest
MAINTAINER Robert McIntosh <robert@koddi.com>

# Update base installation and install required packages for 
# python, java, numpy, scipy, and the pandas
RUN apt-get -y update
RUN apt-get install -y \
    gzip \
    wget \
    openjdk-8-jdk \
    python3.5 \
    python3-pip \
    unzip \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran 

RUN apt-get clean && \
    rm -rf /var/lib/apt-lists/

# Python packages required by PySpark, numpy, scipy, and the pandas
RUN pip3 install --upgrade pip && \
    pip3 install boto3 && \
    pip3 install configparser && \
    pip3 install kazoo && \
    pip3 install numpy && \
    pip3 install scipy && \
    pip3 install pandas && \
    pip3 install py4j && \
    pip3 install PyMySQL && \
    pip3 install scipy

# AWS Java and Hadoop SDK
RUN wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.1/hadoop-aws-2.7.1.jar && \
    mkdir /opt/jar && \
    mv /hadoop-aws-2.7.1.jar /opt/jar/

RUN wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.7/aws-java-sdk-1.11.7.jar && \
    mv /aws-java-sdk-1.11.7.jar /opt/jar/

# Download and setup the Spark
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.0-bin-hadoop2.7.tgz && \
    tar -zxvf spark-2.0.0-bin-hadoop2.7.tgz -C /opt && \
    mv /opt/spark* /opt/spark && \
    rm /spark-2.0.0-bin-hadoop2.7.tgz

ENV PYSPARK_PYTHON python3
ENV SPARK_CLASSPATH /opt/jar/*:/opt/spark/jars/*
ENV SPARK_HOME /opt/spark
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/spark/bin




