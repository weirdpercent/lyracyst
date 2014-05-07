lyracyst
===

[![lyracyst](lyra.jpg)](http://raw.githubusercontent.com/weirdpercent/lyracyst/master/lyra.jpg)

Constellation Lyra photo by Scott Roy Atwood

[![Build Status](https://travis-ci.org/weirdpercent/lyracyst.svg?branch=master)](https://travis-ci.org/weirdpercent/lyracyst) [![Gem Version](https://badge.fury.io/rb/lyracyst.svg)](http://badge.fury.io/rb/lyracyst) [![Dependency Status](https://gemnasium.com/weirdpercent/lyracyst.png)](https://gemnasium.com/weirdpercent/lyracyst) [![Code Climate](https://codeclimate.com/github/weirdpercent/lyracyst.png)](https://codeclimate.com/github/weirdpercent/lyracyst) [![Coverage Status](https://coveralls.io/repos/weirdpercent/lyracyst/badge.png)](https://coveralls.io/r/weirdpercent/lyracyst)

A powerful word search tool for writers of all kinds.

### Synopsis

Search [Wordnik](http://www.wordnik.com/), [thesaurus.altervista.org](http://thesaurus.altervista.org/), and [Arpabet](http://en.wikipedia.org/wiki/Arpabet) from the command line. It's pretty opinionated, for reasons I will document eventually. Get the necessary API keys as follows:

- Altervista - http://thesaurus.altervista.org/mykey
- Wordnik - http://developer.wordnik.com/

Put them in environment variables THESAURUS and WORDNIK respectively. Add these to .bashrc, .zshrc, Windows env, etc. This allows [TravisCI](http://www.travis-ci.org) to be used for continuous integration.

### Features

- JSON and XML parsing
- Definitions from Wordnik
- Rhymes from arpabet.heroku.com
- Related words from thesaurus.altervista.org
- Supports multiple HTTP clients, recommends curb for speed
- Supports multiple JSON parsers, recommends oj for speed
- Supports multiple XML parsers, recommends ox for speed

### Planned Features

- JSON/XML schema validation
- JSON/XML export
- node.js version using Opal: Ruby in Javascript

### Usage

    gem install lyracyst
    lyracyst get test
    lyracyst --help
    lyracyst help get

### Code Example

```ruby
fmt = 'json'
lang = 'en_US'
result = []
search = 'test'
g=Lyracyst::Get.new
g.get(search, result, lang, fmt) # Fetch all
de = Lyracyst::Define.new
de.define(search, fmt)
result = []
re = Lyracyst::Relate.new
re.relate(search, result, lang, fmt)
result = []
rh = Lyracyst::Rhyme.new
rh.rhyme(search, result)
```

### Motivation

I do a lot of writing and I wanted a tool for constructing song lyrics, poetry, and stories that rock.

### Tests

Lyracyst uses Aruba to test commandline features. To run the tests, just run:

    cucumber

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
