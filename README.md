## purescript-call-by-name

[![Latest release](http://img.shields.io/github/release/natefaubion/purescript-call-by-name.svg)](https://github.com/natefaubion/purescript-call-by-name/releases)
[![Build status](https://github.com/natefaubion/purescript-call-by-name/workflows/CI/badge.svg?branch=master)](https://github.com/natefaubion/purescript-call-by-name/actions?query=workflow%3ACI+branch%3Amaster)

Syntactically light-weight call-by-name arguments in PureScript. No guarantees.
Completely gratuitous.

## What is this library?

This library takes advantage of term-abstraction incurred by type class
dictionaries to approximate call-by-name evaluation for arguments. We
simulate call-by-name by taking a `Unit -> a` argument which defers evaluation
of `a` until invoked. We then provide operators to coerce these
type-class-abstracted terms into the more reliable call-by-name form.

Take the `when` function from `Prelude`:

```purescript
when :: forall m. Applicative m => Boolean -> m Unit -> m Unit
```

It is strict in both arguments, so it will _allocate_ the provided effect
even though it may be discarded. This can be problematic, especially if there
are `let` bound values:

```purescript
example =
  when that do
    let
      a = somethingExpensive 42
      b = somethingElseExpensive a
    this a b
```

Both `a` and `b` will be evaluated, which we don't want. The alternative is to
use a call-by-name approximation:

```purescript
when :: forall m. Applicative m => Boolean -> (Unit -> m Unit) -> m Unit

example =
  when that \_ -> do
    let
      a = somethingExpensive 42
      b = somethingElseExpensive a
    this a b
```

But wow that's irritating. This library exports an application operator `\\`
that makes this look better.

```purescript
import CallByName.Applicative (when)
import CallByName.Syntax ((\\))

example =
  when that \\do
    let
      a = somethingExpensive 42
      b = somethingElseExpensive a
    this a b
```

We've saved four arduous characters.

There's also the `~` operator which lifts terms into `Lazy`.

```purescript
somethingLazy :: Lazy Int -> Int

example =
  somethingLazy ~(evaluate expensive int)
```

Versus the old:

```purescript
example =
  somethingLazy (Lazy.defer \_ -> evaluate expensive int)
```

## Somewhat actually useful things

This library also exports some call-by-name variants of functions that don't
exist in current Prelude or ecosystem.

```purescript
CallByName.Applicative.when ::
  forall m. Applicative m => Boolean -> (Unit -> m Unit) -> m Unit

CallByName.Applicative.unless ::
  forall m. Applicative m => Boolean -> (Unit -> m Unit) -> m Unit

CallByName.Monoid.guard ::
  forall m. Monoid m => Boolean -> (Unit -> m) -> m
```

And also exports a version of the `Alt` type class which defers it's second
argument.

```purescript
class Strict.Alt f <= Alt f where
  alt :: forall a. f a -> (Unit -> f a) -> f a
```

This can be combined with a magic, right-associated version of `<|>` which
_does not_ strictly evaluate it's second argument.

```purescript
example =
  Just 42 <|> unsafeThrow "Too strict!"
```
