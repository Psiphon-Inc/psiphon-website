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
