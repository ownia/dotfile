# use git blame got long commit SHA1 commit id
github_url="https://github.com/torvalds/linux/commit/"$1""
git_kernel_url="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id="$1""
open $github_url
open $git_kernel_url
