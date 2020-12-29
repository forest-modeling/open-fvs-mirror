# Open-FVS Mirror

This is an unofficial mirror of [Open-FVS](https://sourceforge.net/projects/open-fvs/)
provided as a convenience to the FVS user community. Users are referred to the USFS 
[website](https://www.fs.fed.us/fvs/) for supported versions of FVS.

The mirror was created using Git-SVN and is intended to be a one-way replica. 
Upstream contributions can be submitted by cloning/forking this repository, 
working locally, and pushing directly to the SVN repository. Instructions 
on setting up a SVN remote on a local instance are available 
[here](docs/mirror_notes.md).

# Mirrored Branches

A subset of the SVN branches are mirrored. These are kept pure, e.g. 
only SVN commits are included in these branches. Other branches 
can generally be added on request.

 - [trunk](trunk_svn)
 - [FMSCrelease](release_svn)
 - [FMSCdev](dev_svn)
 - [PyFVS](pyfvs_svn)

# CI Builds
Continuos integration builds are performed as new commits are added 
from the SVN repository. CI builds are provided by AppVeyor and Travis-CI.
Successful builds are tagged and binary artifacts are automatically uploaded
to GitHub releases. Each mirrored branch is tracked by a companion '-ci' branch.

| Branch | AppVeyor | Travis-CI |
| ------ | :------: | :-------: |
|[trunk][trunk_git]|[![Build status](https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/trunk-ci?svg=true)][trunk_appveyor]||
|[FMSCrelease][release_git]|[![Build status](https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/FMSCrelease-ci?svg=true)][release_appveyor]||
|[FMSCdev][dev_git]|[![Build status](https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/FMSCdev-ci?svg=true)][dev_appveyor]||
|[PyFVS][pyfvs_git]|[![Build status](https://ci.appveyor.com/api/projects/status/eyyqq4a57xk0ttt0/branch/PyFVS-ci?svg=true)][pyfvs_appveyor]||

[trunk_git]: https://github.com/forest-modeling/open-fvs-mirror/tree/trunk
[trunk_svn]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/trunk/
[trunk_appveyor]: https://ci.appveyor.com/project/forest-modeling/open-fvs-mirror/branch/trunk-ci

[release_git]: https://github.com/forest-modeling/open-fvs-mirror/tree/FMSCrelease
[release_svn]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/FMSCrelease/
[release_appveyor]: https://ci.appveyor.com/project/forest-modeling/open-fvs-mirror/branch/FMSCrelease-ci

[dev_git]: https://github.com/forest-modeling/open-fvs-mirror/tree/FMSCdev
[dev_svn]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/FMSCdev/
[dev_appveyor]: https://ci.appveyor.com/project/forest-modeling/open-fvs-mirror/branch/FMSCdev-ci

[pyfvs_git]: https://github.com/forest-modeling/open-fvs-mirror/tree/PyFVS
[pyfvs_svn]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/PyFVS/
[pyfvs_appveyor]: https://ci.appveyor.com/project/forest-modeling/open-fvs-mirror/branch/PyFVS-ci

## Main Branch

The "main" branch is an orphan and is maintained for documentation and 
to provide a GitHub landing page. 
