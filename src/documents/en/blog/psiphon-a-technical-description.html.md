---
title: A Technical Description of Psiphon
author: Psiphon Team
layout: blog/post
date: 2014-03-13
---

Here's an update to address two recent questions: in simple terms, what is Psiphon and how does it differ from a VPN service; and, what has changed since the technical design document was last updated.

Psiphon 3 is a centrally managed, geographically diverse network of 1000s of proxy servers. Most of our infrastructure is hosted with cloud providers. Psiphon 3 is a "one hop" architecture with secure link encryption between clients and servers. We offer clients for the most popular platforms: Windows, Android, and iOS (in alpha).

Psiphon is [open source](https://bitbucket.org/psiphon/psiphon-circumvention-system). Our service offers a strong [privacy policy](http://play.psiphon3.com/en/faq.html#information-collected); there are no user accounts and user network addresses are not logged.

Psiphon differs from standard VPN services in a couple of key ways:
* We deploy strategies to distribute subsets of servers to users aiming to provide each user with a handful of servers they can reach while not revealing the entire network to one user. To achieve this goal, the size of our network -- and in particular the diversity of our network addresses -- isn't simply a function of our traffic load.
* We use protocol obfuscation to bypass DPI blocking.

Psiphon's technical [design document](https://bitbucket.org/psiphon/psiphon-circumvention-system/downloads/DESIGN.pdf) is out-of-date and what follows is a very brief summary of major technical changes we've implemented since the project launched in 2011.

* We added the [obfuscated SSH](https://github.com/brl/obfuscated-openssh) protocol to mitigate DPI fingerprinting. This fully random-looking protocol is deployed with a unique obfuscation key per Psiphon server.

* We added an optional HTTP prefix to our protocol to mitigate DPI-based whitelisting of HTTP traffic. This simple prefix is sufficient for regex-based DPI (nDPI and l7-filter) to classify Psiphon traffic as HTTP; and was sufficient to defeat an actual adversary at the time we deployed it.

* We added remote server lists to augment the embedded and discovery servers concepts. While discovery happens only when connected to an existing server, remote server lists can be downloaded even when all servers are blocked. Remote server lists are distributed on S3 and accessed via `https://s3.amazonaws.com` without a distinguishing bucket name in the URL. In this way, it is difficult for an adversary to block our remote server lists without blocking all of S3 or implementing HTTPS traffic analysis.

* Email is now a major client propagation mechanism. We have an auto-responder that returns links and attachments to custom sponsor/channel Psiphon clients depending on the email address users send to.

* We released an Android client in 2012. The first version included an embedded browser based on Android's [WebView](http://developer.android.com/reference/android/webkit/WebView.html). In 2012/2013 we added support for whole device tunneling, which tunnels all Android apps through Psiphon. We have an iptables whole device mode (for rooted Android 2.2+ devices); and a whole device mode that uses Android's [VpnService](http://developer.android.com/reference/android/net/VpnService.html) with [tun2socks](http://code.google.com/p/badvpn/wiki/tun2socks) (for any Android 4+ device). Additional features added include egress region selection and proxy chaining.

* We have an iOS client now in alpha testing. This app has an embedded browser.

* Our in-app feedback mechanism sends us messages and optional diagnostics from users. This system has helped us debug many platform issues and blocking issues.

* Changes to discovery algorithms: our discovery algorithms evolve as part of an ongoing process of optimizing our network. Major changes include sharing discovery servers across propagation channels; and adding time-of-day as a dimension.

* Optimizations to connection algorithms: our clients now launch connections to many servers at once when connecting, and keep the "best" connection. This assists in load balancing as well as reducing user wait time as individual blocked servers do not stall the connection sequence.

* Client auto-upgrade was enhanced to use incremental download and to use out-of-band download sites (authenticated with digital signatures). These changes made it more likely that a new client can be distributed at a time of blocking.
