lyracyst
===

[![lyracyst](lyra.jpg)](http://en.wikipedia.org/wiki/File:Lyra_constellation_detail_long_exposure.jpg)

Constellation Lyra photo by [Scott Roy Atwood](http://en.wikipedia.org/wiki/File:Lyra_constellation_detail_long_exposure.jpg)

[![Build Status](https://travis-ci.org/weirdpercent/lyracyst.png?branch=master)](https://travis-ci.org/weirdpercent/lyracyst)[![Gem Version](https://badge.fury.io/rb/lyracyst.svg)](http://badge.fury.io/rb/lyracyst)[![Dependency Status](https://gemnasium.com/weirdpercent/lyracyst.png)](https://gemnasium.com/weirdpercent/lyracyst)

A powerful word search tool for writers of all kinds.

### Synopsis

Search [Wordnik](http://www.wordnik.com/), [thesaurus.altervista.org](http://thesaurus.altervista.org/), and [Arpabet](http://en.wikipedia.org/wiki/Arpabet) from the command line. Get the necessary API keys as follows:

- Altervista - http://thesaurus.altervista.org/mykey
- Wordnik - http://developer.wordnik.com/

Put them in environment variables THESAURUS and WORDNIK respectively. Add these to .bashrc, .zshrc, Windows path, etc.

### Features

- Open URI fetching w/ transparent caching
- Definitions from Wordnik
- Rhymes from arpabet.heroku.com
- Related words from thesaurus.altervista.org
- JSON parsing

### Planned Features

- JSON/XML parsing
- JSON/XML schema validation
- node.js version

### Usage

    gem install lyracyst
    lyracyst get test
    lyracyst --help
    lyracyst help command

### Code Example

    s=Search.new
    s.define(search) # Wordnik definitions
    s.related(search, result) # Altervista related words
    s.rhyme(search) # Arpabet rhymes

### Motivation

I do a lot of writing and I wanted a tool for constructing song lyrics, poetry, and stories that rock.

### Tests

    TODO

### Developers

    bundle install
    rake lyracyst:get[test]

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

Many thanks to all contributors to the gems used in this project!
