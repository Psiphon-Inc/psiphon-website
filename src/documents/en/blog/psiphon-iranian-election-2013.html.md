---
title: Psiphon and the 2013 Iranian Election
author: Karl Kathuria
date: 2013-10-28
layout: blog/post
---

Psiphon has over a million active users every week. People use our software to get news, information and social media content that they would otherwise not be able to see. We offer apps for Windows and Android devices, mostly distributed through partnerships with news broadcasters and human rights organisations.

This year, we’ve made a particularly big impact in Iran, coinciding with their Presidential election. Iran has always been a big challenge for us, and it’s also where we see the most people using our software. In a normal week, we see as many as 1.5 million unique users connect to our network from inside Iran. There are somewhere around 45 million people connected to the network in Iran, which accounts for [60% of the population](http://globalvoicesonline.org/2013/04/20/iran-60-of-irans-population-is-internet-users/).

We knew that the election period was going to cause some problems, but had no idea exactly what we would face. First, as early as March there were reports that VPN software was being blocked inside the country, as [reported on Wired magazine’s site](http://www.wired.co.uk/news/archive/2013-03/11/iran-vpn-block). Psiphon stayed available throughout this period, and in fact the user base doubled in just four weeks. We brought many more servers online to cope with the additional load on our network.

Then, at the beginning of May, the disruption to the Internet in Iran was brought to a whole new level. We saw a sudden spike in connections, suggesting that the software was rapidly disconnecting and reconnecting. With help from [Collin Anderson](http://averysmallbird.com/) and [ASL19](https://asl19.org/), we learned that SSL connections were being cut after 60 seconds, and all connections to sites outside of Iran were being severely throttled.

People using Psiphon were still able to connect and see some content, but had a heavily degraded experience. Psiphon’s built-in feedback mechanism allowed people to provide diagnostic information that helped us further -- we were receiving feedback at the rate of thousands of messages per day, all containing vital clues that could help us get back to normal.

Our development team rapidly released an update to Psiphon that provided the first workaround. Six further releases followed in the weeks leading up to the election. Psiphon’s software automatically updates, and these releases were pushed directly to the end users. At least half of our user base had the upgrade within a day of it being released, and by the time of the election, 90% of Psiphon users were connecting with known working versions.

Psiphon’s goal for the period of the election was to try and keep our network alive, so that anyone with an Internet connection was still able to get to the content they wanted to see. As many as 500 active servers were used to achieve this, on diverse networks, with close monitoring by the technical teams to ensure the system was available throughout that time.

Reports from Iran suggest that the throttling of SSL, and blocking of all non-HTTP traffic, was increased for the election period, and most specifically on June 14, the day of the election itself. Psiphon’s software remained available throughout this period. **Although there was a reduction in traffic caused by the extreme throttling, there were still over 400,000 connections made by 125,000 unique users.**

Psiphon also distributed content for projects set up to support Iranians specifically over the election period. These include [The Global Dialogue](http://theglobaldialogue.ca) and [We Choose](http://edition.cnn.com/2013/06/11/world/meast/iran-elections-virtual/), projects offering a platform through which the Iranian Internet audience could discuss matters related to the election, and vote on candidates in a secure, open and fair process.

You can read a lot more technical detail about the election period in [a report from our colleagues at ASL19](https://asl19.org/cctr/iran-2013election-report/).

What of the future in Iran? We’ve seen some encouraging signs from Hassan Rouhani, such as his [openness to social media](https://twitter.com/HassanRouhani), but our user base is still growing, and so are [the reports](http://www.iranhumanrights.org/2013/10/rouhani-facebook-twitter/) we’re getting of sites being blocked. Last week, Deutsche Welle’s new Director General, Peter Limbourg, called on Rouhani to stop blocking his organization’s [Persian site](http://www.dw.de/dw-director-general-calls-on-tehran-to-take-steps-towards-more-transparency/a-17147065). He also praised the work that we are doing at Psiphon to distribute DW content into Iran.

This month, we’re also starting two new partnerships with [Manoto 1](http://manoto1.com) and [Radio Zamaneh](http://radiozamaneh.com). Both of these broadcasters have a large audience of Farsi speakers, and are trying to get their content seen and heard in Iran. We’re very pleased to be working with these broadcasters, and know that this will help to bring news, information and social media content to even more Iranians.
