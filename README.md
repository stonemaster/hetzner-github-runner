_This project is WIP_

# GitHub Action for Hetzner Cloud Self-Hosted Runners

Automatically start cloud instances in the Hetzner Cloud as self-hosted runners
for GitHub repositories. These are started and stopped automatically before and
after the GitHub CI run.

## Usage

1. Bootstrap your CI job to create a new hetzner instance:

```yaml
    [...]
      - id: hetzner-test
        uses: stonemaster/hetzner-github-runner@HEAD
        with:
          github-api-key: ${{ secrets.GH_API_KEY }}
          hetzner-api-key: ${{ secrets.HETZNER_API_KEY }}
          hetzner-instance-type: CX11

    [...]
```

2. After this step another workflow can run on this self-hosted machine:

```yaml
[...]
jobs:
 release_build:
     runs-on: self-hosted
[...]
```

## Security & Required Keys

**Never put the tokens into clear-text but use the Repository
[secrets feature](XXX) of the GitHub CI**

* The GitHub API Key provided should just have _read/write_ permission to
the *Repository Administration*. This is needed to obtain a new registration
token for your repository that is needed by the GitHub runner.
* A Hetzner API key needs to be generated for your project according to the
[offical documentation](https://docs.hetzner.cloud/#getting-started).
