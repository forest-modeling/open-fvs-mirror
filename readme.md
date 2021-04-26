# Open-FVS FMSCrelease

This is a continuous integration branch of the Open-FVS/FMSCrelease mirror.

This is an unofficial mirror provided as a convenience to the FVS user
community. Users are referred to the USFS [website](https://www.fs.fed.us/fvs/) 
for supported versions of FVS.

SVN - [FMSCrelease][release_svn]

GitHub - 
[FMSCrelease][release_git]
([FMSCrelease-ci][release-ci_git])

# CI Builds
Continuos integration builds are performed as new commits are added 
from the SVN repository. CI builds are provided by AppVeyor and Travis-CI.
Compiled binaries are tested against against assumed good outputs for consistency.
Successful builds are tagged and binary artifacts are uploaded to GitHub releases.

| Branch | AppVeyor | Travis-CI |
| ------ | :------: | :-------: |
|[FMSCrelease][release_svn]|[![Build status](https://ci.appveyor.com/api/projects/status/ww7ygykde0kdly3c/branch/FMSCrelease-ci?svg=true)][release_appveyor]||

[release_git]: https://github.com/forest-modeling/open-fvs-mirror/tree/FMSCrelease
[release-ci_git]: https://github.com/forest-modeling/open-fvs-mirror/tree/FMSCrelease-ci
[release_svn]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/branches/FMSCrelease/
[release_appveyor]: https://ci.appveyor.com/project/tharen/open-fvs-mirror/branch/FMSCrelease-ci
