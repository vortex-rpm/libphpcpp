FROM alanfranz/fpm-within-docker:centos-7

ENV NAME "libphpcpp"
ENV VERSION "2.2.0"
ENV ITERATION "2.vortex.el7.centos"

RUN mkdir /pkg
WORKDIR /pkg

RUN yum install -y centos-release-scl-rh git epel-release http://vortex-rpm.org/el7/noarch/vortex-release-7-2.vortex.el7.centos.noarch.rpm
RUN yum install -y devtoolset-7 php72t-devel

ENV PATH /opt/rh/devtoolset-7/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN git clone https://github.com/CopernicaMarketingSoftware/PHP-CPP.git
WORKDIR /pkg/PHP-CPP
RUN git checkout v2.2.0
RUN make

RUN cp libphpcpp.so.2.2.0 /usr/lib64/libphpcpp.so.2.2.0 && ln -s /usr/lib64/libphpcpp.so.2.2.0 /usr/lib64/libphpcpp.so && ln -s /usr/lib64/libphpcpp.so.2.2.0 /usr/lib64/libphpcpp.so.2.2
RUN cp libphpcpp.a.2.2.0 /usr/lib64/libphpcpp.a.2.2.0 && ln -s /usr/lib64/libphpcpp.a.2.2.0 /usr/lib64/libphpcpp.a
RUN cp phpcpp.h /usr/include/phpcpp.h && mkdir -p /usr/include/phpcpp && cp -f include/*.h /usr/include/phpcpp

WORKDIR /pkg

RUN sh -c 'fpm -s dir -t rpm --rpm-autoreqprov --rpm-autoreq --rpm-autoprov --license "ASL 2.0" --vendor "Vortex RPM" -m "Vortex Maintainers <dev@vortex-rpm.org>" --url "http://vortex-rpm.org" -n ${NAME} -v ${VERSION} --iteration "${ITERATION}" /usr/lib64/libphpcpp.so* /usr/lib64/libphpcpp.a.2.2.0 /usr/lib64/libphpcpp.a /usr/include/phpcpp /usr/include/phpcpp.h'
