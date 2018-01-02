# Open-FVS Mirror

Provides a mirror of the official Open-FVS code as well as 
unnofficial integration continuous integration features.

## Trunk Mirror

The trunk branch is maintained as a pristine one-way mirror of the 
[SVN trunk](https://sourceforge.net/p/open-fvs/code/HEAD/tree/trunk/) 
hosted on Sourceforge.

[![Build status](https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/trunk?svg=true)](https://ci.appveyor.com/project/tharen/open-fvs-mirror/branch/trunk)

Nightly at 20:00 PST a job is triggered on AppVeyor to syncronize
any changes in the SVN and trigger the default build of trunk.

## Master

The master branch provides additional continuous integration service. 
The Open-FVS source code was relocated in the tree from trunk using
`git read-tree --prefix=src/open-fvs/ -u trunk`.

## Getting Started

  $ git clone https://tharen/open-fvs-mirror

