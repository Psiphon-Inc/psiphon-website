$ ->

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
