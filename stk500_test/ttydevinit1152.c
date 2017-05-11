/* vim: set sw=8 ts=8 si et: */
/* Linux software to set the speed on the serial line 
* Written by Guido Socher 
* run this program like this:
* ttydevinit /dev/usb/tts/0 (for usb com1) and then use
* cat > /dev/usb/tts/0 to write or cat /dev/usb/tts/0 to read the answrers
*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>

int main(int argc, char *argv[])
{
        struct termios portset;
        char *device;
        int fd;

        if (argc != 2){
                printf("USAGE: ttydevinit1152 /dev/ttyUSB0\n");
                exit(0);
        }
        device=argv[1];

        /* Set up io port correctly, and open it... */
        fd = open(device, O_RDWR | O_NOCTTY | O_NDELAY);
        if (fd == -1) {
                fprintf(stderr, "ERROR: open for %s failed.\n",device);
                exit(1);
        }
        tcgetattr(fd, &portset);
        cfmakeraw(&portset);
        //cfsetospeed(&portset, B9600); /* speed */
        cfsetospeed(&portset, B115200); /* speed */
        //cfsetospeed(&portset, B19200); /* speed */
        tcsetattr(fd, TCSANOW, &portset);
        close(fd);
        return(0);
}
