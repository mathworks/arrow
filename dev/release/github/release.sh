# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

release() {
  if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <release_name> <release_description> <release_asset> [prerelease=yes|no]"
    exit
  fi

  release_name=$1
  release_description=$2
  release_asset=$3

  release_asset_name=$(basename $release_asset)

  if ["$#" -ge 4] && ["$4" = "yes"]; then
      prerelease=true
  else
      prerelease=false
  fi

  release_id=$(gh api -i \
                --method POST \
                -H "Accept: application/vnd.github+json" \
                -H "X-GitHub-Api-Version: 2022-11-28" \
                /repos/apache/arrow/releases \
                -f tag_name="${release_name}" \
                -f target_commitish='main' \
                -f name="${release_name}" \
                -f body="${release_description}" \
                -F draft=false \
                -F prerelease=${prerelease} \
                -F generate_release_notes=false} | jq .[] | .id)

  gh api \
    --method POST \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    --hostname github.com \
    /repos/apache/arrow/releases/${release_id}/assets?name=${release_asset_name} \
    --input ${release_asset}
}