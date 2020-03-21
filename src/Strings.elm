module Strings exposing (article, text)


article =
    """
## Notes

It is instructive to look at the course of
the pandemic in South Korea.   Testing
and other public health measures
began early, and for four weeks there
were just a few cases: only
30 by day 28. At that point,
exponential growth takes
hold and lasts for about 12 days, until day 42,
at which point the growth in the number of new
cases has started to slow. A week later, on day
49, the growth has slowed still more, and is
now linear.


An article with advice,  data, and graphs: [Corona Virus: Why You Must Act Now (Tomas Pueyo)](https://medium.com/@tomaspueyo/coronavirus-act-today-or-people-will-die-f4d3d9cd99ca)

.
"""


text =
    """
### About Doubling Times

In the early phase of an epidemic, the number of reported
cases grows *exponentially.*  "Exponential growth"
is often used as a synonym for "growing really fast."
However, it has a precise meaning that is
important to understand.

Consider an epidemic where
the number of reported cases on successive days
is  1, 2, 4, 8, 16.  Each day there are twice as many 
cases as they day before.  We say that the *doubling time*
is one day.   On the other hand, if these
were the numbers reported every Monday,
then the doubling time would be 7 days.  The shorter the 
doubling time, the more dangerous the epidemic.



To compute the doubling time for a data set,
simply enter the numbers in the panel on the
right, separated by commas, then press the button **Doubling Time.**
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

![Water lilies](https://cdn.shopify.com/s/files/1/0223/5181/articles/White-Water-Lily1_2048x.progressive_9a90a8df-b617-4e81-976e-f58a12784026_1400x.progressive.jpg?v=1516234095)

The answer: *the pond is half covered with lily pads on
day 47.*  Why?  Going forward in time by one day,
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


### Bacteria, Etc.

![Bacteria](data:image/jpeg;base64,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)

Many other phenomena are characterized by phases
of exponential growth: bacterial and human populations,
a bank account which earns compound interest, etc.
Let's take a look at bacteria. Consider culture of bacteria
growing in a nutrient broth.  Let $N(t)$ be the population
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
this phase does not last indefinitely. Growth in the number of infected
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
