from i3pystatus import Status
from i3pystatus.updates.yaourt import Yaourt

status = Status(standalone=True)

status.register(
    "clock",
    format="%b %-d %k:%M")

status.register(
    "battery",
    full_color="#FFFFFF",
    charging_color="#00ff00",
    critical_color="#ff0000",
    battery_ident="BAT0",
    format="⚡0 {status} {percentage:.2f}% [{remaining:%E%hh:%Mm}]",
    alert=True,
    alert_percentage=7,
    status={
        "DIS": "",
        "CHR": "",
        "FULL": "",
    })

status.register(
    "battery",
    full_color="#FFFFFF",
    charging_color="#00ff00",
    critical_color="#ff0000",
    battery_ident="BAT1",
    format="⚡1 {status} {percentage:.2f}% [{remaining:%E%hh:%Mm}]",
    status={
        "DIS": "",
        "CHR": "",
        "FULL": "",
    })

#status.register(
#    "temp",
#    format="{temp:.0f}°C",)

#status.register(
#    "cpu_freq",
#    format=" {avgg}GHz")

status.register(
    "cpu_usage",
    format=" {usage:02}%")

status.register(
    "mem",
    color="#FFFFFF",
    warn_color="#FFFFFF",
    format=" {percent_used_mem}%")


status.register(
    "disk",
    path="/home",
    format=" {percentage_used}%")

status.register(
    "disk",
    path="/",
    format=" {percentage_used}%")

#status.register(
#    "network",
#    format_up="{essid}  {quality}%",
#    interface="wlp3s0")

#status.register(
#    "online",
#    format_online="",
#    format_offline="")

#status.register(
#    "openvpn",
#    vpn_name="Lieferheld",
#    format="vpn {status}",
#    status_command="bash -c 'nmcli c show --active %(vpn_name)s | grep VPN.CFG'")

status.register(
    "updates",
    color="#FFFFFF",
    format=" {count}",
    backends=[Yaourt(False)])

status.run()
