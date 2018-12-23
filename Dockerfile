FROM cm2network/steamcmd

# app might need to be 240?
RUN mkdir /home/steam/css-dedicated && \
	./home/steam/steamcmd/steamcmd.sh +login anonymous \
	+force_install_dir /home/steam/css-dedicated \
	+app_update 232330 validate \
	+quit

# Create update script
RUN curl https://raw.githubusercontent.com/Laynezilla/docker-css-server/master/css-update.txt -o /home/steam/css-dedicated/css_update.txt

# Pull cfg folder from remote location
#RUN cd /home/steam/css-dedicated/cstrike && \ 
#	curl https://cm2.network/csgo/cfg.tar.gz -o cfg.tar.gz && \
#	tar -xf cfg.tar.gz && \
#	rm cfg.tar.gz

#ENV SRCDS_FPSMAX=300 SRCDS_TICKRATE=128 SRCDS_PORT=27015 SRCDS_TV_PORT=27020 SRCDS_MAXPLAYERS=14 SRCDS_TOKEN=0 SRCDS_RCONPW="changeme" SRCDS_PW="changeme"

#VOLUME /home/steam/css-dedicated

# Set Entrypoint; Technically 2 steps: 1. Update server, 2. Start server
#ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/css-dedicated +app_update 232330 +quit && \
#	./home/steam/css-dedicated/srcds_run -game cstrike -console -autoupdate -steam_dir /home/steam/steamcmd/ -steamcmd_script /home/steam/css-dedicated/csgo_update.txt -usercon +fps_max $SRCDS_FPSMAX -tickrate $SRCDS_TICKRATE -port $SRCDS_PORT -tv_port $SRCDS_TV_PORT -maxplayers_override $SRCDS_MAXPLAYERS +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $SRCDS_TOKEN +rcon_password $SRCDS_RCONPW +sv_password $SRCDS_PW +sv_region $SRCDS_REGION

#EXPOSE 27015 27020 27005 51840
