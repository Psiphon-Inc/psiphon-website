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
  $.ajax(type: 'HEAD', url: '/images/sponsor-banner.png')
    .done -> $('.sponsor-info').show()
  $.getJSON('/images/sponsor-banner-link.json')
    .done (url) ->
      $link = $('<a target="_blank">').attr('href', url)
      $('.sponsor-info .sponsor-banner img').wrap($link)
