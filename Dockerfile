FROM cm2network/steamcmd

# Switch back to root to install additional packages
USER root

RUN apt-get update -y && \
	apt-get install -y wget unzip nano sudo lib32tinfo5 locales && \
	rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Use steam user for rest of install
USER steam

# Install CS:S dedicated server
RUN mkdir /home/steam/css-dedicated && \
	./home/steam/steamcmd/steamcmd.sh +login anonymous \
	+force_install_dir /home/steam/css-dedicated \
	+app_update 232330 validate \
	+quit

# Create update script
RUN curl https://raw.githubusercontent.com/Laynezilla/docker-css-server/master/css-update.txt -o /home/steam/css-dedicated/css_update.txt
	
# Fix error
RUN mkdir /home/steam/.steam/sdk32 && \
	ln -s /home/steam/css-dedicated/bin/steamclient.so /home/steam/.steam/sdk32/steamclient.so

# Install plugins
RUN curl https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git968-linux.tar.gz -o /home/steam/mmsource.tar.gz && \
	tar -xzvf /home/steam/mmsource.tar.gz -C /home/steam/css-dedicated/cstrike && \
	rm /home/steam/mmsource.tar.gz && \
	curl https://sm.alliedmods.net/smdrop/1.9/sourcemod-1.9.0-git6269-linux.tar.gz -o /home/steam/sourcemod.tar.gz && \
	tar -xzvf /home/steam/sourcemod.tar.gz -C /home/steam/css-dedicated/cstrike && \
	rm /home/steam/sourcemod.tar.gz && \
	wget -O /home/steam/sm_noblock.zip "https://forums.alliedmods.net/attachment.php?attachmentid=74064&d=1285431495" && \
	unzip -o /home/steam/sm_noblock.zip -d /home/steam/css-dedicated/cstrike && \
	rm /home/steam/sm_noblock.zip && \
	wget -O /home/steam/sm_teamchange.zip "https://forums.alliedmods.net/attachment.php?attachmentid=110542&d=1349628533" && \
	unzip -o /home/steam/sm_teamchange.zip -d /home/steam/css-dedicated/cstrike && \
	rm /home/steam/sm_teamchange.zip 
#	&& wget -O /home/steam/sm_ggdm.zip "https://forums.alliedmods.net/attachment.php?attachmentid=108943&d=1346584450" && \
#	unzip -o /home/steam/sm_ggdm.zip -d /home/steam/css-dedicated/cstrike && \
#	rm /home/steam/sm_ggdm.zip && \
#	wget -O /home/steam/sm_gungame.zip "https://forums.alliedmods.net/attachment.php?s=716ef65609b491b4a34670e767887027&attachmentid=133712&d=1400696532" && \
#	unzip -o /home/steam/sm_gungame.zip -d /home/steam/css-dedicated/cstrike && \
#	rm /home/steam/sm_gungame.zip && \
#	mv /home/steam/css-dedicated/cstrike/addons/sourcemod/plugins/gungame.smx /home/steam/css-dedicated/cstrike/addons/sourcemod/plugins/disabled/ && \
#	mv /home/steam/css-dedicated/cstrike/addons/sourcemod/plugins/disabled/gungame_sdkhooks.smx /home/steam/css-dedicated/cstrike/addons/sourcemod/plugins/

EXPOSE 27015
