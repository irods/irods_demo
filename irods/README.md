# Running the image on its own

If you want to run just the iRODS image on its own, you need to ensure that docker gives it enough memory, i.e.;

`sudo docker run --name irods -p 1248:1248 -p 1247:1247 --shm-size=512m <imagename>`

If you do not do this, then the process will crash when it is started for the second time, with a shared memory error in the RoseServerLog.


