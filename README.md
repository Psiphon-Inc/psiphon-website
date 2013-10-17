# Psiphon Website

## Getting Started

1. Install [Node.js](http://nodejs.org/).

2. Install [Docpad](http://docpad.org/):
  
  ```
  $ [sudo] npm install -g docpad
  ```

3. Install all dependencies:

  ```
  $ npm install .
  ```

4. Generate site, serve it, and monitor for changes:

  ```
  $ docpad run
  ```

## Generating the site for deployment

```
$ docpad clean
$ docpad generate --env static,production
```


## QR Codes

An easy way to generate a QR code is via the Google Chart API. Just put the target URL at the end of this URL: `https://chart.googleapis.com/chart?chs=150x150&cht=qr&chld=M|0&chl=`. For example, here's a [QR for psiphon3.com](https://chart.googleapis.com/chart?chs=150x150&cht=qr&chld=M|0&chl=http://psiphon3.com).


## I18n hints, tips, issues

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
