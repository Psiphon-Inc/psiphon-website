/*
 * Copyright (c) 2015, Psiphon Inc.
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

/*jslint node: true*/
"use strict";

var cheerio = require('cheerio');


/**
makeFaqToc adds the table of contents to the FAQ page.
opts is the argument passed to the renderDocument event.
No return value. Will modify opts directly.
*/
function makeFaqToc(opts) {
  var faqPageInfo = opts.templateData.getPageInfo('faq');
  var faqPageBasename = faqPageInfo.filename.slice(
                          faqPageInfo.filename.lastIndexOf('/') + 1,
                          faqPageInfo.filename.lastIndexOf('.'));

  // Only process the file we're interested in, at the final render pass.
  if (opts.file.attributes.basename !== faqPageBasename ||
      opts.file.type !== 'document' || opts.extension !== 'html') {
    return;
  }

  var $ = cheerio.load(opts.content);

  if ($('#faq-toc')) {
    var childTag = $('#faq-toc').data('child-tag');
    $('.anchor-target').each(function() {
      var child = $(childTag);
      var childLink = $('<a>');
      childLink.attr('href', '#' + $(this).attr('id'))
               .text($(this).data('anchor-text'));
      child.append(childLink);
      $('#faq-toc').append(child);
    });
  }

  // Keep the modified page HTML.
  opts.content = $.html();
}


/**
handleRenderDocument does render-time work, such as adding the table of
contents to the FAQ page.
opts is the argument passed to the renderDocument event. It may be modified by
this function.
*/
exports.handleRenderDocument = function(opts) {
  makeFaqToc(opts);
};
