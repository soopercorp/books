books
=====

CLI goodness for [Goodreads](http://goodreads.com)

###Work in Progress

I *just* started writing this, want to implement the basic wrapper first - add, update books etc.

Once that's done, I'll do something about book discovery. But, there are problems (see below).

###How can you help?

You! Yes, You! Check out some easy-as-pie [issues](https://github.com/hardikr/books/issues)

###Problems

The Goodreads API. Poor design. I can't make more than one request a second. Sigh.. Will need to implement some caching to get around this. Otherwise, it turns out to be an O(n) operation for a user's bookshelf, n being number of things I want to do about their books!