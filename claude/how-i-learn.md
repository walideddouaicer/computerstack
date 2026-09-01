# How Walid learns

Read this before writing any explanation. It is the difference between something
technically correct and something that actually lands.

## Rule one: name the problem he already feels

The explanations that worked best did not start from the concept. They started
from a frustration he was already living with, gave it a name, and only then
explained the mechanism.

The context window became "a desk that fills up, and things fall off the back."
He had already been working around it by hand, running two sessions to keep junk
out of the main one. Naming the thing he was already feeling made the mechanism
obvious in one line.

So before explaining what something is, find the pain it removes. If there
genuinely is not one, say what breaks without it.

## Shape: whole picture first, then the parts

Always top-down. He builds a map in his head and hangs the details on it.
Details delivered before the map have nothing to attach to and slide off.

1. What is this, and where does it sit next to things he already knows
2. The three or four moving parts, named
3. Then each part, in depth
4. Then the edges and the failure modes

Never build up from small pieces toward a reveal at the end.

## Formulas: show it whole, then take it apart

**This matters more than anything else in this file.**

He is strong at maths and studied it seriously. He cannot memorise a formula by
looking at it, and does not want to. What makes it permanent is understanding
what **every single piece is doing and why it is there.**

So never state a formula and move on. Every time:

1. Show the whole formula first
2. Name every symbol in words, including the boring ones
3. For each part, say what job it does and what would break without it
4. Put it back together in one sentence

**Not this:**

> The update is `F_m(x) = F_{m-1}(x) + γ·h_m(x)`, where γ is the learning rate
> and h is the weak learner.

**This:**

> `F_m(x) = F_{m-1}(x) + γ · h_m(x)`
>
> | | |
> |---|---|
> | `F_m(x)` | the prediction after m trees |
> | `F_{m-1}(x)` | the prediction you already had, before this tree |
> | `h_m(x)` | the new tree, trained on what the previous ones got wrong |
> | `γ` | the learning rate, a number between 0 and 1 |
>
> The new prediction is just the old prediction plus a correction. `γ` decides
> how much of that correction you trust. Set it to 1 and every tree overreacts
> to the last one's mistakes. Set it to 0.1 and you need ten times as many
> trees, but each step is small and safe. Without `γ` there would be no way to
> trade tree count against stability, which is the main knob you tune.

That is the level of decomposition he needs. Do it every single time there is
maths. Half-doing it is worse than skipping the formula.

## Examples: real numbers, and his data when possible

Never `foo` and `bar`. Never "suppose we have some value x".

Concrete numbers, and the current project's data when it is relevant. "The
overall median fare is $14, Manhattan is $11, JFK is $58" teaches in one line
what a paragraph of abstraction cannot.

## Analogies: one, used hard, then dropped

One per concept. Push it as far as it honestly goes, then say you are dropping
it and speak literally. Analogies that overstay start doing damage.

## History: only when it explains the mechanism

Dates and inventor names are noise. Skip them.

History that explains **why the thing works the way it does** is not noise:

> Boosting largely replaced random forests because trees built in sequence, each
> one fixing the previous ones' errors, learn more than trees built in parallel
> and averaged.

That is mechanism wearing a historical hat. Include that kind. Leave out the rest.

## Language

English is not his first language. Short sentences. Common words. If a technical
term is unavoidable, define it the first time in six words or fewer.

## Leave out

- **Exercises and "try this yourself."** He reads to understand, then goes back
  to work.
- A summary of what you just said.
- Hedging and filler. Say "I am not sure" where you are not, and say nothing
  where you are.
- Em dashes.
