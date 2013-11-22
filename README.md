# Metaphors cli

This is an example program to query The Mind is a Metaphor database and
generate reports.

## Usage
This uses bundler to ensure you have everything installed:

```shell
$ gem install bundler
$ bundle install
```

After all the gem dependencies are resolved, tweak the query parameters
and run the program from the terminal:

```shell
$ ruby bin/metaphors.rb search SEARCHTERM
```

If you run into problems, you can ask the client for help:

```shell
$ ruby bin/metaphors.rb help
```

You can also run this with pretty colors:

```shell
$ ruby bin/metaphors.rb search Uncategorized --verbose
```

Alternatively, you can change the ACL on the file:

    chmod +x bin/metaphors.rb

After this, you can execute the program with:

    ./bin/metaphors.rb search Uncategorized

## More Reading

* [http://rubydoc.info/gems/rsolr-ext/1.0.3/frames](http://rubydoc.info/gems/rsolr-ext/1.0.3/frames)
