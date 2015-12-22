#!/usr/bin/env python2
import logging
import subprocess
import sys

import gtk
import appindicator
from appindicator import Indicator

INSTALL_DIR = "/home/danilo/tools/btsync"
log = logging.getLogger()
TIMEOUT = 5


class BtSyncIndicator:
    def __init__(self):
        self.ind = Indicator("btsync-indicator", "btsync",
                             appindicator.CATEGORY_APPLICATION_STATUS,
                             '%s/icons/' % INSTALL_DIR)
        self.ind.set_attention_icon("btsync-inactive")
        self.ind.set_icon("btsync-ok")
        self.ind.set_status(appindicator.STATUS_ATTENTION)
        self.btsync_running = False
        self.btsync = None
        self.ind.set_menu(self.menu_setup())
        log.info("BitTorrentSync Indicator is running!")

    def menu_setup(self):
        menu = gtk.Menu()
        sep1 = gtk.SeparatorMenuItem()
        sep1.show()
        menu.append(sep1)
        button = gtk.MenuItem("Start/Stop BitTorrent Sync")
        button.connect("activate", self.toggle_status)
        button.show()
        menu.append(button)
        sep2 = gtk.SeparatorMenuItem()
        sep2.show()
        menu.append(sep2)
        quit_item = gtk.MenuItem("Quit")
        quit_item.connect("activate", self.quit)
        quit_item.show()
        menu.append(quit_item)

        return menu

    def toggle_status(self, widget):
        self.stop_btsync() if self.btsync_running else self.start_btsync()

    def start_btsync(self):
        cmd = '%s/btsync' % INSTALL_DIR
        config_file = '%s/config.json' % INSTALL_DIR
        log_file = '%s/btsync.log' % INSTALL_DIR
        args = [cmd, '--config', config_file, '--log', log_file, '--nodaemon']
        log.info("Starting BitTorrentSync with command %s", ' '.join(args))
        self.btsync = subprocess.Popen(args)
        log.info("BitTorrentSync pid: %s", self.btsync.pid)

    def stop_btsync(self):
        if self.btsync_running and self.btsync:
            log.info("Stoping BitTorrentSync")
            self.btsync.terminate()
            self.btsync.wait()
            log.info("BtSync exit code: %s", self.btsync.returncode)
            self.btsync = None

    def update_status(self):
        result = subprocess.call("ps aux | grep 'btsync --config' | grep -v grep >/dev/null",
                                 shell=True)
        status = result == 0
        # log.info("Checking BtSync is running: %s", status)
        if status != self.btsync_running:
            msg = "RUNNING" if status else "NOT RUNNING"
            log.info("BitTorrentSync status changes now it's %s", msg)
        self.btsync_running = status
        gtk.timeout_add(TIMEOUT * 1000, self.update_status)
        self.toggle_icon()

    def toggle_icon(self):
        if self.btsync_running:
            self.ind.set_status(appindicator.STATUS_ACTIVE)
        else:
            self.ind.set_status(appindicator.STATUS_ATTENTION)

    def quit(self, widget):
        log.info("Exiting...")
        self.stop_btsync()
        sys.exit(0)


if __name__ == '__main__':
    logging.basicConfig(filename='/tmp/btsync_indicator.log', level=logging.INFO,
                        format='%(asctime)s:%(levelname)s:%(message)s')
    indicator = BtSyncIndicator()
    gtk.timeout_add(1000, indicator.update_status)
    gtk.main()
