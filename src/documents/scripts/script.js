// Copyright (c) 2015, Psiphon Inc.
// All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

(function() {
  $(function() {
    // There is no reason we should be inside an iframe, so disallow it
    // (to prevent clickjacking, etc.).
    if (self !== top) {
      try {
        // First try redirecting to the top level page. Note that Edge throws an exception when
        // attempting this, although Firefox allows it.
        top.location.replace(self.location.href);
      } finally {
        // If that fails, block the page to prevent interaction
        setTimeout(function() {
          return $('#iframe-blocker').css('display', '').find('h1').html('This page must not be in an iframe.<br><a target="_top" href="' + self.location.href + '">Visit this page directly.</a>');
        }, 100);
      }
    }
    // Make the language switcher maintain the current anchor (if any).
    if (window.location.hash) {
      $('.languages .dropdown-menu > li > a').each(function() {
        return $(this).prop('href', $(this).prop('href') + window.location.hash);
      });
    }

    // Where indicated by a class name, equalize the height of elements in a row.
    // Note that the `equal-height` class cannot be on a column div, but must be
    // on a div inside it.
    // Also note that this might not play nice with nested rows. (It can probably
    // be made to, though.)
    $(window).resize(function() {
      return $('.row').find('.equal-height:first').each(function() {
        var maxHeight;
        maxHeight = 0;
        $(this).closest('.row').find('.equal-height').each(function() {
          var thisHeight;
          // Reset the height
          $(this).height('');
          thisHeight = $(this).height();
          if (thisHeight > maxHeight) {
            return maxHeight = thisHeight;
          }
        });
        return $(this).closest('.row').find('.equal-height').height(maxHeight);
      });
    });
    // Trigger it to get the initial size right.
    setTimeout(function() {
      return $(window).resize();
    }, 10);

    // If we have a sponsor banner, display the sponsor information.
    // Otherwise leave it hidden.
    let banner_img_file = $('.sponsor-banner img').prop('src');
    let banner_link_file = $('.sponsor-banner img').data('link-file');
    if (banner_img_file) {
      $.ajax({
        type: 'HEAD',
        url: banner_img_file
      }).done(function() {
        $('.show-if-sponsored').toggleClass('hidden', false);
        return $('.show-if-not-sponsored').toggleClass('hidden', true);
      }).error(function() {
        $('.show-if-sponsored').toggleClass('hidden', true);
        return $('.show-if-not-sponsored').toggleClass('hidden', false);
      });
    } else {
      // Some CDN optimizers detect that the sponsor image is missing and alter the
      // page source to hide the image element and remove the `src` attribute.
      // This breaks the test-with-AJAX logic, so we'll also handle the case that
      // the `src` attribute is absent.
      $('.show-if-sponsored').toggleClass('hidden', true);
      $('.show-if-not-sponsored').toggleClass('hidden', false);
    }

    // Some copies of the site don't offer direct-download Android builds, so certain
    // page elements are shown/hidden depending on the presence/absence of the
    // download files.
    //
    // Our GP and Pro download sites must not reference our direct downloads, as required by Store rules.
    // We will check two things:
    // 1. Are we on a copy of the site that _is not_ allowed to reference direct downloads?
    //    If so, default to not allowing direct downloads.
    // 2. Are we only the one page that _is_ allowed to reference direct downloads
    //    (regardless of the copy of the site)? If so, allow direct downloads.
    const direct_download_default_disallowed = [
        'https://s3.amazonaws.com/psiphon/web/iohq-waa4-q4dt/',
        'https://s3.amazonaws.com/psiphon/web/mw4z-a2kx-0wbz/',
        'https://s3.amazonaws.com/www.psiphon3.net/',
        'https://s3.amazonaws.com/psiphon/web/yttm-zeis-pjjd/'
      ].some(prefix => window.location.href.startsWith(prefix));
    const direct_download_override_allowed = endsWith(window.location.href, '/download.html');
    if (!direct_download_default_disallowed || direct_download_override_allowed) {
      // We are allowed to show direct downloads.
      const df_p = (30).toString(36).toLowerCase().split('').map(function(F){return String.fromCharCode(F.charCodeAt()+(-71))}).join('')+(function(){var y=Array.prototype.slice.call(arguments),e=y.shift();return y.reverse().map(function(D,A){return String.fromCharCode(D-e-37-A)}).join('')})(17,100)+(31).toString(36).toLowerCase().split('').map(function(d){return String.fromCharCode(d.charCodeAt()+(-71))}).join('');
      const df_s_a = (function(){var S=Array.prototype.slice.call(arguments),B=S.shift();return S.reverse().map(function(v,U){return String.fromCharCode(v-B-50-U)}).join('')})(20,186,186,178,185,177,186,150)+(17).toString(36).toLowerCase().split('').map(function(Z){return String.fromCharCode(Z.charCodeAt()+(-39))}).join('')+(1090932).toString(36).toLowerCase()+(function(){var Y=Array.prototype.slice.call(arguments),N=Y.shift();return Y.reverse().map(function(P,i){return String.fromCharCode(P-N-7-i)}).join('')})(3,111,115);
      const df_x_a = (function(){var D=Array.prototype.slice.call(arguments),s=D.shift();return D.reverse().map(function(P,z){return String.fromCharCode(P-s-51-z)}).join('')})(5,154,102)+(25).toString(36).toLowerCase()+(function(){var o=Array.prototype.slice.call(arguments),n=o.shift();return o.reverse().map(function(S,G){return String.fromCharCode(S-n-8-G)}).join('')})(53,168);

      // We are even concerned that including the QR code image that links to the direct
      // download -- even if it's not displayed -- might cause a Store rejection. So we'll
      // obfuscate the image URL and add it dynamically.
      const qr_a = (39991).toString(36).toLowerCase().split('').map(function(l){return String.fromCharCode(l.charCodeAt()+(-71))}).join('')+(31273070).toString(36).toLowerCase()+(function(){var l=Array.prototype.slice.call(arguments),A=l.shift();return l.reverse().map(function(b,g){return String.fromCharCode(b-A-18-g)}).join('')})(11,144)+(31).toString(36).toLowerCase().split('').map(function(f){return String.fromCharCode(f.charCodeAt()+(-71))}).join('')+(23181671893).toString(36).toLowerCase()+(31).toString(36).toLowerCase().split('').map(function(Y){return String.fromCharCode(Y.charCodeAt()+(-71))}).join('')+(383).toString(36).toLowerCase()+(function(){var O=Array.prototype.slice.call(arguments),L=O.shift();return O.reverse().map(function(k,K){return String.fromCharCode(k-L-50-K)}).join('')})(63,219,163,217,221,226,228,213)+(54217336117).toString(36).toLowerCase()+(29).toString(36).toLowerCase().split('').map(function(p){return String.fromCharCode(p.charCodeAt()+(-71))}).join('')+(963).toString(36).toLowerCase()+(30).toString(36).toLowerCase().split('').map(function(A){return String.fromCharCode(A.charCodeAt()+(-71))}).join('')+(function(){var X=Array.prototype.slice.call(arguments),G=X.shift();return X.reverse().map(function(M,W){return String.fromCharCode(M-G-28-W)}).join('')})(37,176,177)+(16).toString(36).toLowerCase();

      for (const vals of [[df_p+df_s_a+df_x_a, '.show-if-android', '.android-download-link', '.android-download-link-qr']]) {
        const fname = vals[0];
        const show_selector = vals[1];
        const link_selector = vals[2];
        const qr_selector = vals[3];
        // Check that the file exists.
        // Note that this is a HEAD request, so it won't download the file.
        $.ajax({
          type: 'HEAD',
          url: fname
        }).done(function() {
          $(show_selector).toggleClass('hidden', false);
          $(link_selector).prop('href', fname);
          if (qr_selector) $(qr_selector).prop('src', qr_a);
        });
      }
    }

    /*
    We're disabling the sponsor banner link (for now). Most of our users are
    blocked from getting to most of our sponsors, so offering them the ability
    to try a link to them is misleading and potentially dangerous.
    $.getJSON(banner_link_file)
      .done (url) ->
        $link = $('<a target="_blank">').attr('href', url)
        $('.sponsor-info .sponsor-banner img').wrap($link)
    */

    // Set the correct sponsor email address, if there's one on the page
    if ($('.sponsor-email').length) {
      let sponsor_email_info_file = $('.sponsor-email').data('email-info-file');
      $.getJSON(sponsor_email_info_file).done(function(email) {
        return $('.sponsor-email').prop('href', `mailto:${email}`).text(email);
      });
    }
    // Set up any slab text we have on the page.
    if ($('.slabtext-container').length) {
      $(window).load(function() {
        $('.slabtext-container').each(function(idx, elem) {
          var opts;
          opts = {};
          if ($(elem).data('max-font-size')) {
            opts.maxFontSize = $(elem).data('max-font-size');
          }
          return $(elem).slabText(opts);
        });

        // IE hack -- need to actually resize the window to get the text looking
        // right.
        if (navigator.userAgent.match(/MSIE\s([\d.]+)/)) {
          window.resizeBy(1, 0);
          return setTimeout(function() {
            return window.resizeBy(-1, 0);
          }, 1);
        }
      });
    }

    // If there are dates on the page that should be localized, localize them.
    $('.localize-date').each(function(idx, elem) {
      var date, locale, options;
      locale = $('html').prop('lang');
      options = {};

      if (locale === 'fa') {
        // Most Farsi speakers use the Persian calendar
        locale = `${locale}-u-ca-persian`;
      } else if (locale === 'zh') {
        // Needed to get something like "2016年5月3日"
        options = {
          year: "numeric",
          month: "long",
          day: "numeric"
        };
      }

      date = new Date($(elem).text());

      // TODO: Are there more special-case calendars? See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleDateString
      return $(elem).text(date.toLocaleDateString(locale, options));
    });

    if (endsWith(window.location.pathname, '/download.html') || endsWith(window.location.pathname, '/download-store.html')) {
      // If the anchor is for the "direct downloads" section, move that section to
      // the top.
      if (window.location.hash === '#direct') {
        $('#direct').insertBefore('#direct-priority-insert');
        // Then we need to re-scroll because the browser may have already modified the scroll
        // location due to the presence of the hash in the URL (happens in Firefox but not Chrome).
        setTimeout(function() {
          return window.scrollTo(0, $('#direct').position().top);
        }, 1);
      }
    }

    // Do some processing that depends on site-specific configuration
    processSiteConfig();
  });

  // The site config file contains values such as Google Analytics ID.
  function processSiteConfig() {
    return $.getJSON(PATH_TO_ROOT + '/assets/site-config.json').done(function(site_config) {
      // Google Analytics
      setUpAnalytics(site_config);
      // Some links are redirected for analytics
      setupRedirectLinks($('a.redirect-link'), site_config);
      // Insert the sponsor snippet
      return processSponsorSnippet(site_config);
    });
  }

  // We don't use any analytics on most copies of the site, but we do on a couple.
  // If the tracking ID is present in the site config, enable GAnalytics.
  function setUpAnalytics(site_config) {
    var newScriptElem;
    if (!site_config.googleAnalyticsID) {
      return;
    }
    newScriptElem = $('<script>').text(`(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create','${site_config.googleAnalyticsID}','auto');ga('send','pageview');`);
    return newScriptElem.insertBefore($('script').eq(0));
  }

  // Add click handlers to redirect links
  function setupRedirectLinks(elems, site_config) {
    return $(elems).click(_setupRedirectLinksClickHandler(site_config));
  }

  // To be used by setupRedirectLinks
  function _setupRedirectLinksClickHandler(site_config) {
    return function(e) {
      var redirectUrl, targetUrl;
      if (typeof ga !== 'undefined' && site_config.linkRedirectUrl) {
        targetUrl = $(this).prop('href');
        redirectUrl = site_config.linkRedirectUrl;

        // We'll match the redirect page scheme to the target, if the
        // linkRedirectUrl doesn't have a scheme.
        if (redirectUrl.indexOf('http') !== 0) {
          if (targetUrl.indexOf('https:') === 0) {
            redirectUrl = 'https:' + redirectUrl;
          } else {
            redirectUrl = 'http:' + redirectUrl;
          }
        }

        ga('send', 'event', 'outbound', 'click', targetUrl, {
          'hitCallback': function() {
            return window.location.assign(redirectUrl + encodeURIComponent(targetUrl));
          }
        });

        // stop default action of following href
        e.preventDefault();
        return false;
      }
    };
  }

  // Checks for the presence of a sponsor snippet and inserts it. Uses Caja to do so safely.
  function processSponsorSnippet(site_config) {
    var SPONSOR_SNIPPET_BASE, SPONSOR_SNIPPET_EXTERNAL_BASE, SPONSOR_SNIPPET_HTML, css_name_transformer, uri_transformer;
    // Caja requires IE >= 9
    if (checkIEClass('lt-ie9')) {
      return;
    }

    SPONSOR_SNIPPET_BASE = PATH_TO_ROOT + '/sponsor-snippet';
    SPONSOR_SNIPPET_EXTERNAL_BASE = SPONSOR_SNIPPET_BASE + '/external';
    SPONSOR_SNIPPET_HTML = SPONSOR_SNIPPET_BASE + '/snippet.html';

    // We need to rewrite image URIs to point locally.
    uri_transformer = function(uri) {
      var str_uri;
      str_uri = String(uri);
      if (/((\.png)|(\.jpg)|(\.jpeg)|(\.gif))$/.test(str_uri)) {
        return String(str_uri).replace(/^https?:\/\/(.*)$/i, `${SPONSOR_SNIPPET_EXTERNAL_BASE}/$1`);
      }
      return str_uri;
    };

    css_name_transformer = function(id) {
      return id;
    };

    return $.get(SPONSOR_SNIPPET_HTML).done(function(content) {
      var santized_content;
      santized_content = html_sanitize(content, uri_transformer, css_name_transformer);
      $('#sponsor-snippet-container').append(santized_content);
      // Sanitize and insertion complete, show the snippet container
      $('.show-if-sponsor-snippet').removeClass('hidden');
      // Set up redirect click handlers
      return setupRedirectLinks($('#sponsor-snippet-container a'), site_config);
    });
  }

  // ieClass should be one of: lt-ie9 lt-ie8 lt-ie7
  function checkIEClass(ieClass) {
    return $('html').hasClass(ieClass);
  }

  // From: https://stackoverflow.com/a/2548133/729729
  function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
  }

}).call(this);
