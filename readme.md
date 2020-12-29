# Open-FVS FMSCdev

This is a continuous integration branch of the Open-FVS/FMSCdev mirror.

This is an unofficial mirror provided as a convenience to the FVS user
community. Users are referred to the USFS [website](https://www.fs.fed.us/fvs/) 
for supported versions of FVS.

SVN - [FMSCdev][dev_svn]

GitHub - 
[FMSCdev][dev_git]
([FMSCdev-ci][dev-ci_git])

# CI Builds
Continuos integration builds are performed as new commits are added 
from the SVN repository. CI builds are provided by AppVeyor and Travis-CI.
Compiled binaries are tested against against assumed good outputs for consistency.
Successful builds are tagged and binary artifacts are uploaded to GitHub releases.

| Branch | AppVeyor | Travis-CI |
| ------ | :------: | :-------: |
|[FMSCdev][dev_svn]|[![Build status](https://ci.appveyor.com/api/projects/status/ww7ygykde0kdly3c/branch/FMSCdev-ci?svg=true)][dev_appveyor]||

[dev_git]: https://github.com/forest-modeling/open-fvs-mirror/tree/FMSCdev
[dev-ci_git]: https://github.com/forest-modeling/open-fvs-mirror/tree/FMSCdev-ci
[dev_svn]: https://sourceforge.net/p/open-fvs/code/HEAD/tree/branches/FMSCdev/
[dev_appveyor]: https://ci.appveyor.com/project/tharen/open-fvs-mirror/branch/FMSCdev-ci
