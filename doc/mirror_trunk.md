# Configure a local working copy and add SVN branches

Clone the Git repository

    git clone https://github.com/tharen/open-fvs-mirror
    cd open-fvs-mirror
    git checkout trunk

Add the sourceforge svn-remote

    git config --add svn-remote.sourceforge.url https://svn.code.sf.net/p/open-fvs/code

Add trunk and specific branches as fetch targets

    git config --add svn-remote.sourceforge.fetch trunk:refs/remotes/sourceforge/trunk
    git config --add svn-remote.sourceforge.fetch branches/FMSCdev:refs/remotes/sourceforge/FMSCdev

Alternate formats to include all or specific branches (replace branches with tags, etc.)

    git config --add svn-remote.sourceforge.branches branches/*:refs/remotes/sourceforge/*
    git config --add svn-remote.sourceforge.branches branches/{FMSCdev,FMSCrelease}:refs/remotes/sourceforge/*

Fetch SVN commits that are not currently in the repository. This pull commits for the configured fetch targets, branches, and tags.

    git svn fetch sourceforge
    
If this fails for a specific branch it may be possible to checkout and rebase to recent commit.

    git checkout -b FMSCrelease sourceforge/FMSCrelease
    git svn rebase --revision 2200:HEAD

Any newly configured SVN branches need to be checked out and pushed to the Git remote
    
    git checkout -b FMSCdev sourceforge/FMSCdev
    git push --set-upstream origin FMSCdev

FIXME: Not sure this is necessary, or helpful

    git update-ref refs/remotes/sourceforge/trunk refs/remotes/origin/trunk
    git update-ref refs/remotes/sourceforge/FMSCdev refs/remotes/origin/FMSCdev
    git update-ref refs/remotes/sourceforge/FMSCrelease refs/remotes/origin/FMSCrelease

### AppVeyor Nightly Builds

Nightly builds on [AppVeyor][2] are triggered using the [cron-job.org][1] service.

[1]: https://cron-job.org/en/members/jobs/
[2]: https://ci.appveyor.com/project/tharen/open-fvs-mirror/history
    
One off build

    curl -d "{""accountName"": ""tharen"", ""projectSlug"": ""open-fvs-mirror"", ""branch"": ""FMSCrelease""}" -H "Content-Type: application/json" -H "Authorization: Bearer qbhq158xlc1sjbnvsoot" -X POST https://ci.appveyor.com/api/builds
    
    
