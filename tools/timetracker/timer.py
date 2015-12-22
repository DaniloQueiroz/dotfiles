#!/usr/bin/env python2
from datetime import datetime, timedelta
import gtk
import appindicator
from appindicator import Indicator

INSTALL_DIR = "/home/danilo/tools/timetracker"
TIMEOUT = 5


class TimeTrackerIndicator:
    TIMER_MSG = "Timer: %s"
    TOTAL_MSG = "Total timer: %s"

    def __init__(self):
        self.ind = Indicator("timetracker-indicator", "timetracker",
                             appindicator.CATEGORY_APPLICATION_STATUS,
                             INSTALL_DIR)
        self.ind.set_attention_icon("pause")
        self.ind.set_icon("timer")
        self.ind.set_status(appindicator.STATUS_ATTENTION)
        self.ind.set_menu(self.menu_setup())
        self.timer = timedelta(seconds=0)
        self.total_timer = timedelta(seconds=0)
        self.start_time = None

    def menu_setup(self):
        menu = gtk.Menu()
        # Commands
        button = gtk.MenuItem("Start/Stop Timer")
        button.connect("activate", self.toggle_timer)
        button.show()
        menu.append(button)
        button = gtk.MenuItem("Pause/Resume Timer")
        button.connect("activate", self.toggle_timer)
        button.show()
        menu.append(button)
        sep = gtk.SeparatorMenuItem()
        sep.show()
        menu.append(sep)
        button = gtk.MenuItem("Reset Timers")
        button.connect("activate", self.reset_timers)
        button.show()
        menu.append(button)
        # Timers
        sep = gtk.SeparatorMenuItem()
        sep.show()
        menu.append(sep)
        self.timer_label = gtk.MenuItem()
        self.timer_label.show()
        menu.append(self.timer_label)
        self.total_timer_label = gtk.MenuItem()
        self.total_timer_label.show()
        menu.append(self.total_timer_label)
        return menu

    def toggle_timer(self, widget):
        if self.start_time:
            self.ind.set_status(appindicator.STATUS_ATTENTION)
            self.start_time = None
            if widget.get_label().startswith("Start/Stop"):
                self.timer = timedelta(seconds=0)
        else:
            self.start_time = datetime.now()
            self.ind.set_status(appindicator.STATUS_ACTIVE)

    def reset_timers(self, widget):
        if self.start_time:
            self.toggle_timer(widget)
        self.timer = self.total_timer = timedelta(0)

    def update_counters(self):
        if self.start_time:
            now = datetime.now()
            delta = now - self.start_time
            self.start_time = now
            self.timer = self.timer + delta
            self.total_timer = self.total_timer + delta
        self.update_timer_label()
        self.update_total_timer_label()
        gtk.timeout_add(TIMEOUT * 1000, self.update_counters)

    def update_timer_label(self):
        self.timer_label.set_label(
            TimeTrackerIndicator.TIMER_MSG % format_delta(self.timer))

    def update_total_timer_label(self):
        self.total_timer_label.set_label(
            TimeTrackerIndicator.TOTAL_MSG % format_delta(self.total_timer))


def format_delta(td):
    s = td.seconds
    return '{:02}:{:02}:{:02}'.format(s // 3600, s % 3600 // 60, s % 60)


if __name__ == '__main__':
    indicator = TimeTrackerIndicator()
    gtk.timeout_add(1000, indicator.update_counters)
    gtk.main()
