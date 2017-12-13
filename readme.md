# Open-FVS Mirror

Provides a mirror of the official Open-FVS code as well as 
unnofficial integration continuous integration features.

## Trunk Mirror

The trunk branch is intended to be a pristine one-way mirror of the 
[SVN trunk](https://sourceforge.net/p/open-fvs/code/HEAD/tree/trunk/) 
hosted on Sourceforge. The trunk branch is syncronized nightly.

## Master

The master branch provides the continuous integration service. The trunk branch
was relocated as a subfolder [open-fvs] using
`git read-tree --prefix=open-fvs/ -u trunk`.

## Getting Started

  $ git clone https://tharen/open-fvs-mirror

