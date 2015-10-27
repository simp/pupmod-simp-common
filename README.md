[![License](http://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html) [![Build Status](https://travis-ci.org/simp/pupmod-simp-common.svg)](https://travis-ci.org/simp/pupmod-simp-common) [![SIMP compatibility](https://img.shields.io/badge/SIMP%20compatibility-4.2.*%2F5.1.*-orange.svg)](https://img.shields.io/badge/SIMP%20compatibility-4.2.*%2F5.1.*-orange.svg)

#### Table of Contents

1. [Overview](#overview)
2. [Limitations - OS compatibility, etc.](#limitations)
3. [Development - Guide for contributing to the module](#development)
      * [Acceptance Tests - Beaker env variables](#acceptance-tests)

## Overview

This module contains various items that are used across the SIMP
infrastructure. It additionally provides a landing spot for manifests that
don't really justify an entire module on their own.

## This is a SIMP module
This module is a component of the [System Integrity Management Platform](https://github.com/NationalSecurityAgency/SIMP), a compliance-management framework built on Puppet.

If you find any issues, they can be submitted to our [JIRA](https://simp-project.atlassian.net/).

Please read our [Contribution Guide](https://simp-project.atlassian.net/wiki/display/SD/Contributing+to+SIMP) and visit our [developer wiki](https://simp-project.atlassian.net/wiki/display/SD/SIMP+Development+Home).

## Development

Please see the [SIMP Contribution Guidelines](https://simp-project.atlassian.net/wiki/display/SD/Contributing+to+SIMP).


### Acceptance tests

To run the system tests, you need [Vagrant](https://www.vagrantup.com/) installed. Then, run:

```shell
bundle exec rake acceptance
```

Some environment variables may be useful:

```shell
BEAKER_debug=true
BEAKER_provision=no
BEAKER_destroy=no
BEAKER_use_fixtures_dir_for_modules=yes
```

* `BEAKER_debug`: show the commands being run on the STU and their output.
* `BEAKER_destroy=no`: prevent the machine destruction after the tests finish so you can inspect the state.
* `BEAKER_provision=no`: prevent the machine from being recreated. This can save a lot of time while you're writing the tests.
* `BEAKER_use_fixtures_dir_for_modules=yes`: cause all module dependencies to be loaded from the `spec/fixtures/modules` directory, based on the contents of `.fixtures.yml`.  The contents of this directory are usually populated by `bundle exec rake spec_prep`.  This can be used to run acceptance tests to run on isolated networks.
