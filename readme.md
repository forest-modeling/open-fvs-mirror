# Open-FVS Mirror

This is a mirror of the official Open-FVS code. This is an unofficial 


The mirror was created using Git-SVN. Currently this is intended to be
a one-way copy of the SVN repository. Upstream contributions can be
submitted by cloning/forking this repository and pushing directly to the 
SVN repository. Instructions on setting up a SVN remote on a local 
instance are available [here](docs/mirror_notes.md).

# Mirrored Branches

Only a subset of branches are mirrored. These are kept pure, e.g. 
only SVN commits are included in these branches. Other branches 
can generally be added on request.

 - [trunk](https://github.com/tharen/open-fvs-mirror/tree/trunk)
 - [FMSCrelease](https://github.com/tharen/open-fvs-mirror/tree/FMSCrelease)
 - [FMSCdev](https://github.com/tharen/open-fvs-mirror/tree/FMSCdev)
 - [PyFVS](https://github.com/tharen/open-fvs-mirror/tree/PyFVS)

# CI Builds
Continuos integration builds are performed as new commits are added 
from the SVN repository. CI builds are provided by AppVeyor and Travis-CI.
Successful builds are tagged and binary artifacts are automatically uploaded
to GitHub releases. Each mirrored branch is tracked by a companion '-ci' branch.

| Branch | AppVeyor | Travis-CI |
| ------ | :------: | :-------: |
|[Trunk Mirror](1)|[![Build status](2)||
|[FMSCrelease](4)|[![Build status](5)||
|[FMSCdev](7)|[![Build status](8)||
|[PyFVS](10)|[![Build status](11)||

[1]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/trunk/
[2]: https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/trunk?svg=true)](https://ci.appveyor.com/project/tharen/open-fvs-mirror/branch/trunk-ci
[4]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/FMSCrelease/
[5]: https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/trunk?svg=true)](https://ci.appveyor.com/project/tharen/open-fvs-mirror/branch/FMSCrelease-ci
[7]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/FMSCdev/
[8]: https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/trunk?svg=true)](https://ci.appveyor.com/project/tharen/open-fvs-mirror/branch/FMSCdev-ci
[10]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/PyFVS/
[11]: https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/trunk?svg=true)](https://ci.appveyor.com/project/tharen/open-fvs-mirror/branch/PyFVS-ci

## Main Branch

The "main" branch is an orphan and is maintained for documentation and 
to provide a GitHub landing page. 