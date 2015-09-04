# Dockerfile for Dashd
# https://www.dashpay.io/

FROM debian:jessie
MAINTAINER TheLazieR <thelazier@gmail.com>
LABEL description="Dockerized P2Pool-Dash"

RUN apt-get update \
  && apt-get install -y binutils curl git python-zope.interface python-twisted python-twisted-web python-dev gcc g++

ENV HOME /p2pool
ENV USER p2pool
ENV GROUP p2pool
RUN /usr/sbin/useradd -s /bin/bash -m -d $HOME $USER

ENV P2POOL_DASH_HOME /p2pool/p2pool-dash
ENV P2POOL_DASH_REPO https://github.com/dashpay/p2pool-dash

WORKDIR $HOME
RUN git clone -b master $P2POOL_DASH_REPO $P2POOL_DASH_HOME

WORKDIR $P2POOL_DASH_HOME
RUN git submodule init \
  && git submodule update

WORKDIR $P2POOL_DASH_HOME/x11-hash
RUN python setup.py install

WORKDIR $P2POOL_DASH_HOME/dash-subsidy
RUN python setup.py install

RUN chown $USER:$GROUP -R $HOME
USER p2pool
VOLUME ["/p2pool"]
EXPOSE 7903 8999

ENV DASH_RPCUSER dashrpc
ENV DASH_RPCPASSWORD 4C3NET7icz9zNE3CY1X7eSVrtpnSb6KcjEgMJW3armRV
ENV DASH_RPCHOST 192.168.99.1
ENV DASH_RPCPORT 9998
ENV DASH_P2PPORT 9999
ENV DASH_FEE 0
ENV DASH_DONATION 0

# Default arguments, can be overriden
WORKDIR $P2POOL_DASH_HOME
CMD python run_p2pool.py \
  --give-author $DASH_DONATION \
  -f $DASH_FEE \
  --no-bugreport --disable-advertise \
  --dashd-address $DASH_RPCHOST \
  --dashd-rpc-port $DASH_RPCPORT \
  --dashd-p2p-port $DASH_P2PPORT \
  $DASH_RPCUSER $DASH_RPCPASSWORD

# End.
