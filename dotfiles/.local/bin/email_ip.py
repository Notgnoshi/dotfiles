#!/usr/bin/python3
import os
import socket
from datetime import datetime
from urllib.request import urlopen

import yagmail


def gen_email(previous_ip, current_ip):
    f_time = datetime.now().strftime("%a %b %d at %H:%M")
    gw = os.popen("ip -4 route show default").read().split()
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect((gw[2], 0))

    gateway = gw[2]
    local_ip = s.getsockname()[0]
    hostname = socket.gethostname()

    p1 = "<p>Hostname: <code>{}</code></p>".format(hostname)
    p2 = "<p>Gateway: <code>{}</code></p>".format(gateway)
    p3 = "<p>Previous IP: <code>{}</code></p>".format(previous_ip)
    p4 = "<p>Local IP: <code>{}</code></p>".format(local_ip)
    p5 = "<p>Public IP: <code>{}</code></p>".format(current_ip)

    body = p1 + p2 + p3 + p4 + p5

    # c.f. https://github.com/kootenpv/yagmail#username-and-password
    # TODO: get to work with a cronjob
    yag = yagmail.SMTP("Notgnoshi@gmail.com")
    to = "Notgnoshi@gmail.com"
    subject = "IP Address on " + f_time

    try:
        yag.send(to=to, subject=subject, contents=body)
        print("Successfully sent {} at {}".format(current_ip, f_time))
    except:
        print("Failed to send email.")


def test_ip():
    with open(".ip", "r") as f1:
        ip1 = f1.read()
    ip2 = urlopen("http://ipecho.net/plain").read().decode("utf-8")
    if ip1 != ip2:
        gen_email(ip1, ip2)
        with open(".ip", "w") as f2:
            f2.write(ip2)
    else:
        print("Your IP Address ({}) hasn't changed".format(ip1))


if __name__ == "__main__":
    test_ip()
