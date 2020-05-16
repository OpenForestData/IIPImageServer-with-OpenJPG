FROM ubuntu:bionic

ENV HOME /root 

RUN apt-get update -y \
    && apt-get install -y build-essential wget \
    cmake make git apache2 libapache2-mod-fcgid openssl libssl-dev \
    autoconf libfcgi0ldbl libtool libjpeg-turbo8 libjpeg-turbo8-dev \
    libtiff5-dev libpng-dev libmemcached-dev memcached liblcms2-2 \
    liblcms2-dev libgomp1 libpthread-stubs0-dev liblzma5 liblzma-dev \
    libjbig-dev libjbig0 libz80ex1 libz80ex-dev pkg-config

WORKDIR /tmp/openjpeg
RUN git clone https://github.com/uclouvain/openjpeg.git ./
RUN git checkout tags/v2.3.1
RUN cmake . && make && make install

RUN export USE_OPENJPEG=1

RUN printf "include /etc/ld.so.conf.d/*.conf\ninclude /usr/local/lib\n" > /etc/ld.so.conf && ldconfig

WORKDIR /tmp/iip
RUN git clone https://github.com/ruven/iipsrv.git ./
RUN git checkout master
RUN chmod +x autogen.sh && sleep 2 && ./autogen.sh
RUN chmod +x configure && sleep 2 && ./configure --with-openjpeg=/tmp/openjpeg && sleep 2 && make && make install

RUN mkdir -p /var/www/localhost/fcgi-bin
RUN cp src/iipsrv.fcgi /var/www/localhost/fcgi-bin

COPY /001-iipsrv.conf /etc/apache2/sites-available/001-iipsrv.conf

RUN mkdir -p /var/www/localhost/images/ \
	&& chown -R www-data:www-data /var/www/

RUN apt-get install -y python2.7 build-essential python-dev python-setuptools libxml2-dev libxslt1-dev python-pip

WORKDIR /tmp/pythontools
RUN pip install bottle \
    && pip install pip --upgrade \
    && pip install python-magic \
    && pip install lxml \
    && pip install Pillow

WORKDIR /tmp
RUN wget --no-check-certificate https://pypi.python.org/packages/source/i/iiif-validator/iiif-validator-1.0.5.tar.gz \
	&& tar zxfv iiif-validator-1.0.5.tar.gz \
	&& rm iiif-validator-1.0.5.tar.gz

EXPOSE 80

RUN a2enmod fcgid
RUN a2enmod headers

RUN a2dissite 000-default.conf

RUN a2ensite 001-iipsrv.conf

RUN rm -rf /var/lib/apt/lists/*

CMD service apache2 start && tail -f /dev/null