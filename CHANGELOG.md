Changelog
===

Version 1.2.0 - Anagrams
- Added webscraper for wordsmith.org's anagram generator

Version 1.1.0 - Major cleanup
- Dropped redundant format flag, autodetects format based on file extension.
- Split up the command blocks into separate files
- Fixed rhyme outfile

Version 1.0.2 - Code climate & defaults
- Methodized more code blocks to improve climate
- Now using smart defaults for httpi, multi_json & multi_xml

Version 1.0.1 - Output file improvements
- Added search term to outfile
- Removed unnecessary duplication
- JSON files are pretty-generated.

Version **1.0.0** - Subcommands, More options, Onelook
- Added word info from [Onelook.com](http://www.onelook.com/?c=faq)
- Added more CLI options
- Shortened command names and added subcommands

Version 0.0.9 - File export, Urban Dictionary, Code Climate
- Added definitions from Urban Dictionary
- Added JSON & XML export
- Restructured code to improve climate

Version 0.0.8 - Major Improvements
- The biggest milestone yet!
- Most Wordnik search functions now work
- Removed Altervista related words in favor of using Wordnik
- Migrated from [ARPABET](http://arpabet.heroku.com) to [Rhymebrain](http://rhymebrain.com/api.html) and using it to fetch rhymes, word info, and portmanteaus
- Migrated from [commander](http://github.com/visionmedia/commander) to [gli](http://github.com/davetron5000/gli) for CLI interface
- Configuration file for defaults (~/.lyracyst.yml)

Version 0.0.7 - Tests, Optimization, & More Cleanup
- Better docs
- Testing on more Ruby implementations
- More restructuring of code and lib files
- Transition from open-uri_cached to httpi
- Support for multiple HTTP clients
- More Cucumber features
- multi_xml support for multiple XML parsers
- XML parsing

Version 0.0.6 - Module & Docs
- Better documentation
- Some rubocop cleanup
- Lyracyst Module
- Cucumber features w/ Aruba

Version 0.0.5 - Basic documentation
- Command-line interface works
- No more Code Climate because it doesn't like commander gem
- Fixed /bin executable

Version 0.0.1 - Feature complete
- Ruby environment works
- Secure Travis build works
- JSON data handling works
- Definitions work
- Related words work
- Thesaurus daily query limit enforced
- Rhymes work
- Improved Code Climate
