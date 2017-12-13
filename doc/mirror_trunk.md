# Automate sandboxed mirror sync
# Inspire by: https://github.com/Bioconductor/BiocGithubHelp/wiki/Managing-your-Bioc-code-on-hedgehog-and-github

# Clone from GitHub
  $ git clone https://github.com/tharen/open-fvs-mirror
#  $ git clone --depth 50 https://github.com/tharen/open-fvs-mirror open-fvs-mirror2
  $ cd open-fvs-mirror

# Checkout trunk in case it's no longer the default
  $ git checkout trunk

# # Initialize just trunk from the Sourceforge SVN repository
#  $ git svn init https://svn.code.sf.net/p/open-fvs/code/trunk
#  $ git update-ref refs/remotes/git-svn refs/remotes/origin/trunk

# Use this method to facilitate additional branches
  $ git config --add svn-remote.sourceforge.url https://svn.code.sf.net/p/open-fvs/code
  $ git config --add svn-remote.sourceforge.fetch trunk:refs/remotes/sourceforge/trunk

# Point the svn trunk to the git trunk branch
  $ git update-ref refs/remotes/sourceforge/trunk refs/remotes/origin/trunk

# Pull in any changes from SourceForge
# This will probably trigger rebuilding the rev map
  $ git svn rebase

# Push the SVN changes up to GitHub
  $ git push origin trunk
