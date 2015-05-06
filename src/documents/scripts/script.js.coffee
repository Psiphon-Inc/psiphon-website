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
  # Add the FAQ table of contents
  # TODO: Statically create at render time
  #
  if $('#faq-toc')
    childTag = $('#faq-toc').data('child-tag')
    $('.anchor-target').each ->
      child = $(childTag).appendTo($('#faq-toc'))
      childLink = $('<a>').appendTo(child)
      childLink.prop('href', '#' + $(this).prop('id'))
               .text($(this).data('anchor-text'))

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
  $.ajax(type: 'HEAD', url: banner_img_file)
    .done ->
      $('.show-if-sponsored').removeClass('hidden')
    .error ->
      $('.show-if-not-sponsored').removeClass('hidden')

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

  # We don't use any analytics on most copies of the site, but we do on a couple.
  # Check for the presence of a file that provides a Google Analytics tracking ID.
  # If present, enable GAnalytics.
  $.ajax(PATH_TO_ROOT+'/assets/google-analytics-id')
    .done (gaID) ->
      gaID = gaID.trim() or ''
      return if not gaID
      # This is just a coffee-ified version of the standard GA code block.
      ((i, s, o, g, r, a, m) ->
        i['GoogleAnalyticsObject'] = r
        i[r] = i[r] or ->
          (i[r].q = i[r].q or []).push arguments
          return
        i[r].l = 1 * new Date
        a = s.createElement(o)
        m = s.getElementsByTagName(o)[0]
        a.async = 1
        a.src = g
        m.parentNode.insertBefore a, m
        return
      ) window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga'
      ga 'create', gaID, 'auto'
      ga 'send', 'pageview'
      return

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
    if locale == 'fa'
      # Most Farsi speakers use the Persian calendar
      locale = "#{locale}-u-ca-persian"

    date = new Date($(elem).text())

    # TODO: Are there more special-case calendars? See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleDateString
    $(elem).text(date.toLocaleDateString(locale))

  if endsWith(window.location.pathname, '/download.html')
    # If the anchor is for the "direct downloads" section, move that section to
    # the top.
    if window.location.hash == '#direct'
      $('#direct').insertBefore('#store')


# From: https://stackoverflow.com/a/2548133/729729
endsWith = (str, suffix) ->
  return str.indexOf(suffix, str.length - suffix.length) != -1
