# Dockerfile for P2Pool-Dash Server
# https://www.dash.org/

FROM alpine
MAINTAINER TheLazieR <thelazier@gmail.com>
LABEL description="Dockerized P2Pool-Dash"

RUN apk --no-cache add \
  git \
  perl \
  python \
  python-dev \
  py-twisted \
  gcc \
  g++

WORKDIR /p2pool
ENV P2POOL_DASH_HOME /p2pool/p2pool-dash
ENV P2POOL_DASH_REPO https://github.com/thelazier/p2pool-dash

RUN git clone -b master $P2POOL_DASH_REPO $P2POOL_DASH_HOME

WORKDIR $P2POOL_DASH_HOME
RUN git submodule init \
  && git submodule update \
  && cd x11-hash && python setup.py install && cd ..

# Remove to reduce size
RUN apk -v del \
  git \
  python-dev \
  perl \
  gcc \
  g++

EXPOSE 7903 8999 17903 18999

ENV DASH_RPCUSER dashrpc
ENV DASH_RPCPASSWORD 4C3NET7icz9zNE3CY1X7eSVrtpnSb6KcjEgMJW3armRV
ENV DASH_RPCHOST 192.168.99.1
ENV DASH_RPCPORT 9998
ENV DASH_P2PPORT 9999
ENV DASH_FEE 0
ENV DASH_DONATION 0
ENV DASH_TESTNET 0

# Default arguments, can be overriden
WORKDIR $P2POOL_DASH_HOME
CMD python run_p2pool.py \
  --testnet $DASH_TESTNET \
  --give-author $DASH_DONATION \
  -f $DASH_FEE \
  --no-bugreport \
  --disable-advertise \
  --dashd-address $DASH_RPCHOST \
  --dashd-rpc-port $DASH_RPCPORT \
  --dashd-p2p-port $DASH_P2PPORT \
  $DASH_RPCUSER $DASH_RPCPASSWORD

# End.
