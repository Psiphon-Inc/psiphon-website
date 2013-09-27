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
