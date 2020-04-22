# Log Helper

[![Build Status](https://travis-ci.org/spider-gazelle/log_helper.svg?branch=master)](https://travis-ci.org/spider-gazelle/log_helper)

Sets a temporary `Log::Context` in `Log` blocks that return either `Hash` or `NamedTuple`.
If there's a `message` key in the object, it is deleted and set as the `Log::Entry`'s message.

## Contributing

1. [Fork it](https://github.com/spider-gazelle/log_helper/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Caspian Baska](https://github.com/caspiano) - creator and maintainer
