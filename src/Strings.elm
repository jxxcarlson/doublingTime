module Strings exposing (text)


text =
    """
# Doubling Time Calculator

This app computes *doubling times,* a quantity
that is important in understanding epidemics.
Below is an example: data for reported cases of
Coronavius (COVID-19) in France
taken from [Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_outbreak_in_France#Timeline_2).

````
 n   Date       Cases
 --------------------
 1   2020-2-25     13
 2   2020-2-26     18
 3   2020-2-27     38
 4   2020-2-28     57
 5   2020-2-29    100
 6   2020-3-1     130
 7   2020-3-2     191
 8   2020-3-3     212
 9   2020-3-4     285
10   2020-3-5     423
11   2020-3-6     613
12   2020-3-7     949
13   2020-3-9    1126
14   2020-3-10   1412
15   2020-3-11   1784
````

During the first phase of an epidemic,
the number of cases reported
typically grows exponentially with time.  The
*doubling time*  is the number
of days that it takes for the reported cases to
double.  The estimated doubling time for
the data above is 2 days.  For the smaller
data set 613, 949, 1126, 1412, 1784, it is 2.74
days.

To compute the doubling time for a data set,
simply enter the numbers in the panel on the
right and press the button **Doubling Time.**
To experiment with the sample data above, press
the **Sample data** button.

## Understanding exponential growth

We human beings, even if we understand the
mathematics, have a poor intuitive understanding
of exponential growth.  Consider for example,
the Parable of the Water Lilies. In a far away
land, there is a magical pond. One the first day
of Spring, there appears one lily pad,
fully formed. On the second day, there are two lily pads,
both fully formed.  On day three, there
are four, again fully formed.  This process
repeats in the same manner day after day
until the pond is completely covered. This
happens on the 48th day.  The question:
*on which day is the pond half covered?*

It is worth pondering this question before
looking at the answer, which you will find
at the bottom of this document under the topic
*Water Lilies, Revisited.*

## Methods

The method used to find the doubling time is standard:

1. Plot the logarithm of the number of cases against
time in days.

2.  Find the slope of the line of best fit.

The doubling time is the logarithm of 2 divided
by the slope.


## Cautions

There are various cautions that one should
exercise in using any curve-fitting program.
Here are two:


1.  We assume exponential growth in the underlying
mechanism.  If that assumption does not hold, the
notion of "doubling time" has no meaning.

2.  Suppose the underlying mechanism is one of exponential
growth — a "perfect" epidemic, for example, in which every
case results in two additional cases three days later. But perhaps
not all cases are detected or reported. Etc.



## Water Lilies, Revisited.

The answer: *the pond is half covered with lily pads on the 47th
day.*  Why?  Going forward in time by one day,
the area covered by lily pads doubles.  Therefore going
backward in time by one day, the area covered by the
lily pads is cut in half.

Now that we understand how to go back in time, we can
answer harder questions.  What, for example, is
the fraction of the pond covered on day 41, one
week before it is completely covered? Well, we must
divide 100% by 2 seven times.  If we do this, we
find that 0.7% of the pond is covered.

## The Moral of the Story

There are many.  But one is worth noting in the context
of the Coronavirus pandemic. One might be tempted to say "Well, there are
only a few hundred cases in a country of many millions.
What's the big deal?"  If the number of cases is small,
*and growing exponentially,* then this *is* a big deal:
it takes a small number of doublings to produce a huge
increase in cases.  Suppose, for example, that the doubling
time is 2 days and that at this moment, there are 1000 cases,
Then after 7 doublings, which takes 2 weeks, there will be
128,000 cases.  After one month, *all things being equal,* there
will be 16,384,000 cases.  Not good!


[Github repo](https://github.com/jxxcarlson/doublingTime)


"""
