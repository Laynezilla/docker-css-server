#!/bin/bash

# Require clients to download workshop resources
echo "resource.AddWorkshop("$WORKSHOP_COLLECTION")" > ./gmod/garrysmod/lua/autorun/server/workshop.lua;

# Update all content
./steamcmd/steamcmd.sh +login anonymous +force_install_dir ./css-dedicated +app_update 232330 +quit;

# Start server
./css-dedicated/srcds_run -game cstrike +maxplayers $MAX_PLAYERS +map $MAP +host_workshop_collection $WORKSHOP_COLLECTION -authkey $AUTH_KEY;
