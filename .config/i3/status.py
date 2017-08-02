from i3pystatus import Status
from i3pystatus.updates import pacman, yaourt

status = Status(standalone=True)

#status.register(
#    "network",
#    format_up="{essid}  {quality}%",
#    format_down=" {interface}",
#    interface="wlp3s0",
#    dynamic_color=False,
#    on_leftclick=["connman-gtk"]
#)

status.register(
    "clock",
    format="%b %-d %k:%M")

status.register(
    "battery",
    full_color="#FFFFFF",
    charging_color="#00ff00",
    critical_color="#ff0000",
    battery_ident="ALL",
    format="⚡ {status} {percentage:.2f}% [{remaining:%E%hh:%Mm}]",
    alert=True,
    alert_percentage=7,
    status={
        "DIS": "",
        "CHR": "",
        "FULL": "",
    })

# status.register(
#     "battery",
#     full_color="#FFFFFF",
#     charging_color="#00ff00",
#     critical_color="#ff0000",
#     battery_ident="BAT0",
#     format="⚡0 {status} {percentage:.2f}% [{remaining:%E%hh:%Mm}]",
#     alert=True,
#     alert_percentage=7,
#     status={
#         "DIS": "",
#         "CHR": "",
#         "FULL": "",
#    })
# status.register(
#    "battery",
#     full_color="#FFFFFF",
#     charging_color="#00ff00",
#     critical_color="#ff0000",
#     battery_ident="BAT1",
#     format="⚡1 {status} {percentage:.2f}% [{remaining:%E%hh:%Mm}]",
#     status={
#         "DIS": "",
#         "CHR": "",
#         "FULL": "",
#     })

# status.register(
#     "temp",
#     format="{temp:.0f}°C",)

# status.register(
#     "cpu_freq",
#     format=" {avgg}GHz")

status.register(
    "cpu_usage",
    format=" {usage:02}%")

status.register(
    "mem",
    color="#FFFFFF",
    warn_color="#FFFFFF",
    format=" {percent_used_mem}%")

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
    format=" {count}",
    backends=[pacman.Pacman(), yaourt.Yaourt()])

status.run()
