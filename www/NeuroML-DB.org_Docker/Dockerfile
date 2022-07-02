# Start with Ubuntu
FROM ubuntu:18.04
RUN apt-get update

# Install ruby
RUN apt install -y rbenv
ENV PATH /root/.rbenv/shims:$PATH
RUN apt-get install -y libssl1.0-dev
RUN rbenv install 1.9.3-p551
RUN rbenv global 1.9.3-p551

# Install bundler
RUN gem install bundler -v '1.17.3'
ENV PATH $PATH:/root/.rbenv/versions/1.9.3-p551/lib/ruby/gems/1.9.1/gems/bundler-1.17.3/exe/

# Install apache
RUN apt-get install -y apache2
EXPOSE 80

# Install phusion passenger
# From: https://www.phusionpassenger.com/library/install/apache/install/oss/bionic/
RUN apt-get install -y dirmngr gnupg
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && apt-get install -y apt-transport-https ca-certificates \
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list' \
  && apt-get update \
  && apt-get install -y libapache2-mod-passenger
RUN apt-get install -y apache2-dev
RUN a2enmod passenger && apache2ctl restart
RUN mkdir /var/log/httpd/

# Install gems
RUN apt-get install -y libmysqlclient-dev
COPY Gemfile /var/www/NeuroML-DB.org/Gemfile
COPY Gemfile.lock /var/www/NeuroML-DB.org/Gemfile.lock
WORKDIR /var/www/NeuroML-DB.org
RUN bundle install
RUN gem install mysql2 -v 0.3.21

# Set permissions
RUN chmod a+rx /root/.rbenv/versions/1.9.3-p551/bin/ruby
RUN chmod a+rx /root/.rbenv/versions/1.9.3-p551/bin
RUN chmod a+rx /root/.rbenv/versions/1.9.3-p551
RUN chmod a+rx /root/.rbenv/versions
RUN chmod a+rx /root/.rbenv
RUN chmod a+rx /root

# Install python
RUN apt-get install -y nano iputils-ping wget curl mysql-client
RUN mkdir -p ~/miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm -rf ~/miniconda3/miniconda.sh
SHELL ["/bin/bash", "-c"]
RUN ~/miniconda3/bin/conda init bash
RUN source /root/.bashrc
RUN ~/miniconda3/bin/conda create -n p27 python=2.7
ENV PATH=/root/miniconda3/envs/p27/bin/:$PATH
RUN /root/miniconda3/envs/p27/bin/pip install nltk==3.4.5
RUN /root/miniconda3/envs/p27/bin/pip install mysql-python

# Install apache jena fuseki server
RUN apt-get install -y openjdk-11-jdk
RUN wget https://dlcdn.apache.org/jena/binaries/apache-jena-fuseki-4.5.0.zip -O /fuseki-archive.zip
RUN unzip /fuseki-archive.zip -d / && mv /apache-jena-fuseki-4.5.0 /fuseki && rm /fuseki-archive.zip
ENV FUSEKI_HOME=/fuseki
RUN chmod +x /fuseki/fuseki
RUN echo "FUSEKI_HOME=/fuseki" >> /etc/default/fuseki
RUN echo "FUSEKI_ARGS="\""--loc=/var/www/OntologyData /NeuroMLOntology"\""" >> /etc/default/fuseki

# Setup apache website
COPY neuroml-db.org.conf /etc/apache2/sites-enabled/neuroml-db.org.conf

# Script to run inside docker container when the container starts
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh # Run this each time container starts


