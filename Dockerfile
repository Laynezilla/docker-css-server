FROM cm2network/steamcmd

ENV MAP="cs_italy"
ENV MAX_PLAYERS="12"
ENV LANG="en_US.utf8"

# Switch back to root to install additional packages
USER root

RUN apt-get update -y && \
	apt-get install -y wget unzip nano sudo lib32tinfo5 locales locales-all && \
	rm -rf /var/lib/apt/lists/* && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Use steam user for rest of install
USER steam

WORKDIR /home/steam

# Install CS:S dedicated server
RUN mkdir ./css-dedicated && \
	./steamcmd/steamcmd.sh +login anonymous \
	+force_install_dir ./css-dedicated \
	+app_update 232330 validate \
	+quit
	
# Fix error
RUN mkdir ./.steam/sdk32 && \
	ln -s ./css-dedicated/bin/steamclient.so ./.steam/sdk32/steamclient.so

# Install plugins
RUN curl https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git968-linux.tar.gz -o ./mmsource.tar.gz && \
	tar -xzvf ./mmsource.tar.gz -C ./css-dedicated/cstrike && \
	rm ./mmsource.tar.gz && \
	curl https://sm.alliedmods.net/smdrop/1.9/sourcemod-1.9.0-git6269-linux.tar.gz -o ./sourcemod.tar.gz && \
	tar -xzvf ./sourcemod.tar.gz -C ./css-dedicated/cstrike && \
	rm ./sourcemod.tar.gz && \
	wget -O ./sm_noblock.zip "https://forums.alliedmods.net/attachment.php?attachmentid=74064&d=1285431495" && \
	unzip -o ./sm_noblock.zip -d ./css-dedicated/cstrike && \
	rm ./sm_noblock.zip && \
	wget -O ./sm_teamchange.zip "https://forums.alliedmods.net/attachment.php?attachmentid=110542&d=1349628533" && \
	unzip -o ./sm_teamchange.zip -d ./css-dedicated/cstrike && \
	rm ./sm_teamchange.zip && /
	wget -O ./bootstart.sh "https://raw.githubusercontent.com/Laynezilla/docker-css-server/master/bootstart.sh" && \
	chmod +x ./bootstart.sh

# https://developer.valvesoftware.com/wiki/Source_Dedicated_Server
EXPOSE 27015

# Start server with basic settings. Add arguments as needed
CMD ["./bootstart.sh"]
