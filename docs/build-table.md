A generic Gitflow table to setup builds, tests and deployments follows:

| Type   | REFs                 | Build | Test |  Review   | Staging<sup>4</sup> | QA<sup>5</sup> | UAT, PROD | Remarks                |
| :----- | :------------------- | :---: | :--: | :-------: | :-----------------: | :------------: | :-------: | :--------------------- |
| Branch | master               |  yes  | yes  |    no     |      auto-inst      |       no       |    no     | <sup>1</sup>           |
| Tag    | tag (v\*) [master]   |   -   |  -   |    no     |          -          |    man-inst    | man-inst  | <sup>2</sup>           |
| Branch | hotfix/\*            |  yes  | yes  | auto-inst |         no          |       no       | man-inst  | <sup>3</sup>, Raise PR |
| Branch | bugfix/\*            |  yes  | yes  | auto-inst |         no          |       no       |    no     | Raise PR               |
| Branch | release/\*           |  yes  | yes  |    no     |         no          |       no       |    no     | Raise PR               |
| Branch | features/\*          |  no   |  no  |    no     |         no          |       no       |    no     | PR Not Allowed         |
| Branch | builds/\*            |  yes  |  no  |    no     |         no          |       no       |    no     | PR Not Allowed         |
| Branch | tests/\*             |  yes  | yes  |    no     |         no          |       no       |    no     | PR Not Allowed         |
| Branch | topic/\*             |  yes  | yes  |    yes    |         no          |       no       |    no     | PR Not Allowed         |
| Pull   | pull-requests        |  yes  | yes  |    no     |         no          |       no       |    no     | Don't Approve Failed   |
| Tag    | tag (tmp\*) [master] |   -   |  -   |    no     |          -          |    man-inst    |    no     | <sup>2</sup>           |
| Tag    | tag (\*)             |  no   |  no  |    no     |         no          |       no       |    no     | no                     |

1. Master must be built and tested to ensure it's always deployable as per Gitflow. Moreover ONLY master commits can be deployed apart from it's `v*.*.*` tags (automatically up to staging and rest manual). Inclusion of master commit deployment also makes manager happy.

2. Master tags (v\*) are placed to start promote to QA onwards, and should not be built (they should use earlier artifact id re-deployed, otherwise tags have artifact when you tag master SHA to promote it from staging to quality.

   - Master tags (tmp* or qa*) are not for clients but maybe needed by managers for say monthly internal sub-releases to be deployable on QA again without re-build (as artifact of master is already there)

3. Hotfix can't go full QA thus are risky too, and few people would like you to delay with raising PRs and promoting hotfixes. Hotfixes should not enter staging as auto-installed by master. One can after quick checking hotfix in review deploy it to client UAT then to PROD.

   - If things fail PROD can be rolled back and master is intact. If hotfix succeeds then make next release PR with master (it is not necessary to send this to client) - this can remain on master/staging and await merging by next feature in line on new PR.

   - Hotfix should not go to production area (staging onwards is for master) so it should be deployed to review area before a PR is put-up for master-merge and tagging (promotion to QA/UAT/PROD).

4. Staging ?: Everything from Staging onwards: **_Test with production database copy, against production services, in a isolated-production (*or non-production*) environment. This will ensure that your database scripts will not fuss your production database_**

   - Intended for previously defined pilot or internal _in-house users only_
   - Not exposed to full or partial production user groups
   - Automatically deployed from master only using PRs (many times a day) to keep everybody aligned.
   - Typically torn-down or removed after production deployment
   - Sometimes not a complete 1:1with production (_can't replace it _)

5. QA ?: Manager pushes final releases from master after tagging it with next release number like `v*.*.*` as per delivery schedule. Then QA lead needs to approval after full-testing of new features and old-features. Once approved, manager promotes release to client (UAT then PROD). Usually clients are not given access to this as many internal non-delivered items can also being tested by QA like future plan releases.

6. UAT + PROD ?: Actually client access, anything here is considered live and on-prod changes could be occurring that needs to be updated to UAT (on_change immediate)
