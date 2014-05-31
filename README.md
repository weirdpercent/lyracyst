lyracyst
===

[![lyracyst](lyra.jpg)](http://raw.githubusercontent.com/weirdpercent/lyracyst/master/lyra.jpg)

Constellation Lyra photo by Scott Roy Atwood

[![Build Status](https://travis-ci.org/weirdpercent/lyracyst.svg?branch=master)](https://travis-ci.org/weirdpercent/lyracyst) [![Gem Version](https://badge.fury.io/rb/lyracyst.svg)](http://badge.fury.io/rb/lyracyst) [![Dependency Status](https://gemnasium.com/weirdpercent/lyracyst.png)](https://gemnasium.com/weirdpercent/lyracyst) [![Code Climate](https://codeclimate.com/github/weirdpercent/lyracyst.png)](https://codeclimate.com/github/weirdpercent/lyracyst) [![Coverage Status](https://coveralls.io/repos/weirdpercent/lyracyst/badge.png)](https://coveralls.io/r/weirdpercent/lyracyst)

Now fully wielding [Wordnik](http://developer.wordnik.com/docs.html) in one hand and [Rhymebrain](http://rhymebrain.com/api.html) in the other, Lyracyst is extremely powerful. It is multiligual. In English for example, it can fetch 16 kinds of related words, 27 parts of speech definitions, ARPABET pronunciations, bi-gram phrases, etymologies, example uses, hyphenation, IPA pronunciations, multiple dictionaries, offensive word flags, portmanteaus, rhymes, and syllable stress and count. Inspired by [Finnegans Wake](http://en.wikipedia.org/wiki/Finnegans_Wake), I believed I could create a tool that could be used to write a book like Finnegans Wake in a very short time. James Joyce dedicated 17 years of his life to this novel, and as a tribute to him, I've tried to accelerate the process.

### Platform

Lyracyst was designed with POSIX systems in mind, though it should work on Windows with something like [ansicon](http://github.com/adoxa/ansicon). Ruby also 2.0 added support for ANSI on Windows.

### Synopsis

Search [Wordnik](http://www.wordnik.com/) and [Rhymebrain](http://rhymebrain.com) from the command line. Lyracyst is pretty opinionated in ways I will eventually document. Get the necessary API keys as follows:

- Wordnik - http://developer.wordnik.com/

Put it in an environment variable WORDNIK. Add it to .bashrc, .zshrc, Windows env, etc. This allows [TravisCI](http://www.travis-ci.org) to be used for continuous integration.

### Features

- Extensible
- JSON and XML parsing
- Rhymes, word info, and portmanteaus from rhymebrain.com
- Definitions from Urban Dictionary
- Definitions, examples, related words, pronunciations, hyphenation, phrases, and etymologies from Wordnik
- Supports multiple HTTP clients, recommends net-http-persistent for speed and pure ruby compatibility
- Supports multiple JSON parsers, recommends oj for speed, json_pure for pure ruby compatibility
- Supports multiple XML parsers, recommends REXML for speed and pure ruby compatibility

### Planned Features

- JSON/XML schema validation
- JSON/XML export
- node.js version using Opal: Ruby in Javascript

### Usage

    gem install lyracyst
    lyracyst define test
    lyracyst --help
    lyracyst help define

### Code Example

```ruby
search = 'test'
part = 'noun,verb,adjective,adverb'
params = { canon: false, defdict: 'all', limit: 10, increl: false, inctags: false }
df=Lyracyst::Wordnik::Define.new
df.define(search, part, params)
```

### Motivation

I do a lot of writing and I wanted a tool for constructing song lyrics, poetry, and stories that rock.

### Tests

Lyracyst uses [Aruba](http://github.com/cucumber/aruba), [Methadone](http://github.com/davetron5000/methadone), and [Spinach](http://codegram.github.io/spinach/) to test commandline features. To test, just run:

    spinach

### Developers

    bundle install
    rake lyracyst:define[test]

### Contributing workflow

Here’s how we suggest you go about proposing a change to this project:

1. [Fork this project][fork] to your account.
2. [Create a branch][branch] for the change you intend to make.
3. Make your changes to your fork.
4. [Send a pull request][pr] from your fork’s branch to our `master` branch.

Using the web-based interface to make changes is fine too, and will help you
by automatically forking the project and prompting to send a pull request too.

[fork]: http://help.github.com/forking/
[branch]: https://help.github.com/articles/creating-and-deleting-branches-within-your-repository
[pr]: http://help.github.com/pull-requests/

### License

The MIT License (MIT)

**Copyright (c) 2014 Drew Prentice**

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.**

### Gratitude

Many thanks to all contributors to the gems used in this project! Wordnik and
Rhymebrain are both amazing. All I did was write CLI wrappers for them; they
are the real geniuses.
