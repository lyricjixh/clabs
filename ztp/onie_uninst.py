### modification python###
##os10_uninstall.py 
#!/usr/bin/python
import os
import os10.image
import time

def os10_onie_uninst():
    os10.image.set_onie_mode('uninstall')
    print 'Success setting ONIE boot mode to OS uninstall'
    print '########################################'
    print 'System will wait 15 sec before rebooting'
    print '########################################'

    time.sleep(15)
    print '########################################'
    print 'System is now rebooting...'
    print '########################################'
    time.sleep(5)
    os.system('systemctl reboot -f')

  
if __name__ == '__main__':
    os10_onie_uninst()
