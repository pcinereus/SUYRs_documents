FROM rocker/r-ver:4.3.3

# Install system dependencies
RUN apt-get update \
    # && apt-get install -y --no-install-recommends \
    && apt-get install -y \
    curl \
    gdebi-core \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    make \
    graphviz \
    unzip \
    fontconfig \
    build-essential \
    pkg-config \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libgif-dev \
    libwebp-dev \
    libheif-dev \
    wget \
    ghostscript \
    build-essential \
    ca-certificates \
    tree \
    pandoc && \
    rm -rf /var/lib/apt/lists/*

## Must set this environment variable to avoid issues with the magick package when trying to use it in R. The magick package relies on the ImageMagick library, which is installed in /usr/local/bin, but this directory is not in the default PATH. By adding it to the PATH, we ensure that the magick package can find the ImageMagick library and work properly.
ENV PATH="${PATH}:/root/bin"

## It seems it is necessary to install ImageMagick from source to get the latest version that is compatible with the magick R package. The version available in the apt repositories is too old and causes errors when trying to use the magick package.
RUN wget https://download.imagemagick.org/ImageMagick/download/ImageMagick.tar.gz
RUN tar xvzf ImageMagick.tar.gz
RUN cd ImageMagick-* && ./configure --with-security-policy=open && make -j$(nproc) && make install
RUN ldconfig /usr/local/lib
RUN magick -list policy
RUN ls /etc
# RUN sed -i 's/^.*policy.*coder.*none.*PDF.*//' /etc/ImageMagick-7/policy.xml
# RUN sed -i 's/^.*policy.*coder.*none.*PDF.*//' /usr/local/etc/ImageMagick-7/policy.xml
# RUN sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/' \
RUN sed -i 's/^.*policy.*coder.*none.*PDF.*//' \
    /usr/local/etc/ImageMagick-7/policy.xml
# RUN apt-get install imagemagick
# RUN ls /etc

# Install R packages
RUN R -e "options(repos = \
    list(CRAN = \"https://packagemanager.posit.co/cran/2024-01-10/\")); \
  install.packages(\"pak\"); \
"
RUN R -e "options(repos = \
    list(CRAN = \"https://packagemanager.posit.co/cran/2024-01-10/\")); \
  pak::pkg_install(c('rmarkdown', 'quarto', 'tidyverse', 'ggplot2', 'sf', 'dplyr')); \
  pak::pkg_install(c('stan-dev/cmdstanr')); \
"

# Install CmdStan
RUN R -e "cmdstanr::check_cmdstan_toolchain(fix = TRUE); \
  cmdstanr::install_cmdstan(cores = parallel::detectCores()); \
"

RUN R -e "options(repos = \
    list(CRAN = \"https://packagemanager.posit.co/cran/2024-01-10/\")); \
  pak::pkg_install(c('magick', 'pdftools', 'GGally', 'PBSmapping')); \
  pak::pkg_install(c('gmodels', 'mvtnorm', 'coda', 'gganimate', 'gridExtra')); \
  pak::pkg_install(c('ggfortify', 'DHARMa', 'glmmTMB', 'performance', 'see')); \
  pak::pkg_install(c('brms', 'knitr', 'simstudy', 'stars', 'gstat', 'patchwork')); \
  pak::pkg_install(c('remotes', 'inlabru', 'Hmisc', 'igraph', 'easystats')); \
  pak::pkg_install(c('gridGraphics', 'HDInterval', 'bayestestR', 'emmeans')); \
  pak::pkg_install(c('gert', 'usethis', 'mgcv', 'ggeffects', 'gratia', 'tree')); \
  pak::pkg_install(c('gbm', 'car', 'jmgirard/standist', 'tidybayes')); \
  pak::pkg_install(c('dagitty', 'ggdag')); \
  pak::pkg_install(c('plotrix', 'PBSmapping')); \

"

RUN R -e "install.packages('INLA',repos=c(getOption('repos'),INLA='https://inla.r-inla-download.org/R/stable'), dep=TRUE)"

RUN Rscript -e 'tinytex::install_tinytex()'
RUN Rscript -e 'tinytex::reinstall_tinytex(repository = "illinois")'
RUN Rscript -e 'tinytex::tlmgr_update(all = TRUE, self = TRUE)'
RUN Rscript -e 'tinytex::tlmgr_install("titlesec")'
RUN Rscript -e 'tinytex::tlmgr_install("forest")'
RUN Rscript -e 'tinytex::tlmgr_install("komo-script")'
RUN Rscript -e 'tinytex::tlmgr_install("caption")'
RUN Rscript -e 'tinytex::tlmgr_install("pgf")'
RUN Rscript -e 'tinytex::tlmgr_install("environ")'
RUN Rscript -e 'tinytex::tlmgr_install("tikzfill")'
RUN Rscript -e 'tinytex::tlmgr_install("tcolorbox")'
RUN Rscript -e 'tinytex::tlmgr_install("pdfcol")'
RUN Rscript -e 'tinytex::tlmgr_install("standalone")'
RUN Rscript -e 'tinytex::tlmgr_install("preview")'




# RUN tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet && \
#   tlmgr update --self && \
#   tlmgr update --all
# RUN tlmgr option repository http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/tlnet && \
#   tlmgr update --self && \
#   tlmgr update --all && \
#   tlmgr install \
#         titlesec \
#         forest \
#         koma-script \
#         caption \
#         pgf \
#         environ \
#         tikzfill \
#         tcolorbox \
#         pdfcol

ARG QUARTO_VERSION="1.6.40"
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

RUN R -e "options(repos = \
    list(CRAN = \"https://packagemanager.posit.co/cran/2021-02-10/\")); \
  pak::pkg_install(c('pander', 'mvabund')); \
"
# Install Docker
RUN apt-get update && apt-get install -y \
    docker.io \
    && rm -rf /var/lib/apt/lists/*


RUN R -e "options(repos = \
    list(CRAN = \"https://packagemanager.posit.co/cran/2024-04-11/\")); \
  pak::pkg_install(c('magick')); \
  pak::pkg_install(c('ggdag')); \

"



# RUN unzip -d architects_daughter/ resources/Architects_Daughter.zip
# COPY architects_daughter /usr/share/fonts/
# RUN unzip -d inconsolata/ resources/Inconsolata.zip

# COPY inconsolata /usr/share/fonts/
# COPY resources/Inconsolata_Nerd_Font_Regular.ttf /usr/share/fonts/

# RUN unzip -d noto_sans/ resources/Noto_Sans.zip
# COPY noto_sans /usr/share/fonts/

RUN mkdir -p /usr/share/fonts

COPY resources/Architects_Daughter.zip /tmp/Architects_Daughter.zip
RUN unzip /tmp/Architects_Daughter.zip -d /usr/share/fonts

COPY resources/Inconsolata_Nerd_Font_Regular.ttf /usr/share/fonts
# RUN unzip /tmp/Inconsolata.zip -d /usr/share/fonts

COPY resources/Inconsolata.zip /tmp/Inconsolata.zip
RUN mkdir -p /usr/share/fonts/Inconsolata && \
  unzip /tmp/Inconsolata.zip -d /usr/share/fonts/Inconsolata

COPY resources/Noto_Sans.zip /tmp/Noto-Sans.zip
RUN mkdir -p /usr/share/fonts/Noto-Sans &&\
  unzip /tmp/Noto-Sans.zip -d /usr/share/fonts/Noto-Sans

COPY resources/Ubuntu.zip /tmp/Ubuntu.zip
RUN mkdir -p /usr/share/fonts/ubuntu && \
  unzip /tmp/Ubuntu.zip -d /usr/share/fonts/ubuntu
RUN fc-cache -fv && fc-list

RUN git config --global user.name "pcinereus"
RUN git config --global user.email "i.obesulus@gmail.com"
RUN git config --global init.defaultBranch main


# Set work directory
WORKDIR /workspace
#
COPY Makefile /workspace
COPY tut/*.qmd /workspace/tut
COPY resources/*.* /workspace/resources
