# Open-FVS Mirror

Provides a mirror of the official Open-FVS code as well as 
unnofficial integration continuous integration features.

# CI Builds
## [Trunk Mirror](https://sourceforge.net/p/open-fvs/code/HEAD/tree/trunk/)
[![Build status](https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/trunk?svg=true)](https://ci.appveyor.com/project/tharen/open-fvs-mirror/branch/trunk)

A nightly build is triggered on AppVeyor to syncronize
commits in SVN and perform the default build.

## Master

The master branch provides additional continuous integration service. 
The Open-FVS source code was relocated in the tree from trunk using
`git read-tree --prefix=src/open-fvs/ -u trunk`.

## Getting Started

  $ git clone https://tharen/open-fvs-mirror

