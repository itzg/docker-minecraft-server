# Running on RaspberryPi

To run this image on a RaspberryPi 3 B+, 4, or newer, use any of the image tags [list in the Java version section](../versions/java.md) that specify `armv7` for the architecture, which includes `itzg/minecraft-server:latest`.

!!! note
   
   You may need to lower the memory allocation, such as `-e MEMORY=750m`

!!! note

    If experiencing issues such as "sleep: cannot read realtime clock: Operation not permitted", ensure `libseccomp` is up to date on your host. In some cases adding `:Z` flag to the `/data` mount may be needed, [but use cautiously](https://docs.docker.com/storage/bind-mounts/#configure-the-selinux-label).
