# LizardFS Charms

Juju charms for LizardFS.

Documentation has not been written yet. We do have a [tutorial video](https://discourse.jujucharms.com/t/deploying-lizardfs-with-juju-video-tutorial/2800?u=zicklag) showing how to deploy. Otherwise, this should work:

    juju deploy ~katharostech/lizardfs-master -n 2
    juju deploy ~katharostech/lizardfs-chunkserver -n 3
    juju deploy ~katharostech/lizardfs-gui

    juju relate lizardfs-master lizardfs-chunkserver
    juju relate lizardfs-master lizardfs-gui

    juju expose lizardfs-gui
