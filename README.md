# Basic Wordle Solver/Helper

Contains common lisp functions to help in solving wordle puzzles. Play wordle like normal. After each guess input the state of the guess to the solver/helper and it will then tell you all remaining possibilities and the best next guess. Note, the dictionary does contain some proper nouns and I am not sure if these are legal in wordle. I left them in because I was too lazy to take them out. I have never seen them be the correct answer.

# Using the Wordle Solver/Helper

Compile and load the `wordle.lisp` file. The easiest way to to start SLIME in emacs, load `wordle.lisp` into a buffer, and then hit `C-c C-k` in the buffer. To load the dictionary and analyze letter frequencies enter this at the REPL:

```(words-from "wordle.txt")```

Then in at the REPL you can run the solver/helper like this:

```(play-wordle <put guesses here>)```

# Making Guesses

After making a guess use the color coded hints from wordle to encode which guesses you have made. Each symbol you give to `play-wordle` can have have an exclamation point, a number, and a letter, always in that order. However, you do not have to use all of those items. The letter is always the letter your guessed, the number is the position of the letter, and the exclamation point negates the condition. As an example, let's assume you entered the letter 'r' in the fourth position (position counts start from 1).

* If the 'r' is green, you would encode that as `4r` (there is an 'r' in the fourth position)
* If the 'r' is yellow, you would encode that as `!4r` (there is an 'r', but not in the fourth position)
* Finally, if the 'r' is grey, you would encode that as `!r` (there is no 'r')

# Sample Game

For example, this is one round of play using [Wordle Game](https://wordlegame.org/)

## First Guess: TEARS

Wordle gives back  Grey T, Yellow E, Grey A, Grey R, Grey S. This gets encoded as `(play-wordle !t !2e !a !r !s)`

After running the function you will get back all guesses, plus a set of suggestions for the next best guess. Always choose from the best guesses until that list is exhausted, then start choosing from the list of all remaining.

## Second Guess: LINED

Wordle gives back Yellow L, Grey I, Grey N, Yellow E, Grey D. This gets encoded as `(play-wordle !t !2e !a !r !s !1l !i !n !4e !d)`

## Third Guess: PLUME

Wordle gives back Grey P, Green L, Green U, Green M, Green E. This gets encoded as `(play-wordle !t !2e !a !r !s !1l !i !n !4e !d !p 2l 3u 4m 5e)`

## Fourth Guess: FLUME

It's the only one left, and wordle accepts the answer, all letters are green.
