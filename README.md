# heap-item

<!--toc:start-->

- [heap-item](#heap-item)
  - [Description](#description)
  - [Build](#build)
  - [Installation](#installation)
  - [Usage](#usage)
  <!--toc:end-->

## Description

A custom heap item written in cython compatible with heapq, this is
used to efficiently store strings(ascii) and
their value(double) of being correct.

## Build

`pip install -r requirements.txt && cibuildwheel`

## Installation

`pip install heapitem`

## Usage

```python
    from heapitem import HeapItem
    item = HeapItem(prob,string)
    heapq.heappush(min_heap_n_most_prob, item)

    for hi in heapq.nlargest(eval_dict['n_samples'], min_heap_n_most_prob):
        n_most_prob_psw.add(hi.password_string)
        del hi      # engages __dealloc__

```

``
