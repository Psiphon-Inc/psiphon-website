# Copyright (c) 2015, Psiphon Inc.
# All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

$ ->

  # Make the language switcher maintain the current anchor (if any).
  if window.location.hash
    $('.languages .dropdown-menu > li > a').each ->
      $(@).prop('href', $(@).prop('href') + window.location.hash)

  #
  # Where indicated by a class name, equalize the height of elements in a row.
  # Note that the `equal-height` class cannot be on a column div, but must be
  # on a div inside it.
  # Also note that this might not play nice with nested rows. (It can probably
  # be made to, though.)
  #
  $(window).resize ->
    $('.row').find('.equal-height:first').each ->
      maxHeight = 0
      $(@).closest('.row').find('.equal-height').each ->
        # Reset the height
        $(@).height('')
        thisHeight = $(@).height()
        if thisHeight > maxHeight then maxHeight = thisHeight
      $(@).closest('.row').find('.equal-height').height(maxHeight)
  # Trigger it to get the initial size right.
  setTimeout(
    () -> $(window).resize(),
    10)

  #
  # If we have a sponsor banner, display the sponsor information.
  # Otherwise leave it hidden.
  #
  banner_img_file = $('.sponsor-banner img').prop('src')
  banner_link_file = $('.sponsor-banner img').data('link-file')
  if banner_img_file
    $.ajax(type: 'HEAD', url: banner_img_file)
      .done ->
        $('.show-if-sponsored').toggleClass('hidden', false)
        $('.show-if-not-sponsored').toggleClass('hidden', true)
      .error ->
        $('.show-if-sponsored').toggleClass('hidden', true)
        $('.show-if-not-sponsored').toggleClass('hidden', false)
  else
    # Some CDN optimizers detect that the sponsor image is missing and alter the
    # page source to hide the image element and remove the `src` attribute.
    # This breaks the test-with-AJAX logic, so we'll also handle the case that
    # the `src` attribute is absent.
    $('.show-if-sponsored').toggleClass('hidden', true)
    $('.show-if-not-sponsored').toggleClass('hidden', false)

  #
  # Some copies of the site only offer Windows xor Android builds, so certain
  # page elements are shown/hidden depending on the presence/absence of the
  # download files.
  #
  android_download_file = $('html').data('android-download-path')
  windows_download_file = $('html').data('windows-download-path')
  for vals in [[android_download_file, '.show-if-android'],
               [windows_download_file, '.show-if-windows']]
    do (fname = vals[0], selector = vals[1]) ->
      $.ajax(type: 'HEAD', url: fname)
        .done ->
          $(selector).toggleClass('hidden', false)
        .error ->
          $(selector).toggleClass('hidden', true)

  ###
  We're disabling the sponsor banner link (for now). Most of our users are
  blocked from getting to most of our sponsors, so offering them the ability
  to try a link to them is misleading and potentially dangerous.
  $.getJSON(banner_link_file)
    .done (url) ->
      $link = $('<a target="_blank">').attr('href', url)
      $('.sponsor-info .sponsor-banner img').wrap($link)
  ###

  # Set the correct sponsor email address, if there's one on the page
  if $('.sponsor-email').length
    sponsor_email_info_file = $('.sponsor-email').data('email-info-file')
    $.getJSON(sponsor_email_info_file)
      .done (email) ->
        $('.sponsor-email').prop('href', "mailto:#{email}").text(email)

  # Set up any slab text we have on the page.
  if $('.slabtext-container').length
    $(window).load ->
      $('.slabtext-container').each (idx, elem) ->
        opts = {}
        if $(elem).data('max-font-size')
          opts.maxFontSize = $(elem).data('max-font-size')

        $(elem).slabText(opts)

      # IE hack -- need to actually resize the window to get the text looking
      # right.
      if navigator.userAgent.match(/MSIE\s([\d.]+)/)
        window.resizeBy(1, 0)
        setTimeout(
          -> window.resizeBy(-1, 0),
          1)

  # If there are dates on the page that should be localized, localize them.
  $('.localize-date').each (idx, elem) ->
    locale = $('html').prop('lang')
    options = {}

    if locale == 'fa'
      # Most Farsi speakers use the Persian calendar
      locale = "#{locale}-u-ca-persian"
    else if locale == 'zh'
      # Needed to get something like "2016年5月3日"
      options = {year: "numeric", month: "long", day: "numeric"}

    date = new Date($(elem).text())

    # TODO: Are there more special-case calendars? See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleDateString
    $(elem).text(date.toLocaleDateString(locale, options))

  if endsWith(window.location.pathname, '/download.html')
    # If the anchor is for the "direct downloads" section, move that section to
    # the top.
    if window.location.hash == '#direct'
      $('#direct').insertBefore('#direct-priority-insert')

  # Do some processing that depends on site-specific configuration
  processSiteConfig()


# The site config file contains values such as Google Analytics ID.
processSiteConfig = () ->
  $.getJSON(PATH_TO_ROOT+'/assets/site-config.json')
    .done (site_config) ->
      # Google Analytics
      setUpAnalytics(site_config)

      # Some links are redirected for analytics
      setupRedirectLinks($('a.redirect-link'), site_config)

      # Insert the sponsor snippet
      processSponsorSnippet(site_config)


# We don't use any analytics on most copies of the site, but we do on a couple.
# If the tracking ID is present in the site config, enable GAnalytics.
setUpAnalytics = (site_config) ->
  return if not site_config.googleAnalyticsID
  newScriptElem = $('<script>').text "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create','#{site_config.googleAnalyticsID}','auto');ga('send','pageview');"
  newScriptElem.insertBefore($('script').eq(0))


# Add click handlers to redirect links
setupRedirectLinks = (elems, site_config) ->
  $(elems).click(_setupRedirectLinksClickHandler(site_config))

# To be used by setupRedirectLinks
_setupRedirectLinksClickHandler = (site_config) ->
  (e) ->
    if typeof(ga) != 'undefined' and site_config.linkRedirectUrl
      targetUrl = $(this).prop('href')
      redirectUrl = site_config.linkRedirectUrl

      # We'll match the redirect page scheme to the target, if the
      # linkRedirectUrl doesn't have a scheme.
      if redirectUrl.indexOf('http') != 0
        if targetUrl.indexOf('https:') == 0
          redirectUrl = 'https:' + redirectUrl
        else
          redirectUrl = 'http:' + redirectUrl

      ga(
        'send',
        'event',
        'outbound',
        'click',
        targetUrl,
        { 'hitCallback':
          () ->
            window.location.assign(redirectUrl + encodeURIComponent(targetUrl))
        })

      # stop default action of following href
      e.preventDefault();
      return false


# Checks for the presence of a sponsor snippet and inserts it. Uses Caja to do so safely.
processSponsorSnippet = (site_config) ->
  # Caja requires IE >= 9
  if checkIEClass('lt-ie9')
    return

  SPONSOR_SNIPPET_BASE = PATH_TO_ROOT + '/sponsor-snippet'
  SPONSOR_SNIPPET_EXTERNAL_BASE = SPONSOR_SNIPPET_BASE + '/external'
  SPONSOR_SNIPPET_HTML = SPONSOR_SNIPPET_BASE + '/snippet.html'

  # We need to rewrite image URIs to point locally.
  uri_transformer = (uri) ->
    str_uri = String(uri)
    if /((\.png)|(\.jpg)|(\.jpeg)|(\.gif))$/.test(str_uri)
      return String(str_uri).replace(/^https?:\/\/(.*)$/i, "#{SPONSOR_SNIPPET_EXTERNAL_BASE}/$1")
    return str_uri

  css_name_transformer = (id) ->
    return id

  $.get(SPONSOR_SNIPPET_HTML)
   .done (content) ->
    santized_content = html_sanitize(content, uri_transformer, css_name_transformer)
    $('#sponsor-snippet-container').append(santized_content)
    # Sanitize and insertion complete, show the snippet container
    $('.show-if-sponsor-snippet').removeClass('hidden')
    # Set up redirect click handlers
    setupRedirectLinks($('#sponsor-snippet-container a'), site_config)


# ieClass should be one of: lt-ie9 lt-ie8 lt-ie7
checkIEClass = (ieClass) ->
  return $('html').hasClass(ieClass)


# From: https://stackoverflow.com/a/2548133/729729
endsWith = (str, suffix) ->
  return str.indexOf(suffix, str.length - suffix.length) != -1
