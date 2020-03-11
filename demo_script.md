# Prerequisites

This script assumes a vanilla installation of Ubuntu 16.04 LTS, perhaps in an AWS EC2 Instance.

## Install software

As the `ubuntu` linux user:
```
# get and configure docker and docker compose
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    unzip
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y git docker-ce
sudo usermod -aG docker ${USER}
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

```
# exit and reconnect
id -nG # check that docker appears in group listing for ubuntu linux user
```

```
# clone the irods_demo repository
git clone https://github.com/irods/irods_demo
```

```
# create local alice user
sudo useradd -m alice
```

## Confirm necessary ports are open

- 80
- 1247-1248
- 2049
- 5432
- 5601
- 5672
- 8080
- 9200
- 15672
- 20000-20199

# Stand up the `irods_demo`

```
ubuntu $ cd irods_demo
ubuntu $ pwd
/home/ubuntu/irods_demo
# expect ~12 minutes on first run
ubuntu $ docker-compose up
```

# Pre-Demo Configuration

## Configure Kibana Dashboard
```
# The following steps are from https://slides.com/irods/ugm2019-policy-training-getting-started#/10
- Download https://raw.githubusercontent.com/irods/irods_training/master/advanced/example_kibana_dashboard.json to your local computer (not the VM).
- Open Local Browser to http://hostcomputer:5601
- Click on Management (left pane) -> Saved Objects and click Import.
- Select the downloaded example_kibana_dashboard.json file.  Confirm the changes.
- Click on the Dashboard (left pane) -> and then iRODS Dashboard.
- Click on the Auto Refresh button at the top and change the refresh period to 30 seconds.
- Click on the clock icon (Last 15 minutes) at the top of the screen and select "today". 
```

## Mount NFSRODS

```
ubuntu $ sudo apt-get install -y nfs-common
ubuntu $ sudo mkdir /the_nfsrods_mountpoint
ubuntu $ sudo mount -o sec=sys,port=2049 localhost:/ /the_nfsrods_mountpoint
```

## Connect to Davrods via WebDAV as alice

On local machine, connect to `http://hostcomputer`.

- MacOSX Finder - "Go->Connect to Server", or "Command-K", or "⌘-K"
- Windows Explorer - "Computer->Add a network location"
- Kubuntu Linux - Dolphin - Right-click on "Places->Add entry...->Location: webdav://hostcomputer"

## Connect via NFSRODS as alice

In a separate terminal window:
```
ubuntu $ sudo su - alice
alice $ cd /the_nfsrods_mountpoint
alice $ cd home
alice $ cd alice
```

## Connect via iCommands as rods

In a separate terminal window:
```
ubuntu $ docker exec -it irods_demo_irods-client_1 /bin/bash
root@client:/# ienv
irods_version - 4.2.7
irods_session_environment_file - /root/.irods/irods_environment.json.86
irods_environment_file - /root/.irods/irods_environment.json
irods_user_name - rods
irods_zone_name - tempZone
irods_port - 1247
irods_host - icat.example.org
root@client:/# ils
/tempZone/home/rods:
  C- /tempZone/home/rods/landing_zone_collection
```

# The Demo

Copy some images to the landing zone on the Docker hostcomputer.

The automated ingest tool will register them into the iRODS Catalog.
```
ubuntu $ curl -L -O https://github.com/irods/irods_training/raw/master/beginner/training_jpgs.zip
ubuntu $ unzip training_jpgs.zip
ubuntu $ sudo chmod 777 /tmp/landing_zone/
ubuntu $ cp -r training_jpgs /tmp/landing_zone/
ubuntu $ curl -L -O https://github.com/irods/irods_training/raw/master/stickers.jpg
ubuntu $ cp stickers.jpg /tmp/landing_zone/stickers-from-ingest.jpg
```

Put an image into iRODS from the client container via iCommands as rods.
```
root@client:~# curl -L -O https://github.com/irods/irods_training/raw/master/stickers.jpg
root@client:~# iput stickers.jpg stickers-from-iput.jpg
```

Copy an image into iRODS via NFSRODS as alice.
```
alice $ curl -L -O curl -L -O https://github.com/irods/irods_training/raw/master/stickers.jpg
alice $ cp stickers.jpg /the_nfsrods_mountpoint/home/alice/stickers-from-nfsrods.jpg
```

Copy an image into iRODS via WebDAV (Davrods) as alice.
```
# Drag and drop the stickers.jpg file from your Desktop
```

Open Metalnx in a Web Browser as alice and then as rods.
```
# Open Browser to http://hostcomputer:8080/metalnx
# inspect metadata on different image files...
  # stickers file from ingest tool has AVUs
# search for images via metalnx
```

Edit a file via NFSRODS as alice.
```
alice $ echo "hello" > /the_nfsrods_mountpoint/home/alice/hello.txt
alice $ echo "how are you" >> /the_nfsrods_mountpoint/home/alice/hello.txt
```

Show the file has changed via WebDAV (Davrods).
```
# open via finder/desktop
```

Show metadata on storage resources from the client container via iCommands as rods.
```
root@client:~# imeta ls -R demoResc
root@client:~# imeta ls -R mid_tier
root@client:~# imeta ls -R arch_tier
```

Show recurring rule running in the delay queue.
```
root@client:~# iqstat
id     name
10024 {"rule-engine-operation":"irods_policy_storage_tiering","storage-tier-groups":["example_group"]} 
```

Show automated data movement.
```
# see current location of replicas
root@client:~# ils -L
# access an archived image
root@client:~# iget -f stickers.jpg
# see the restage job in the queue
root@client:~# iqstat
# show it has restaged
root@client:~# ils -L
# watch it age back out again
root@client:~# ils -L
```

Show Kibana audit dashboard.
```
# open browser to http://hostcomputer:5601
```
