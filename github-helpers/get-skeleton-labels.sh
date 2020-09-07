#!/bin/bash

# get labels from hySpc.read.mat package
curl https://api.github.com/repos/r-hyperspec/hySpc.read.mat/labels |\
grep -ve '\"id\":' - |\
grep -ve '\"node_id\":' - |\
grep -ve '\"url\":' - |\
grep -ve '\"default\":' - > github-helpers/hySpc.read.mat.labels.json
