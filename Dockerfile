FROM python:3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    && apt-get -y install git locales gcc g++ sudo procps lsb-release \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=prospector-dev
RUN useradd -m $USERNAME

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
RUN chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/prospector-dev

ENV PATH="$HOME/.local/bin:$PATH"
RUN mkdir -p prospector
RUN chown -Rf 1000:1000 prospector
COPY --chown=1000:1000 . prospector/

WORKDIR /home/prospector-dev/prospector

RUN python3 -m pip install --user -e .[with_everything]

ENV DEBIAN_FRONTEND=dialog
