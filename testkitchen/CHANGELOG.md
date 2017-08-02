##v0.0.2 (unreleased)

###BACKWARDS INCOMPATIBILITIES / NOTES:

###Summary

####Changes, features & improvements
- Added an example of .kitchen.yml override
- Added utilities scripts
- Clarified topics on README
- Add tests for new version 6.2.1
- Installation dir is now a parameter
- Added rubocop tests

####Bug fixes
- Test for 5.5.2 was broken. Changed archive url for version 5.5.2 (is an old version now)

####Known bugs

##v0.0.1

###BACKWARDS INCOMPATIBILITIES / NOTES:

###Summary
Solr standalone and cloud is configured correctly and runs as expected :)

####Changes, features & improvements
- You can pass url archive and solr version
- Changed java home (solr is very annoying about that)
- You can pass the installation home (logs/ and data/ will be created there)
- Configuration file is now a template
- Added full testing (standalone and cloud)
- Adding zk to test kitchen to test solr cloud
- Speed up the test by a local kitchen.local.yml
- Speed up the test by installing java8 via apt (added to docker)

####Bug fixes

####Known bugs
