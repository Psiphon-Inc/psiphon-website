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
var _ = require('lodash');


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
    _.templateSettings.escape = /{{[^%]([\s\S]+?)}}/g;
    _.templateSettings.evaluate = /{{%([\s\S]+?)%}}/g;

    // Compile the template.
    var template = _.template($('#faq-toc-template').html());

    // We'll go through the sections and questions, filling out the TOC.
    var currSection = null;
    /* Will have this structure:
    {
      head_id: "id of the accordion head",
      collapse_id: "id of the accordion collapse elem",
      section_text: "title of the section",
      section_id: "anchor id for the section",
      subsections: [
        head_id: "id of the accordion head, null if no subsection",
        collapse_id: "id of the accordion collapse elem",
        section_text: "title of the subsection",
        section_id: "anchor id for the subsection",
        questions: [
          {
            text: "text of the question",
            id: "anchor id for the question"
          }
        ]
      ]
    }
    */
    var currQuestions = null;

    $('.faq-section, .faq-subsection, .faq-qa').each(function() {
      var $elem = $(this);

      if ($elem.hasClass('faq-section')) {
        // We've hit a new section. Write out the template for the previous section,
        // and start collecting info for this one.
        if (currSection) {
          $('#faq-toc').append(template(currSection));
        }
        currSection = {
          subsections: [{
              head_id: null,
              questions: []
            }]
          };

        currQuestions = currSection.subsections[0].questions;

        currSection.head_id = $elem.attr('id') + "-toc-head";
        currSection.collapse_id = $elem.attr('id') + "-toc-collapse";
        currSection.section_text = $elem.text();
        currSection.section_id = $elem.attr('id');
      }
      else if ($elem.hasClass('faq-subsection')) {
        currSection.subsections.push({
          head_id: $elem.attr('id') + "-toc-head",
          collapse_id: $elem.attr('id') + "-toc-collapse",
          section_text: $elem.text(),
          section_id: $elem.attr('id'),
          questions: []
        });

        currQuestions = currSection.subsections[currSection.subsections.length-1].questions;
      }
      else { // faq-qa
        currQuestions.push({
          text: $elem.find('.faq-question > h3').text(),
          id: $elem.find('.anchor-target').attr('id')
        });
      }
    });

    // After looping through, there's one more section to append.
    if (currSection) {
      $('#faq-toc').append(template(currSection));
    }
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
