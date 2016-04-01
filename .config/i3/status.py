from i3pystatus import Status
from i3pystatus.updates.pacman import Pacman

status = Status(standalone=True)

status.register(
    "clock",
    format="%b %-d %k:%M")

status.register(
    "battery",
    battery_ident="BAT0",
    format="⚡0 {status} {percentage:.2f}% [{remaining:%E%hh:%Mm}]",
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "",
        "CHR": "",
        "FULL": "",
    })

status.register(
    "battery",
    battery_ident="BAT1",
    format="⚡1 {status} {percentage:.2f}% [{remaining:%E%hh:%Mm}]",
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "",
        "CHR": "",
        "FULL": "",
    })

status.register(
    "temp",
    format="{temp:.0f}°C",)

#status.register(
#    "cpu_freq",
#    format=" {avgg}GHz")

status.register(
    "cpu_usage",
    format=" {usage:02}%")

status.register(
    "disk",
    path="/home",
    format=" {percentage_used}%")

status.register(
    "disk",
    path="/",
    format=" {percentage_used}%")

status.register(
    "mem",
    format=" {percent_used_mem}%")

status.register(
    "network",
    format_up="{essid}  {quality}%",
    interface="wlp3s0")

status.register(
    "updates",
    format=" {count}",
    backends=[Pacman()])
    
status.run()
