#!/usr/bin/env python2
from datetime import datetime, timedelta
import gtk
import appindicator
from appindicator import Indicator

INSTALL_DIR = "/home/danilo/tools/timetracker"
TIMEOUT = 2


class TimeTrackerIndicator:
    PAUSE_MSG = "Pause: %s"
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
        self.total_timer = timedelta(hours=0)
        self.start_time = None
        self.pause_time = None
        self.pause_timer = timedelta(seconds=0)

    def menu_setup(self):
        menu = gtk.Menu()
        # Commands
        button = gtk.MenuItem("Start/Stop Timer")
        button.connect("activate", self.toggle_timer)
        button.show()
        menu.append(button)
        button = gtk.MenuItem("+/- Timer")
        button.show()
        menu.append(button)
        submenu = gtk.Menu()
        button.set_submenu(submenu)
        button = gtk.MenuItem("Reset Timers")
        button.connect("activate", self.reset_timers)
        button.show()
        menu.append(button)
        # submenu
        button = gtk.MenuItem("- 5 min")
        button.connect("activate", self.tick_timers, timedelta(minutes=-5))
        button.show()
        submenu.append(button)
        button = gtk.MenuItem("- 10 min")
        button.connect("activate", self.tick_timers, timedelta(minutes=-10))
        button.show()
        submenu.append(button)
        sep = gtk.SeparatorMenuItem()
        sep.show()
        submenu.append(sep)
        button = gtk.MenuItem("+ 5 min")
        button.connect("activate", self.tick_timers, timedelta(minutes=5))
        button.show()
        submenu.append(button)
        button = gtk.MenuItem("+ 10 min")
        button.connect("activate", self.tick_timers, timedelta(minutes=10))
        button.show()
        submenu.append(button)
        button = gtk.MenuItem("+ 1 hour")
        button.connect("activate", self.tick_timers, timedelta(minutes=60))
        button.show()
        submenu.append(button)
        # Timers
        sep = gtk.SeparatorMenuItem()
        sep.show()
        menu.append(sep)
        self.pause_label = gtk.MenuItem()
        self.pause_label.connect("activate", self.toggle_timer)
        menu.append(self.pause_label)
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
                self.pause_timer = timedelta(seconds=0)
                self.pause_time = datetime.now()
        else:
            self.pause_time = None
            self.start_time = datetime.now()
            self.ind.set_status(appindicator.STATUS_ACTIVE)

    def reset_timers(self, widget):
        if self.start_time:
            self.toggle_timer(widget)
        self.pause_time = None
        self.timer = self.total_timer = self.pause_timer = timedelta(0)

    def update_counters(self):
        # compute timers
        if self.start_time:
            self.compute_timers()
        if self.pause_time:
            self.compute_pause_timer()
        # update labels
        self.update_pause_label()
        self.update_total_timer_label()
        self.update_timer_label()
        # repeat
        gtk.timeout_add(TIMEOUT * 1000, self.update_counters)

    def compute_timers(self):
        now = datetime.now()
        delta = now - self.start_time
        self.start_time = now
        self.tick_timers(delta=delta)

    def tick_timers(self, widget=None, delta=timedelta(seconds=0)):
        self.timer = self.timer + delta
        self.total_timer = self.total_timer + delta

    def compute_pause_timer(self):
        now = datetime.now()
        delta = now - self.pause_time
        self.pause_time = now
        self.pause_timer = self.pause_timer + delta

    def update_pause_label(self):
        if self.pause_time:
            self.pause_label.set_label(
                TimeTrackerIndicator.PAUSE_MSG % format_delta(self.pause_timer))
            self.pause_label.set_tooltip_text("Click to resume timer")
            self.pause_label.show()
        elif self.start_time:
            self.pause_label.set_label('Pause')
            self.pause_label.set_tooltip_text("Click to pause")
            self.pause_label.show()
        else:
            self.pause_label.hide()

    def update_timer_label(self):
        self.timer_label.set_label(
            TimeTrackerIndicator.TIMER_MSG % format_delta(self.timer))

    def update_total_timer_label(self):
        self.total_timer_label.set_label(
            TimeTrackerIndicator.TOTAL_MSG % format_delta(self.total_timer))


def format_delta(td):
    s = td.seconds
    hours = s // 3600
    hours = hours + td.days * 24
    return '{:02}:{:02}:{:02}'.format(hours, s % 3600 // 60, s % 60)


if __name__ == '__main__':
    indicator = TimeTrackerIndicator()
    gtk.timeout_add(1000, indicator.update_counters)
    gtk.main()
