==========================
evil-text-object-python.el
==========================

This Emacs package extends Evil (``evil-mode``) with text objects that
operate on Python statements.

The ``evil-text-object-python`` package provides two text objects to
operate on a complete Python statement (or multiple statements if a
count is given):

* ``evil-text-object-python-inner-statement`` is the 'inner' text
  object that selects the actual code of the current statement. This
  text object is character based, and does not include any leading
  whitespace (indentation).

* ``evil-text-object-python-outer-statement`` is the 'outer' text
  object that selects all lines of the current statement. This text
  object is line based, and includes leading whitespace.

The default key bindings are ``il`` and ``al``, which can be memorised
as ‘inner line‘ and ‘a line‘. (Note that ``is`` and ``as`` are already
taken, since Evil and Vim use those to operate on sentences.)


Example
=======

Consider this sample code:

.. code:: python

  class Foo:
      def bar(self):
          print("hello")
          some_complicated_function(
              that='takes',
              quite='a',
              few=very(
                  'complex',
                  arguments={
                      'as': 'you',
                      'can': 'see',
                  },
              ),
              so="it is spread over multiple lines",
              but="in the end it's still a single statement")
          do_something()
          if some_condition:
              do_another_thing()
              do_something_else()

With point (the cursor position) somewhere in the middle of the line
containing the word ’complex’, this works:

* ``cc`` changes only that line (default in evil)

* ``dd`` deletes only that line (default in evil)

* ``cil`` deletes the call to ``some_complicated_function(...)``, and
  changes to insert state at the right indentation level.

* ``cal`` does the same as ``cil``.

* ``dil`` deletes the call to ``some_complicated_function(...)``,
  leaving behing an empty line.

* ``dal`` deletes the call to
  ``some_complicated_function(...)``, leaving no traces behind.

* ``2dal`` deletes the call to ``some_complicated_function(...)``, and
  also the statement that follows, which is ``do_something()``.

* ``vil`` enters visual state, and selects the call to
  ``some_complicated_function(...)``, without the indentation

* ``val`` enters visual state, selects the call to
  ``some_complicated_function(...)``, including indentation, and
  switches to line based visual state.

* ``v5al`` selects 5 statements starting at point using line based
  visual state.


Installation
============

Install from Melpa::

  M-x package-install RET evil-text-object-python RET

Then add this to ``init.el``::

  (add-hook 'python-mode-hook 'evil-text-object-python-add-bindings)

Note that the implementation uses various Python navigation commands
provided by ``python-mode``, which ships with Emacs itself.


Customisation
=============

The default key binding uses the letter ``l`` (``il`` and ``al``), but
can be customised by changing ``evil-text-object-python-statement-key``.
For example:

::

  (setq evil-text-object-python-statement-key "x")

Alternatively, use the Customize interface:

::

  M-x customize-group RET evil-text-object-python RET


Background
==========

This package complements the line-based and indentation-based motions
and text objects:

* For simple Python statements, such as ``x = 3``, the standard
  line-based editing operations work fine. For example, ``dd`` deletes
  a line, ``cc`` changes a line, and so on.

* The indentation-based text objects provided by `evil-indent-plus
  <https://github.com/TheBB/evil-indent-plus>`_ make it easy to edit
  (change, copy, delete, and so on) indented blocks of code such as
  the body of an ``if`` statement, or even the complete block
  including the ``if`` statement itself.

However, for Python statements that span multiple lines, things don't
work as nicely as they should:

* Line-based editing does not match the structure of the code.

* Indentation-based editing selects only partial statements, and
  depending on where the closing parentheses are, it may select
  incomplete expressions.

While both can be useful, it's not always what's intended. It’s also
very easy to end up with code that contains syntax errors.

A statement-based text object is a powerful addition to the existing
editing operations, and hence makes it easier to modify Python code.


Known issues and limitations
============================

* Incremental expansion of the selection in visual mode has not been
  implemented, so ``valalal`` will not select a single statement, then
  two statements, then three statements.
