#!/bin/sh

echo Commit

d=$(date)


git add .
git commit -m "Commit at $d"
git pull --rebase
git push

echo Deploy

# compress
# cp index.html index.html.backup
# gzip -9 index.html

gsutil mkdir gs://brothersouchan.org

bundle exec jekyll build # --watch

# gsutil cp -R _site gs://brothersouchan.org
gsutil rsync -R _site gs://brothersouchan.org
gsutil iam ch allUsers:objectViewer gs://brothersouchan.org
gsutil web set -m index.html -e 404.html gs://brothersouchan.org

# roll back
# rm index.html.gz
# mv index.html.backup index.html

# remove cloudfront cache by invalidation
# aws cloudfront create-invalidation --distribution-id=EWMKSYP4AE9P9 --paths "/*"
