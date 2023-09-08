_This project is WIP_

# GitHub Action for Hetzner Cloud Self-Hosted Runners

Automatically start cloud instances in the Hetzner Cloud as self-hosted runners
for GitHub repositories. These are started and stopped automatically before and
after the GitHub CI run.

## Usage

1. Bootstrap your CI job to create a new hetzner instance:

```yaml
jobs:
  prepare_env:
    runs-on: ubuntu-latest
    name: Checkout Hetzner Cloud CI Action
    steps:
      - uses: actions/checkout@v3
      - uses: stonemaster/hetzner-github-runner@HEAD
        with:
          github-api-key: ${{ secrets.GH_API_KEY }}
          hetzner-api-key: ${{ secrets.HETZNER_API_KEY }}
          hetzner-instance-type: cx11
```

2. After this step another workflow can run on this self-hosted machine. Note
   that this job depends on `prepare_env`:

```yaml
jobs:
  [...]
  actual_build:
    runs-on: self-hosted
    needs: prepare_env
    steps:
      - run: env
        shell: bash
```

## Security & Required Keys

**Never put the tokens into clear-text but use the Repository
[secrets feature](XXX) of the GitHub CI**

* The GitHub API Key provided should just have _read/write_ permission to
the *Repository Administration*. This is needed to obtain a new registration
token for your repository that is needed by the GitHub runner.
* A Hetzner API key needs to be generated for your project according to the
[offical documentation](https://docs.hetzner.cloud/#getting-started).
