---
title: "Reading multi line records from Ericsson GSM telco data"
timestamp: 2013-07-10T18:13:10
tags:
  - GSM
published: false
author: szabgab
---


Given a `&lt;rlnrp:cell=all;` (look at the first line of the file)
type data file describing relationships between GSM cells,
we need to flatten the multi-line records. Probably in order to import them into a database.

Such tasks are often required by engineers in telco companies or companies that support them.



First let's see the [input data](#input), the [expected output](#output) and
a bit of a [description](#description).

<h2 id="input">The input data

```
<rlnrp:cell=all;
NEIGHBOUR RELATION DATA

CELL
G37423

CELLR     DIR     CAND   CS
G31761    MUTUAL  BOTH   NO

KHYST   KOFFSETP  KOFFSETN   LHYST   LOFFSETP  LOFFSETN
 3       0                    3       0

TRHYST  TROFFSETP  TROFFSETN  AWOFFSET  BQOFFSET
 2       0                     5         3

HIHYST  LOHYST  OFFSETP  OFFSETN  BQOFFSETAFR  BQOFFSETAWB
 5       3       0                 3

CELLR     DIR     CAND   CS
G37911    MUTUAL  BOTH   NO

KHYST   KOFFSETP  KOFFSETN   LHYST   LOFFSETP  LOFFSETN
 3       0                    3       0

TRHYST  TROFFSETP  TROFFSETN  AWOFFSET  BQOFFSET
 2       0                     5         3

HIHYST  LOHYST  OFFSETP  OFFSETN  BQOFFSETAFR  BQOFFSETAWB
 5       3       0                 3

CELL
G37521

CELLR     DIR     CAND   CS
G37422    MUTUAL  BOTH   YES

KHYST   KOFFSETP  KOFFSETN   LHYST   LOFFSETP  LOFFSETN
 3       0                    3       0

TRHYST  TROFFSETP  TROFFSETN  AWOFFSET  BQOFFSET
 2       0                     5         3

HIHYST  LOHYST  OFFSETP  OFFSETN  BQOFFSETAFR  BQOFFSETAWB
 5       3       0                 3

CELLR     DIR     CAND   CS
G37421    MUTUAL  BOTH   YES

KHYST   KOFFSETP  KOFFSETN   LHYST   LOFFSETP  LOFFSETN
 3       0                    3       0

TRHYST  TROFFSETP  TROFFSETN  AWOFFSET  BQOFFSET
 2       0                     5         3

HIHYST  LOHYST  OFFSETP  OFFSETN  BQOFFSETAFR  BQOFFSETAWB
 5       3       0                 3

END
```

<h2 id="output">The expected output data

If your screen is not wide enough it might be a bit unclear, but in the expected output we have one header line and 4 data lines.
Try to reduce the font-size to see how it should look like. The line numbers on the left can be a clue to the real lines in the expected
output file.

```
CELL CELLR DIR CAND CS KHYST KOFFSETP KOFFSETN LHYST LOFFSETP LOFFSETN TRHYST TROFFSETP TROFFSETN AWOFFSET BQOFFSET HIHYST LOHYST OFFSETP OFFSETN BQOFFSETAFR BQOFFSETAWB

G37423 G31761    MUTUAL  BOTH   NO  3       0                    3       0  2       0                     5         3  5       3       0                 3
G37423 G37911    MUTUAL  BOTH   NO  3       0                    3       0  2       0                     5         3  5       3       0                 3
G37521 G37422    MUTUAL  BOTH   YES  3       0                    3       0  2       0                     5         3  5       3       0                 3
G37521 G37421    MUTUAL  BOTH   YES  3       0                    3       0  2       0                     5         3  5       3       0                 3
```

<h2 id="description">A bit of description

The first few lines, up until the first line with 'CELL' in it can be regarded as garbage for our purposes.

There are several sections starting with 'CELL'.

In each section there are several records starting with 'CELLR'. Each such record spreads several lines.
As I can see in this cases each record has 12 physical line which is split up into 4 logical lines.
Each logical line consist of 3 physical lines: a header, a data and and empty line.

CELL is serving cell and CELLR is neighbouring cell.

The line with the 'END' indicates the end of all the file.

