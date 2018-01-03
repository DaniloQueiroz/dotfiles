from i3pystatus import Status
from i3pystatus.updates import pacman, yaourt

status = Status(standalone=True)

status.register(
    "clock",
    format="%b %-d %k:%M")

status.register(
    "battery",
    full_color="#FFFFFF",
    charging_color="#00ff00",
    critical_color="#ff0000",
    battery_ident="ALL",
    format="{percentage:.2f}% [{remaining:%E%hh:%Mm}]",
    alert=True,
    alert_percentage=7,
    status={
        "DIS": "[-]",
        "CHR": "[+]",
        "FULL": "[=]",
    })


status.register(
    "mem",
    color="#FFFFFF",
    warn_color="#FFFFFF",
    format="mem {percent_used_mem}%")

status.register(
    "cpu_usage",
    format="cpu {usage:02}%")

# status.register(
#     "disk",
#     path="/home",
#     format=" {percentage_used}%")

# status.register(
#     "disk",
#     path="/",
#     format=" {percentage_used}%")

status.register(
    "updates",
    color="#FFFFFF",
    format="!{count}",
    backends=[pacman.Pacman(), yaourt.Yaourt()])

status.run()
