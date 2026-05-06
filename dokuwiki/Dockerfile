# renovate: datasource=docker depName=php
ARG PHP_IMAGE_TAG=8-apache-bullseye@sha256:c22cbcbe8cc4f2bbf8cc4b390e2ec483b59ba0d90d907b2c78d26493da20c23d

FROM php:${PHP_IMAGE_TAG} AS mellon-build

RUN apt-get update -y --fix-missing && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        git \
        pkg-config \
        liblasso3 \
        liblasso3-dev \
        libcurl4-openssl-dev \
        automake \
        apache2-dev && \
    rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-tags depName=latchset/mod_auth_mellon
ARG MOD_AUTH_MELLON_VERSION=0.18.1

RUN cd /tmp \
    && git clone --branch v${MOD_AUTH_MELLON_VERSION} --depth 1 https://github.com/latchset/mod_auth_mellon.git \
    && cd mod_auth_mellon \
    && autoconf \
    && autoreconf \
    && ./configure \
    && make \
    && make install

FROM php:${PHP_IMAGE_TAG}

RUN a2enmod rewrite && \
    groupadd --gid 1111 dokuwiki && \
    useradd -u 1111 dokuwiki --gid 1111

RUN apt-get update -y --fix-missing && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends liblasso3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=mellon-build /usr/lib/apache2/modules/mod_auth_mellon.so /usr/lib/apache2/modules/mod_auth_mellon.so

RUN echo "LoadModule auth_mellon_module /usr/lib/apache2/modules/mod_auth_mellon.so" > /etc/apache2/mods-available/auth_mellon_module.load && \
    a2enmod auth_mellon_module authz_user authn_core

LABEL org.opencontainers.image.description="DokuWiki image with mod_auth_mellon support"

USER dokuwiki
