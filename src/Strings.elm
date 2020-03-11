module Strings exposing (text)


text =
    """
# Doubling Time Calculator

This app computes doubling times. Here is an example
Below is data for reported cases of Covid-19 in France
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

During the initial phase of an epidemic,
it is common for the number of cases reported
to grow exponentially with time.  Exponential
growth is characterized by a *doubling time.*
In the case of the data above, this is the number
of days that it takes for the number of cases to 
double.  

To compute the doubling time for a data set,
simply enter the numbers in the panel on the
right and press the button **Doubling Time.**

To experiment with the sample data above, press
the **Sample data** button.
"""
