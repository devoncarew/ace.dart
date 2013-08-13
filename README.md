# Ace.dart

A [Dart][dart] wrapper for [Ace][ace].

[![Build Status](https://drone.io/github.com/rmsmith/ace.dart/status.png)][badge]

## Documentation

Please consult our [API documentation][api] as well as the 
[Ace API reference][ace-api].

## Status

This project is in its wee infancy and no version has been published yet.

## Usage

```dart
import 'dart:html';
import 'package:ace/ace.dart' as ace;

main() {
  var editor = ace.edit(query('#editor'))
      ..theme = "ace/theme/monokai"
      ..session.setMode("ace/mode/dart");
}
```

## Agenda

The plan for this project is to implement a thin wrapper around [ace-builds][].  

Until the Dart vm lands in a stable version of Chrome there is no compelling 
reason to re-write large portions in Dart code.  By maintaining a thin wrapper 
to the javascript, we benefit from all of the wonderful contributions to Ace.js.

## Note to Contributors

This project is a core part of my (yet unpublished) application.  I am open to 
contributions, but be forewarned that I will provide a lot of constructive 
criticism and that I expect high test coverage.  I have no interest in building 
a framework or integrating unnecessary dependencies.

_Ace.dart uses the MIT license as described in the [LICENSE][license] file, and 
follows [semantic versioning][]._

[ace]: http://ace.ajax.org/
[ace-api]: http://ace.ajax.org/#nav=api
[ace-builds]: https://github.com/ajaxorg/ace-builds/
[api]: http://rmsmith.github.com/ace.dart/ace.html
[badge]: https://drone.io/github.com/rmsmith/ace.dart/latest
[dart]: http://www.dartlang.org/
[license]: https://github.com/rmsmith/fields/blob/master/LICENSE
[semantic versioning]: http://semver.org/