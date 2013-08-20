@Group('Document')
library ace.test.document;

import 'package:ace/ace.dart';
import 'package:bench/bench.dart';
import 'package:unittest/unittest.dart';
import 'sample_text.dart';

Document document;
@Setup
setup() => document = new Document(sampleText);

@Test()
void testDispose() {
  final noop0 = (){};
  final noop1 = (_){};
  expect(document.isDisposed, isFalse);
  document.onChange.listen(noop1, onDone: expectAsync0(noop0));
  document.dispose();
  expect(document.isDisposed, isTrue);
}

@Test()
void testGetLength() {
  expect(document.length, equals(6));
}

@Test()
void testGetAllLines() {
  final lines = document.allLines;
  expect(lines.length, equals(6));
  for (int i = 0; i < sampleTextLines.length - 1; i++)
    expect(lines[i], equals(sampleTextLines[i]));
}

@Test()
void testGetLine() {
  for (int i = 0; i < sampleTextLines.length - 1; i++)
    expect(document.getLine(i), equals(sampleTextLines[i]));
}

@Test()
void testInsert() {
  document.onChange.listen(expectAsync1((Delta delta) {
    expect(delta, const isInstanceOf<InsertTextDelta>());
    expect(delta.range, equals(new Range(0,0,0,5)));
    InsertTextDelta insertTextDelta = delta;
    expect(insertTextDelta.text, equals('snarf'));    
  }));
  final point = document.insert(new Point(0, 0), 'snarf');
  expect(point, equals(new Point(0, 5)));
}

@Test()
void testInsertInLine() {
  document.onChange.listen(expectAsync1((Delta delta) {
    expect(delta, const isInstanceOf<InsertTextDelta>());
    expect(delta.range, equals(new Range(0,0,0,5)));
    InsertTextDelta insertTextDelta = delta;
    expect(insertTextDelta.text, equals('snarf'));    
  }));
  final point = document.insertInLine(new Point(0, 0), 'snarf');
  expect(point, equals(new Point(0, 5)));
}

@Test()
void testInsertLines() {
  document.onChange.listen(expectAsync1((Delta delta) {
    expect(delta, const isInstanceOf<InsertLinesDelta>());
    expect(delta.range, equals(new Range(0,0,2,0)));
    InsertLinesDelta insertLinesDelta = delta;
    expect(insertLinesDelta.lines.length, equals(2));
    expect(insertLinesDelta.lines, equals(['foo', 'bar']));
  }));
  final point = document.insertLines(0, ['foo', 'bar']);
  expect(point, equals(new Point(2, 0)));
}

@Test()
void testInsertNewLine() {
  document.onChange.listen(expectAsync1((Delta delta) {
    expect(delta, const isInstanceOf<InsertTextDelta>());
    expect(delta.range, equals(new Range(0,0,1,0)));
    InsertTextDelta insertTextDelta = delta;
    expect(insertTextDelta.text, equals(document.newLineCharacter));    
  }));
  final point = document.insertNewLine(new Point(0, 0));
  expect(point, equals(new Point(1, 0)));
}

@Test()
void testIsNewLine() {
  expect(document.isNewLine('\r\n'), isTrue);
  expect(document.isNewLine('\r'), isTrue);
  expect(document.isNewLine('\n'), isTrue);
  expect(document.isNewLine('\n\r'), isFalse);
}

@Test()
void testNewLineMode() {
  document.newLineMode = 'windows';
  expect(document.newLineMode, 'windows');
  expect(document.newLineCharacter, '\r\n');
  document.newLineMode = 'unix';
  expect(document.newLineMode, 'unix');
  expect(document.newLineCharacter, '\n');
  document.newLineMode = 'auto';
  expect(document.newLineMode, 'auto');
}

@Test()
void testPositionToIndex() {
  expect(document.positionToIndex(new Point(1, 0), 0),
      // + 1 for the newline character
      equals(sampleTextLine0.length + 1));
}

@Test()
void testRemove() {
  document.onChange.listen(expectAsync1((Delta delta) {
    expect(delta, const isInstanceOf<RemoveTextDelta>());
    expect(delta.range, equals(new Range(0,0,0,10)));
    RemoveTextDelta removeTextDelta = delta;
    expect(removeTextDelta.text, equals(sampleTextLine0.substring(0,10)));    
  }));
  final point = document.remove(new Range(0, 0, 0, 10));
  expect(point, equals(new Point(0, 0)));
}

@Test()
void testRemoveInLine() {
  document.onChange.listen(expectAsync1((Delta delta) {
    expect(delta, const isInstanceOf<RemoveTextDelta>());
    expect(delta.range, equals(new Range(0,10,0,20)));
    RemoveTextDelta removeTextDelta = delta;
    expect(removeTextDelta.text, equals(sampleTextLine0.substring(10,20)));    
  }));
  final point = document.removeInLine(0, 10, 20);
  expect(point, equals(new Point(0, 10)));
}

@Test()
void testRemoveLines() {
  document.onChange.listen(expectAsync1((Delta delta) {
    expect(delta, const isInstanceOf<RemoveLinesDelta>());
    expect(delta.range, equals(new Range(2,0,4,0)));
    RemoveLinesDelta removeLinesDelta = delta;
    expect(removeLinesDelta.lines.length, equals(2));
    expect(removeLinesDelta.lines, equals([sampleTextLine2, sampleTextLine3]));
  }));
  final lines = document.removeLines(2, 3);
  expect(lines.length, equals(2));
  expect(lines[0], equals(sampleTextLine2));
  expect(lines[1], equals(sampleTextLine3));
}

@Test()
void testRemoveNewLine() {
  document.onChange.listen(expectAsync1((Delta delta) {
    expect(delta, const isInstanceOf<RemoveTextDelta>());
    expect(delta.range, equals(new Range(3,sampleTextLine3.length,4,0)));
    RemoveTextDelta removeTextDelta = delta;
    expect(removeTextDelta.text, equals(document.newLineCharacter));    
  }));
  document.removeNewLine(3);  
}

@Test()
void testReplace() {
  int onChangeCount = 0;
  document.onChange.listen(expectAsync1((Delta delta) {    
    switch (onChangeCount++) {
      case 0:
        expect(delta, const isInstanceOf<RemoveTextDelta>());
        expect(delta.range, equals(new Range(0,10,0,20)));
        RemoveTextDelta removeTextDelta = delta;
        expect(removeTextDelta.text, equals(sampleTextLine0.substring(10,20)));
        break;
      case 1:
        expect(delta, const isInstanceOf<InsertTextDelta>());
        expect(delta.range, equals(new Range(0,10,0,15)));
        InsertTextDelta insertTextDelta = delta;
        expect(insertTextDelta.text, equals('snarf'));
        break;
    }
  }, count: 2));
  final point = document.replace(new Range(0, 10, 0, 20), 'snarf');
  expect(point, equals(new Point(0, 15)));
}

@Test()
void testApplyDeltas() {
  final observedDeltas = new List<Delta>();
  final applyToNewDocument = () {
    var newDocument = new Document(sampleText);
    expect(newDocument.allLines, isNot(equals(document.allLines)));        
    newDocument.onChange.listen(expectAsync1((_) {}, count: 3));    
    newDocument.applyDeltas(observedDeltas);
    expect(newDocument.allLines, equals(document.allLines));
  };    
  int observedDeltaCount = 0;
  document.onChange.listen(expectAsync1((Delta delta) { 
      observedDeltas.add(delta);
      if (++observedDeltaCount == 3) applyToNewDocument();
  }, count: 3));  
  document.insertLines(0, ['foo', 'bar']);  
  document.removeNewLine(4);
  document.insertNewLine(new Point(0, 2));  
}

@Test()
void testRevertDeltas() {
  final deltas = new List<Delta>();
  int observedDeltaCount = 0;
  document.onChange.listen(expectAsync1((Delta delta) {    
    if (++observedDeltaCount <= 3) deltas.add(delta);
    if (observedDeltaCount == 3) document.revertDeltas(deltas);
    if (observedDeltaCount == 6) expect(document.value, equals(sampleText));
  }, count: 6));
  document.insertLines(0, ['foo', 'bar']);  
  document.removeNewLine(4);
  document.insertNewLine(new Point(0, 2));
  expect(document.value, isNot(equals(sampleText)));
}

@Test()
void testCreateAnchor() {
  final Anchor anchor = document.createAnchor(1, 42);
  expect(anchor, isNotNull);
  expect(anchor.position, equals(new Point(1, 42)));
}