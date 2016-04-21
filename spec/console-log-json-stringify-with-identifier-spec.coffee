consoleLog = require("../lib/console-log.coffee")

describe "console.log JSON.stringify inserts with identifier", ->
  insertType = 'stringify'
  beforeEach ->
    waitsForPromise ->
      atom.workspace.open("test.js")

  describe "back end inserts", ->
    devLayer = "backEnd"
    testString = "test case"
    testObject = """
      object = {
        object2: {
          value: "test"
        }
      }
    """
    testES6ArrowFunction = """
      testFunction (param) => {
        return 'some value'
      }
    """
    testJSFunction = """
      function testFunction (param) {
        return 'some value'
      }
    """
    testFunctionWithoutKeyword = """
      testFunction (param) {
        return 'some value'
      }
    """

    describe "for Uppercase identifier Case Config", ->
      it "should add contain identifier identical to selected text", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText(testString)
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        # coffeelint: disable=max_line_length
        insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
        # coffeelint: enable=max_line_length
        consoleLog.add(devLayer, insertType)
        expect(editor.getText()).toContain "#{insert}"

      it """
        should add insert with identifier on next line,
        if not an object or function
      """, ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText(testString)
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        # coffeelint: disable=max_line_length
        insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
        # coffeelint: enable=max_line_length
        consoleLog.add(devLayer, insertType)
        expect(editor.getText()).toEqual """
        #{testString}
        #{insert}
        """

      it "should add insert with identifier after an object", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText(testObject)
        editor.setCursorScreenPosition([0,0])
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        # coffeelint: disable=max_line_length
        insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
        # coffeelint: enable=max_line_length
        consoleLog.add(devLayer, insertType)
        expect(editor.getText()).toEqual """
          #{testObject}
          #{insert}
        """

      describe "should add insert within function if param is selected", ->
        it "for es6 arrow function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testES6ArrowFunction)
          editor.setCursorScreenPosition([0,0])
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          # coffeelint: disable=max_line_length
          insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
          # coffeelint: enable=max_line_length
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(1)).toEqual "#{insert}"

        it "for a js function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testJSFunction)
          editor.setCursorScreenPosition([0,0])
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          # coffeelint: disable=max_line_length
          insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
          # coffeelint: enable=max_line_length
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(1)).toEqual "#{insert}"

        it "for a function without keyword", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testFunctionWithoutKeyword)
          editor.setCursorScreenPosition([0,0])
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          # coffeelint: disable=max_line_length
          insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
          # coffeelint: enable=max_line_length
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(1)).toEqual "#{insert}"

      describe "should add insert outside function if name is selected", ->
        it "for es6 arrow function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testES6ArrowFunction)
          editor.setCursorScreenPosition([0,0])
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          # coffeelint: disable=max_line_length
          insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
          # coffeelint: enable=max_line_length
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(3)).toEqual "#{insert}"

        it "for a js function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testJSFunction)
          editor.setCursorScreenPosition([0,0])
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          # coffeelint: disable=max_line_length
          insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
          # coffeelint: enable=max_line_length
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(3)).toEqual "#{insert}"

        it "for a function without keyword", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testFunctionWithoutKeyword)
          editor.setCursorScreenPosition([0,0])
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          # coffeelint: disable=max_line_length
          insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}))"
          # coffeelint: enable=max_line_length
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(3)).toEqual "#{insert}"

      it """
        should have a semi colon at end of insert
        if semi colon config is chosen
      """, ->
        editor = atom.workspace.getActiveTextEditor()
        atom.config.set('console-log.semiColons', true)
        editor.insertText(testString)
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        # coffeelint: disable=max_line_length
        insert = "console.log('#{selection.toUpperCase()}', JSON.stringify(#{selection}));"
        # coffeelint: enable=max_line_length
        consoleLog.add(devLayer, insertType)
        expect(editor.getText()).toEqual """
        #{testString}
        #{insert}
        """

    describe "for lowercase identifier Case Config", ->
      beforeEach ->
        atom.config.set('console-log.identifierCase', true)

      it "should add contain identifier identical to selected text", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText(testString)
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
        consoleLog.add(devLayer, insertType)
        expect(editor.getText()).toContain "#{insert}"

      it """
        should add insert with identifier on next line,
        if not an object or function
      """, ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText(testString)
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
        consoleLog.add(devLayer, insertType)
        expect(editor.getText()).toEqual """
        #{testString}
        #{insert}
        """

      it "should add insert with identifier after an object", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText(testObject)
        editor.setCursorScreenPosition([0,0])
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
        consoleLog.add(devLayer, insertType)
        expect(editor.getText()).toEqual """
          #{testObject}
          #{insert}
        """
      describe "should add insert within function if param is selected", ->
        it "for es6 arrow function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testES6ArrowFunction)
          editor.setCursorScreenPosition([0,0])
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(1)).toEqual "#{insert}"

        it "for a js function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testJSFunction)
          editor.setCursorScreenPosition([0,0])
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(1)).toEqual "#{insert}"

        it "for a function without keyword", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testFunctionWithoutKeyword)
          editor.setCursorScreenPosition([0,0])
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(1)).toEqual "#{insert}"

      describe "should add insert outside function if name is selected", ->
        it "for es6 arrow function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testES6ArrowFunction)
          editor.setCursorScreenPosition([0,0])
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(3)).toEqual "#{insert}"

        it "for a js function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testJSFunction)
          editor.setCursorScreenPosition([0,0])
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(3)).toEqual "#{insert}"

        it "for a function without keyword", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText(testFunctionWithoutKeyword)
          editor.setCursorScreenPosition([0,0])
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', JSON.stringify(#{selection}))"
          consoleLog.add(devLayer, insertType)
          expect(editor.lineTextForScreenRow(3)).toEqual "#{insert}"

      it """
        should have a semi colon at end of insert
        if semi colon config is chosen
      """, ->
        editor = atom.workspace.getActiveTextEditor()
        atom.config.set('console-log.semiColons', true)
        editor.insertText(testString)
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', JSON.stringify(#{selection}));"
        consoleLog.add(devLayer, insertType)
        expect(editor.getText()).toEqual """
        #{testString}
        #{insert}
        """
