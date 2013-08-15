@Group('EditSession')
library ace.test.edit_session;

import 'package:ace/ace.dart';
import 'package:bench/meta.dart';
import 'package:unittest/unittest.dart';
import 'sample_text.dart';

EditSession session;
@Setup
setup() => session = new EditSession(new Document(sampleText), 'ace/mode/text');

@Test()
void testEditSessionCtor() {
  expect(session, isNotNull);
  expect(session.value, equals(sampleText));  
}

@Test()
void testCreateEditSession() {  
  session = createEditSession(sampleText, 'ace/mode/dart');
  expect(session, isNotNull); 
  expect(session.value, equals(sampleText));
}

@Test()
void testDispose() {
  final noop0 = (){};
  final noop1 = (_){};
  expect(session.isDisposed, isFalse);
  session.onChangeOverwrite.listen(noop1, onDone: expectAsync0(noop0));
  session.onChangeScrollLeft.listen(noop1, onDone: expectAsync0(noop0));
  session.onChangeScrollTop.listen(noop1, onDone: expectAsync0(noop0));
  session.onChangeTabSize.listen(noop1, onDone: expectAsync0(noop0));
  session.onChangeWrapLimit.listen(noop1, onDone: expectAsync0(noop0));
  session.onChangeWrapMode.listen(noop1, onDone: expectAsync0(noop0));
  session.dispose();
  expect(session.isDisposed, isTrue);
}

@Test()
void testDocument() {
  expect(session.document, const isInstanceOf<Document>());
  expect(session.document.value, equals(sampleText));
  final newText = 'do re me fa so la ti do';
  session.document = new Document(newText);
  expect(session.document.value, equals(newText));
  expect(session.value, equals(newText));
}

@Test()
void testGetLength() {
  expect(session.length, equals(6));
}

@Test()
void testValue() {
  final text = 'do re me fa so la ti do';
  session.value = text;
  expect(session.value, equals(text));
  expect(session.document.value, equals(text));
  session.document.value = sampleText;
  expect(session.value, equals(sampleText));
}

@Test()
void testSetTabSize() {
  session.onChangeTabSize.listen(expectAsync1((_) {    
    expect(session.tabSize, equals(7));    
  }));
  session.tabSize = 7;
}

@Test()
void testUseSoftTabs() {
  session.useSoftTabs = true;
  session.tabSize = 5;
  expect(session.useSoftTabs, isTrue);
  expect(session.tabString, equals('     '));
  session.useSoftTabs = false;
  expect(session.useSoftTabs, isFalse);
  expect(session.tabString, equals('\t'));
}

@Test()
void testUseWrapMode() {
  session.onChangeWrapMode.listen(expectAsync1((_){}, count: 2));
  session.useWrapMode = true;
  expect(session.useWrapMode, isTrue);
  session.useWrapMode = true; // Should not fire an event.
  expect(session.useWrapMode, isTrue);
  session.useWrapMode = false;
  expect(session.useWrapMode, isFalse);
}

@Test()
void testSetWrapLimitRange() {
  session.onChangeWrapMode.listen(expectAsync1((_) {    
    expect(session.wrapLimitRange['min'], equals(63));
    expect(session.wrapLimitRange['max'], equals(65));
  }));
  session.setWrapLimitRange(min: 63, max: 65);
}

@Test()
void testSetWrapLimitRangeMin() {
  session.onChangeWrapMode.listen(expectAsync1((_) {    
    expect(session.wrapLimitRange['min'], equals(63));
    expect(session.wrapLimitRange['max'], equals(null));
  }));
  session.setWrapLimitRange(min: 63);
}

@Test()
void testSetWrapLimitRangeMax() {
  session.onChangeWrapMode.listen(expectAsync1((_) {    
    expect(session.wrapLimitRange['min'], equals(null));
    expect(session.wrapLimitRange['max'], equals(65));
  }));
  session.setWrapLimitRange(max: 65);
}

@Test()
void testAdjustWrapLimit() {
  session.useWrapMode = true;
  session.setWrapLimitRange(min: 63, max: 65);  
  session.onChangeWrapLimit.listen(expectAsync1((_) {    
    expect(session.wrapLimit, equals(64));
  }));  
  expect(session.adjustWrapLimit(64, 80), isTrue);
  expect(session.wrapLimit, equals(64));
}

@Test()
void testSetScrollLeft() {
  session.onChangeScrollLeft.listen(expectAsync1((int scrollLeft) {
    expect(scrollLeft, equals(13));
    expect(session.scrollLeft, equals(13));
  })); 
  session.scrollLeft = 13;
}

@Test()
void testSetScrollTop() {
  session.onChangeScrollTop.listen(expectAsync1((int scrollTop) {
    expect(scrollTop, equals(42));
    expect(session.scrollTop, equals(42));
  })); 
  session.scrollTop = 42;
}

@Test()
void testSetOverwrite() {
  final bool initialValue = session.overwrite;
  session.onChangeOverwrite.listen(expectAsync1((_) {
    expect(session.overwrite, isNot(initialValue));
  })); 
  session.overwrite = !initialValue;
}

@Test()
void testToggleOverwrite() {
  final bool initialValue = session.overwrite;
  session.onChangeOverwrite.listen(expectAsync1((_) {
    expect(session.overwrite, isNot(initialValue));
  })); 
  session.toggleOverwrite();
}
