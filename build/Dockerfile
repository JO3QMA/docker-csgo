FROM ubuntu:rolling

# Env
ENV USER csgo
ENV STEAMCMD_PATH /home/csgo/steamcmd
ENV SERVER_PATH /home/csgo/csgo_server
ENV SCRIPT_PATH /home/csgo/scripts

COPY ./files ${SCRIPT_PATH}

RUN set -x \
 && : "Package Update"\
 && apt-get update \
 && apt-get upgrade -y \
 && : "Install Requirements Package"\
 && apt-get install -y \
        locales \
        curl \
        lib32gcc1 \
        lib32stdc++6 \
        ca-certificates \
        net-tools \
        gdb \
 && : "Clean APT's Dust" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && : "Fix Locale for Multibyte Strings" \
 && locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN set -x \
 && : "Add User (${USER})" \ 
 && useradd ${USER} -m -s /bin/bash \
 && : "Make SteamCMD and Server Directory" \
 && mkdir ${SERVER_PATH} ${STEAMCMD_PATH} \
 && chown -R ${USER}:${USER} ${SCRIPT_PATH} ${SERVER_PATH} ${STEAMCMD_PATH} /home/${USER}

USER ${USER}
WORKDIR ${STEAMCMD_PATH}
RUN set -x \
 && ls -l ../ \
 && : "Download SteamCMD" \
 && chmod +x ${SCRIPT_PATH}/start.sh \
 && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - \
 && ./steamcmd.sh +login anonymous +quit 

#USER ${USER}
EXPOSE 27015
EXPOSE 27005
WORKDIR ${SCRIPT_PATH}
ENTRYPOINT  ./start.sh