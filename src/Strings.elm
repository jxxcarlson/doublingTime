module Strings exposing (text)


text =
    """
### About Doubling Times

The doubling time is a number that is important in understanding
any quantity that grows exponentially, e.g.,
[bacterial populations](https://vlab.amrita.edu/?sub=3&brch=73&sim=1105&cnt=1) or the number of
infected individuals in the first
phase of an epidemic, e.g, the
[the Coronavirus epidemic](https://medium.com/@tomaspueyo/coronavirus-act-today-or-people-will-die-f4d3d9cd99ca).

The doubling
time is the time it takes for the quantity
in question to increase by a
factor of two. For example,
if the number of infected
people on successive days as 1, 2, 4, 8, 16,
then the doubling time is one day. On the
other hand, if these
are the numbers reported every Monday,
then the doubling time is 7 days.

An epidemic
with a short doubling time is more dangerous
and difficult to deal with than one with
a long doubling time.

To compute the doubling time for a data set,
simply enter the numbers in the panel on the
right, separated by commas, and press the button **Doubling Time.**
To experiment with the sample discussed below, press
the **Sample data** button.  Data for the
countries listed on the right are obtained by
pushing the corresponding button (France, Italy, etc.)
 For a different view
of the data, press the **Data** tab above.

*If weekly doubling times are getting longer and longer, this is a
good sign: the epidemic is slowing down. At some point growth
of the number of cases will no longer be exponential.  At some
still later point, the growth will be zero: the epidemic is then
finished.*


### Example

![France: Coronavirus](http://jxxcarlson.s3.amazonaws.com/covid-19-france.png)

Above is a graph of the number of Coronavirus cases
reported in France for the period February 25
to March 12, 2020.  It looks "roughly exponential."
Below is a table of the reported cases. You see the same
data in the middle panel, and below it in red, a computation
of doubling times. The image
and data are from
[Wikipedia](https://en.wikipedia.org/wiki/2020_coronavirus_outbreak_in_France#Timeline_2).

````
 n   Date       Cases   Increase
 -------------------------------
 1   2020-2-25     13    --
 2   2020-2-26     18    38%
 3   2020-2-27     38   111%
 4   2020-2-28     57    50%
 5   2020-2-29    100    15%
 6   2020-3-1     130    30%
 7   2020-3-2     191    47%
 8   2020-3-3     212    10%
 9   2020-3-4     285    34%
10   2020-3-5     423    68%
11   2020-3-6     613    45%
12   2020-3-7     949    55%
13   2020-3-8    1126    19%
14   2020-3-9    1412    25%
15   2020-3-10   1784    26%
16   2020-3-11   2281    28%
17   2020-3-12   2876    26%
````

The estimated doubling time for
the data above is 2.1 days.  It is interesting
to experiment with subsets of the data e.g., the
last week's worth of cases ( 613, 949, 1126, 1412, 1784, 2281, 2876).
For this set, the doubling times is 2.8
days.  This result suggests that while
the epidemic is still growing, it is growing at
a slower rate.  That is good news.  But a growth
rate of zero is still better.



### Understanding exponential growth

We human beings, even if we understand the
mathematics, have a poor intuitive understanding
of exponential growth.  Consider for example,
the Parable of the Water Lilies.

> *In a far away
land, there is a magical pond. On the first day
of Spring, there appears one lily pad,
fully formed. On the second day, there are two lily pads,
also fully formed.  On day three, there
are four.  And so on, until the pond is
completely covered. This
happens on the 48th day.*

The question:
*on which day is the pond half covered?*

It is worth pondering this question before
looking at the answer, which you will find
at the bottom of this document under the topic
*Water Lilies, Revisited.*


### Methods

The method used to find the doubling time is standard:

1. Plot the logarithm of the number of cases against
time in days.

2.  Find the slope of the line of best fit.

The doubling time is the logarithm of 2 divided
by the slope.


### Cautions

There are various cautions that one should
exercise in using any
curve-fitting program. Here are two:


1.  We assume exponential growth in the underlying
mechanism.  If that assumption does not hold, the
notion of "doubling time" has no meaning.

2. The number of reported cases by a given date may
be quite different from the actual
number of cases. Did all sick persons
see a doctor?  Were all those persons
properly diagnosed? Etc.


### Water Lilies, Revisited.

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

### The Moral of the Story

One might be tempted to say "Well, there are
only a few hundred cases of disease X in a country of
many millions. What's the big deal?"  If the number of cases is small,
*and growing exponentially,* then this *is* a big deal:
it takes a small number of doublings to produce a huge
increase in cases.  Suppose, for example, that the doubling
time is 2 days and that at this moment, there are 1000 cases,
Then after 7 doublings, which takes 2 weeks, there will be
128,000 cases.  After one month, *all things being equal,* there
will be 16,384,000 cases.  Not good!


### Technical Stuff

Let $N(t)$ be the cumulative number of cases recorded as of time $t$,
where $t = 0, 1, 2, ...$ is the number of days after the date
of the first set of cases reported.  Consider
the data $n(t) = \\log N(t)$. Let $n = mt + b$ be the
"line of best fit" obtained by the least squares method.
Then

$$
\\hat N(t) = e^{mt + b} = e^{mt}N(0)
$$

is a function which "best fits" the data. To find the
doubling time $\\Delta t$, solve the equation

$$
2N(0) = e^{m\\Delta t}N(0)
$$

to obtain

$$
\\Delta t = \\frac{\\log 2}{m}
$$

**Remark.** The sequence of numbers

$$
\\hat N(0), \\hat N(1), \\hat N(2), \\cdots
$$

is a geometric progression
with common ratio $c = e^m$. This is because

$$
\\frac{\\hat N(t+1)}{\\hat N(t)} = \\frac{e^{m(t+1)}\\hat N(0)}{e^{mt}\\hat N(0)} = e^m
$$


### Remarks on Bacteria

We mentioned that bacterial populations
under the right conditions can grow
exponentially. Consider culture of bacteria
in a nutrient broth.  Let $N(t)$ be the population
 at time $t$.  A plot  of $\\log N(t)$  versus $t$
will look somewhat like the one below:

![Bacterial Growth](http://textbookofbacteriology.net/growthcurve.jpeg)

This is taken from
[Todar's Online Textbook of Biology](http://textbookofbacteriology.net/growth_3.html). The phases of the culture are as follows

- **Lag.**  Cells working away, growing, but not yet dividing.

- **Exponential.** Unconstrained cell division, adequate nutrients.

- **Stationary.** Environment running out resources, e.g. space, nutrients, accumulation of waste products; cell division stopped.

-  **Death.**  As in (3), but worse.  Population enters exponential decline.

The main point: exponential growth applies to one phase of the lifetime of the
bacterial population.


### Remarks on Epidemics

As with bacteria, there is an exponential  growth phase,
and as with bacteria,
it does not last indefinitely. Growth in the number of infected
persons decreases as the number of susceptible individuals
decreases through one of the following mechanism:

- Death

- Infection

- Recovery: an infected individual who recovers acquires immunity and cannot be infected again.

When there are no more susceptible individuals,
the epidemic ends. Again, exponential growth applies only in the early phase.

### Notes

This app is written in [Elm](https://elm-lang.org).  Here is the 
[Github repo](https://github.com/jxxcarlson/doublingTime). If you
have a comment, contact jxxcarlson@gmail.com (James Carlson)



"""



--## References
--
--[R0, Wikipedia](https://en.wikipedia.org/wiki/Basic_reproduction_number)
--
--[James Holland Jones, Notes on R0](https://web.stanford.edu/~jhj1/teachingdocs/Jones-on-R0.pdf)
--
--[Unraveling R0](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3935673/)
-- https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Novel_Coronavirus_SARS-CoV-2.jpg/600px-Novel_Coronavirus_SARS-CoV-2.jpg
