# arabic2roman
Different implementations of Arabic to Roman numerals conversion

Perl implementation
-------------------
The implementation splits the integer into an array, whose elements are then processed using the same logic, with specifics of each decimal range of units, tens, hundreds and thousands, described in a configuration. The implementation works for any number. Numbers from 4000 upwards reuse configuration for the first 4 decimal ranges and the resulting Roman numeral(s) are decorated with * denoting multiplication by 1000 and | denoting multiplication by 1_000_000.
