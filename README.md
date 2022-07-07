# Happy wheels

## Name

Happy wheels

## Description

A Flutter crossplatform application for viewing cars from auto.ru made by FAMCS students.

## GitFlow

Configure your local config of the git-repository as shown in 
the file [GitFlow](https://innowise-group.atlassian.net/wiki/spaces/MD/pages/2191884296/GitFlow).

### Branches

This repository holds two branches with infinite lifetime:

1. `main`
2. `develop`

And two other branches can be created:

* `feature`
* `bugfix`

`feature` is associated with implementing new logic for application, as the `bugfix` with repaigring the current one.

#### Main branch

`main` keeps released application version. New application version is created from `develop` to
`main` via Merge Request. Merge Request must have title with new version name and description will 
all listed changed in this update:

```
Title:
    VersionName - 1.0.22
Description:
    * Fixed crash with uploading avatars.
    * Fixed bug with navigating from settings.
    * Implemented push-notification module.
    * and more...
```

Then tag should be added `v_global.feature.fixes`.

#### Develop branch

Branches `feature/name` is created from develop. Sub-branches `feature/name-deatails` can be created
if the task is large and we want to split it into a smaller ones.

#### Testing

If bugs were found during testing, then new `bugfix/name-details` branch is created from develop
and merged when bug is fixed.

#### Merge Request

Every Pull Request must have **title** and **description**. Title shortly describe implemented logic and
description provides some additional details (problem, decision, edge case, and etc.):

```
Title: 
    Add forget password link to registration screen
Descrition:
    Designer decided to add it as underline link instead of additional screen.

Title:
    Add login API request
Description:
    POST request with url = https://test.service/api/v1/login.
```

#### Commit name

`[Verb infinitive][description][.]`

## Architecture

Uses BloC and Clean Architecture. Dependency Injection made via GetIt. Dependency rule: inner layers are
independent of outer layers.

## Code Development rules

Code development rules are described in analysis_options.yaml and checked with Dart linter.

## Async

Asynchronous tasks are processed with Flutter Async and Dart Streams.

## Data sources

App uses API made specially for this application[App API](https://github.com/50ShadesOfCode/autoruparser).

## Presentations abstractions

TODO: Error handling is made via AppPresentationHandler which processes different error cases.
Navigation made with Navigator 2.0. Each Screen is wrapped in Page for better route building.

## Remote logging

TODO: Remote logging created with Firebase. Local terminal logging via logger package.

## Build process

TODO:

## UI approach

Widgets

## Screen Structure

Navigation mechanism is Navigator 2.0. Each Screen is Wrapped in Page for better route building.

## Localization

TODO: Static localization via JSON for 2 languages: Russian and English.

## Styles and themes

Default theme is dark. Has support for a light theme.

## Supported platforms

* Android
* IOS
* Web

## Project status

Active