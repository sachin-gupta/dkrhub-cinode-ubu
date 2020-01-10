# 0.0.0 / 2020-01-10

Added skeleton for project having `Simple 2-Stage (Build+Deploy) w/ Multiple Environment based Releases`, where for simplicity in pipeline definition only two `unified-stages` are defined as `Prepare` and `Deploy` in the ci-configuration.

## 1. Prepare Stage:

`Prepare-stage` is ment for integrating all steps in delivering a deployable and tested artifact in single stage. It is purposed to include steps such as: `code-lint`, `code-generation`, `build / compilation`, and `testing`, etc.

- Nothing except hello message is coded in `v0.0.0` or skeleton-project for this stage.
- As defined in conditions in ci-configuration, following items goes through dummy build cycle in prepare stage:
  - Untagged Branch: `master`
  - All Branches: `/^hotfix\/(.*)/`
  - All Branches: `/^bugfix\/(.\*)/`
  - All Branches: `/^release\/(.\*)/`
  - All Branches: `/^builds\/(.\*)/`
  - All Branches: `/^tests\/(.\*)/`
  - All Branches: `/^topic\/(.\*)/`
  - All Pull Requests like `PRs on Release/0.0.0`
  - Only Tags like `/^(v|tmp|qa)(\d+.)(\d+.)(\d+)$/`

**Notes:**

- Do not raise PRs other than from `release or hotfix branch to master branch` as this check can't be put in configuration and not recommended.
- Do not add tags like `v*|tmp*|qa*` on `branches other than master` as this check can't be enforced in git and not recommended

## 2. Deploy Stage:

`Deploy-stage` is ment for integrating all steps related to deployment of artifact in previous steps in single stage. It is purposed to include steps such as: `testing-artifact`, `test-deployment`, `deployment`, and `veryfying-deployment`, etc.

- Nothing except simple github release deployment is coded in `0.0.0` release or skeleton-project for this stage.
- Table next denotes a typical deployment scenario for any project with multiple environments in short.
  - In `0.0.0` release or skeleton-project `Deploy: To Environments` are not coded, only `Deploy: Publish As Tags` are coded
  - As such this favours github as unlike gitlab github free does not have concept of environments.

| Master Branch Builds | Deploy: To Environments | Deploy: Publish As Tags |   Nature    | Purpose                                                                                                    |
| :------------------- | :---------------------: | :---------------------: | :---------: | :--------------------------------------------------------------------------------------------------------- |
| Not Tagged           |         STAGING         |         master          |    Draft    | Ment for continuous integration, like daily feature merges. Does not goes above Staging to QA, UAT, & Prod |
| Tagged (tmp\*.\*.\*) |           QA            |          tmp\*          |    Draft    | Ment for project manager to push some tags to QA on will. Does not installs to Staging, UAT, & Prod        |
| Tagged (qa\*.\*.\*)  |        QA & UAT         |          qa\*           | Pre-Release | Ment for getting internal and client approval. Does not installs to Staging, & Prod                        |
| Tagged (v\*.\*.\*)   |     QA, UAT & PROD      |      v\* + latest       |   Release   | Ment for client delivery. Does not installs to Staging.                                                    |

Github releases are made using [dpl deploy-tool](https://github.com/travis-ci/dpl) and `0.0.0` release will contain only files `README.md`, `Releases.md`, `History.md`, and `LICENSE` initially as released artifact.

- DPL is universal tool for multi-party deployments like on github, gitlab, AWS etc, thus am not using limiting travis configuration for github releases but using this tool for making same.
- In deploy stage to install this `DPL Tool` we've to execute command `gem install dpl --pre` this requires need of `ruby` to be present in ci-agent. As travis-ci node with python language contains ruby no extra code is put for same. However on gitlab you may need to amend scripts.
