# Psiphon Website

## Technical Requirements

The site must support translation/localization. This includes supporting right-to-left languages.

The site must be fully functional without JavaScript. (We expect a significant proportion of our users to be running NoScript.)

The site must support desktop and mobile screen sizes, without using JS or subdomains.

The site must be somewhat usable by IE7+. A lot of our user base uses very old browsers. For example, [CloudFlare found](https://blog.cloudflare.com/introducing-universal-ssl/) that only 52% of requests from Iran come from “modern” browsers.

The site must be able to be served from static storage (i.e., S3 bucket).

The site resources must be served from the same domain as the site itself (i.e., no external JS resources, fonts, etc.). This closes some potential security holes.

The site must be able to be served from any sub-path of a domain. That is, the same site must be simultaneously accessible from xyz.example.com/blah/index.html and from example.com/abc/blah/index.html. This is because we serve from https://s3.amazonaws.com/f58p-mqce-k1yj/en/index.html and from http://play.psiphon3.com/en/index.html and even more exotic anti-blocking locations.

The site should be fairly fast to load -- images that aren’t too large, etc. A lot of our users are on degraded connections.


## Getting Started

1. Install [Node.js](http://nodejs.org/).

2. Install [Docpad](http://docpad.org/):
  
  ```
  $ [sudo] npm install -g docpad
  ```

3. Install all dependencies:

  ```
  $ npm install .
  $ cd plugins/languagemaker && npm install . && cd -
  # Or maybe: find . -name package.json -maxdepth 3 -execdir npm install \;
  ```

4. Generate site, serve it, and monitor for changes:

  ```
  $ docpad run

  # Site builds can be quite slow. Skip language generation for faster builds:
  # docpad run --env fastbuild
  ```

## Generating the site for deployment

```
$ docpad clean
$ docpad generate --env static,production
```


## Running the site at root and below a path

This website gets run both at the root of a domain (e.g. `http://psiphon3.com/`) and under a subdirectory of a domain -- specifically, under a S3 bucket (e.g., `https://s3.amazonaws.com/57wj-4j1q-wa7e/`). This makes it difficult to refer to other pages and resources with `href` and `src` attributes from within the site -- `/styles/style.css` won't work when the site is under a subdirectory. One approach would be to hand-craft relative paths for each and page, but this is very brittle and a total pain when using layouts/templates for different pages at different path depths.

So we use a Docpad plugin that provides the relative path to root for each document, and then a global function that we can use wherever we want to provide a path to a page or resource. So, the `src` attribute for an image would look like this:

```
src="<%= @relativeToRoot '/images/path/filename.png' %>"
```

If the page containing that line is located at `/en/blog/index.html.eco`, then it will render to:

```
src="../../images/path/filename.png"
```

And the path will remain correct regardless of the path location of the containing page, and whether the site is hosted at root or in a bucket/subdirectory.

### Testing

Serving the site with Docpad will only test the site-at-root scenario. Testing the site-under-subdirectory scenario can be done like so:

1. Run a static site server in the root directory of the website source (i.e., the directory of this README lives in). (You can use Python's `SimpleHTTPServer` or Node's `node-static` package, or whatever.)
2. In your browser, go to `http://localhost:8080/out/`. 
3. You'll be redirected to `http://localhost:8080/out/en/index.html`. The site is effectively under the `out` directory.
4. Browse around. Watch the console for errors.


## QR Codes

An easy way to generate a QR code is via the Google Chart API. Just put the target URL at the end of this URL: `https://chart.googleapis.com/chart?chs=150x150&cht=qr&chld=M|0&chl=`. For example, here's a [QR for psiphon3.com](https://chart.googleapis.com/chart?chs=150x150&cht=qr&chld=M|0&chl=http://psiphon3.com).


## Sponsor Snippets

Enabling sponsor HTML snippets for a bucket site mostly involves configuring `sponsor_snippet_pull.py` to retrieve the desired snippet and upload it to the correct bucket. The page code will detect the presence of snippet, sanitize, and load it.

JavaScript will be stripped completely from the snippet. `<style>` blocks and external CSS files will be stripped, but inline styles and CSS class names will be left intact.


## I18n hints, tips, issues

### Translating blog posts

Blog posts are originally written in English, and will typically be written using [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet); here is [an example of one](https://bitbucket.org/psiphon/psiphon-circumvention-system/raw/e74506889cb91ca4acdb9db3cc5f6b1c986dc577/Website/src/documents/en/blog/psiphon-a-technical-description.html.md).

Translations can be written using either Markdown or HTML. We're not yet sure if Markdown is entirely happy with i18n, but it's probably best to try that first. Markdown is simpler to write in, HTML provides more control.

If the translation is done in HTML, it should only contain the inner body of the post, and not `<html>`, `<head>`, or `<body>` tags; here is [an example of one](https://bitbucket.org/psiphon/psiphon-circumvention-system/src/cfc2d583bb8cd8f3c4a61d2d248a90c742389ff9/Website/src/documents/fa/blog/psiphon-a-technical-description.html).

At the top of the raw blog post example above you will see the post "metadata". The `title` must be translated and the `author` may be transliterated if appropriate for the target langage. The `layout` must not be changed. 


### Locale-specific images

It's quite easy to add images (screenshots, etc.) that are locale-specific.

1. Create an English version of the image. This will also be used as a fallback if a locale-specific image doesn't exist. Give it a filename of the form `whatever.en.ext`. For example, `i18n-test.en.png`.

2. In the page where you want to use it, create an `img` tag that looks something like:
   ```
   <img src="<%- @relativeToRoot @ttURL '/images/i18n-test.png' %>">
   ```
   (Note that you should also provide an `alt` attribute and you probably also want `class="img-responsive"`.)

   `ttURL` is defined in [`docpad.coffee`](https://bitbucket.org/psiphon/psiphon-circumvention-system/src/tip/Website/docpad.coffee?at=default). If the document currently being generated is in Farsi, it checks to see if there exists a file with the name `/images/i18n-test.fa.png`, uses it if it exists, and falls back to `/images/i18n-test.en.png` or `/images/i18n-test.png` if not.

3. Create the localized images. Save them with appropriate filenames. E.g.: `i18n-test.fa.png`, `i18n-test.zh.png`, `i18n-test.ug@Latn.png`, etc. There doesn't need to (immediately) be one for each supported language, because the English fallback will compensate for missing images.

Note that `ttURL` could also be used for files other than images. Video? CSS?


## Using Google Analytics

Google Analytics is not enabled by default, but can be enabled by adding a file to `src/files/assets/` named `google-analytics-id` containing the Google Analytics tracking ID (like `UA-XXXXX-XX`) that should be used.


## Docpad Tips and Caveats

### Metadata

Metadata in layouts is basically ignored (besides another `layout` in the chain). There's [an issue to improve this](https://github.com/bevry/docpad/issues/458). This is very unfortunate for us because we put almost all content into layouts. And, for example, it would be best to put a page's keywords into the layout rather than in `documents/en/blah.html`.


## Credits

Background pattern from: http://subtlepatterns.com/3px-tile/
