---
title: Heartbleed and Psiphon
author: Psiphon Team
layout: blog/post
date: 2014-04-11
---

The Heartbleed bug: http://heartbleed.com/

## Summary of Heartbleed impact on Psiphon:

* Some Psiphon servers were using affected versions of OpenSSL, leaving the Python web server vulnerable to the Heartbleed attack. Data at risk, within the web server component process, included Psiphon network topology information and network usage statistics in addition to web server key material.

* The SSH/SSH+ Psiphon tunnels were not at risk. User traffic flowing through the Psiphon servers was not at risk. VPN Psiphon tunnels were potentially at risk for man-in-the-middle attacks as the per-session authentication secret is in Python web server memory.

* On April 8, 2014, OpenSSL patches were applied to all affected Psiphon servers. In addition, all affected servers had their non-SSH/SSH+ capabilities revoked (out-of-band updates to all clients), ensuring clients will not attempt to use potentially compromised web server key material outside of the secure tunnel.

* The Windows client does not use OpenSSL and is not affected by the Heartbleed attack.

* The Android client does not use OpenSSL for its tunnel, but does use Android Java SSL for its web requests to Psiphon web servers and Amazon S3. As [Android version 4.1.1 is affected by Heartbleed](http://googleonlinesecurity.blogspot.ca/2014/04/google-services-updated-to-address.html), our app on this particular version of Android remains vulnerable to Amazon, Psiphon servers, or a man-in-the-middle peeking at app memory.

* The email auto-responder server had the affected version of OpenSSL. The attack against it would be to get it to make a SSL connection to a remote mail server (by sending an email request from an address that uses that server), which could then peek into the memory of the mail server. This could potentially expose email content, including addresses. The OpenSSL patches were applied April 8, 2014.

* The feedback processing server had the affected version of OpenSSL. It may have used that library (via Python + [Boto](https://code.google.com/p/boto/)) to make SSL connections to Amazon AWS services and Google Gmail server. This means that Amazon or Google could have accessed [user feedback data](https://psiphon.ca/en/faq.html#information-collected). However, it should be noted that this data is already hosted in Amazon EC2 and a subset of this data is emailed to us via Gmail. The OpenSSL patches were applied April 8, 2014.

* https://psiphon.ca was not using an affected version of OpenSSL.
