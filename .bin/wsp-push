#/usr/bin/env sh
export HUSKY_SKIP_HOOKS=1
git push \
  && git checkout master \
  && git pull \
  && git push github \
  && git checkout development \
  && git merge master \
  && git push \
  && git push github \
  && page
