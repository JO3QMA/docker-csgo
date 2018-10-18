#!/bin/bash
printenv
which xterm
#export TERM=xterm
function check_srcds_run () {
    echo "Check srcds_run File."
    if [ -f $SERVER_PATH/srcds_run ]; then
        echo "Found!"
    else
        echo "Not Found."
        echo "Download CS:GO server..."
        $STEAMCMD_PATH/steamcmd.sh \
            +login anonymous \
            +force_install_dir $SERVER_PATH \
            +app_update 740 validate \
            +quit
        echo "Done..."
        echo "Recheck srcds_run Files..."
        check_srcds_run
    fi
}

function update_csgo () {
    echo "Update CS:GO Server..."
    $STEAMCMD_PATH/steamcmd.sh \
        +login anonymous \
        +force_install_dir $SERVER_PATH \
        +app_update 740 \
        +quit
    echo "Done..."
}

function fix_srcds_run () {
    echo "Fix srcds_run files..."
    sed -i -e "s/#!\/bin\/sh/#!\/bin\/bash/" $SERVER_PATH/srcds_run
}
function copy_steamclient_so () {
    echo "Check steamclient.so File..."
    if [ -f /home/$USER/.steam/sdk32/steamclient.so ]; then
        echo "Found!"
    else
        echo "Not Found."
        echo "Copy form ${STEAMCMD_PATH} to /home/${USER}/.steam/sdk32/"
        mkdir -p /home/$USER/.steam/sdk32/
        cp $STEAMCMD_PATH/linux32/steamclient.so /home/$USER/.steam/sdk32/
        echo "Done..."
    fi
}

function copy_cfgs () {
    echo "Check autoexec.cfg File..."
    if [ -f $SERVER_PATH/csgo/cfg/autoexec.cfg ]; then
        echo "Found!"
    else
        echo "Not Found."
        echo "Copy cfg file..."
        cp $SCRIPT_PATH/cfg/autoexec.cfg $SERVER_PATH/csgo/cfg/
        cp $SCRIPT_PATH/cfg/server.cfg $SERVER_PATH/csgo/cfg/
        echo "Done!"
    fi
}
copy_steamclient_so
check_srcds_run
#update_csgo
copy_cfgs
fix_srcds_run
        cd $SERVER_PATH
        echo "Start CS:GO Server..."
        $SERVER_PATH/srcds_run \
            game csgo \
            -console \
            -usercon \
            -tickrate 128 \
            -port 27015 \
            +game_type 1 \
            +game_mode 2 \
            +mapgroup mg_allclassic \
            +map de_dust2 \
            -net_port_try 1 \
            -debug \
            -consolelog

<< COMMENT
else
    echo "Download CS:GO server files..."
    $STEAMCMD_PATH/steamcmd.sh \
      +login anonymous \
      +force_install_dir $SERVER_PATH \
      +app_update 740 validate \
      +quit
    echo "Fix srcds_run"
    sed -i -e "s/#!\/bin\/sh/#!\/bin\/bash/" $SERVER_PATH/srcds_run
    echo "Download MetaMod and SourceMod..."
    cd /srv/csgo_server/csgo
    # Download MetaMod
    curl -sqL "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git966-linux.tar.gz" | tar zxvf -
    wget -O ./addons/metamod.vdf "https://www.sourcemm.net/vdf?vdf_game=csgo"
    # Download SourceMod
    curl -sqL 'https://sm.alliedmods.net/smdrop/1.9/sourcemod-1.9.0-git6258-linux.tar.gz' | tar zxvf -
    echo "Completed!!"
    echo "Plz configure some files..."
fi
COMMENT