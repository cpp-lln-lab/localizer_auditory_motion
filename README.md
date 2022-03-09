[![](https://img.shields.io/badge/Octave-CI-blue?logo=Octave&logoColor=white)](https://github.com/cpp-lln-lab/localizer_auditory_motion/actions)

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->

[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)

<!-- ALL-CONTRIBUTORS-BADGE:END -->

![](https://github.com/cpp-lln-lab/localizer_auditory_motion/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/cpp-lln-lab/localizer_auditory_motion/branch/master/graph/badge.svg)](https://codecov.io/gh/cpp-lln-lab/localizer_auditory_motion)
[![Build Status](https://travis-ci.com/cpp-lln-lab/localizer_auditory_motion.svg?branch=master)](https://travis-ci.com/cpp-lln-lab/localizer_auditory_motion)

# Auditory Translational Motion

- [Auditory Translational Motion](#auditory-translational-motion)
  - [`audioLocTranslational`](#audioloctranslational)
    - [`setParameters`](#setparameters)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Contributors ✨](#contributors-)

## `audioLocTranslational`

Running this script will play blocks of motion/static sounds. Motion blocks will
play sounds moving in one of four directions (up-, down-, left-, and right-ward)

By default it is run in `Debug mode` meaning that it does not care about subjID,
run n., fMRI triggers, Eye Tracker, etc..

Any details of the experiment can be changed in `setParameters.m` (e.g.,
experiment mode, motion stimuli details, exp. design, etc.)

### `setParameters`

`setParameters.m` is the core engine of the experiment. See [docs/configuration](.docs/../docs/configuration.md) for more information.

## Requirements

Make sure that the following toolboxes are installed and added to the matlab /
octave path.

For instructions see the following links:

| Requirements                                             | Used version |
| -------------------------------------------------------- | ------------ |
| [PsychToolBox](http://psychtoolbox.org/)                 | >=3.0.14     |
| [Matlab](https://www.mathworks.com/products/matlab.html) | >=2017b      |
| or [octave](https://www.gnu.org/software/octave/)        | >=4.?        |

## Installation

The CPP_BIDS and CPP_PTB dependencies are already set up as submodule to this
repository. You can install it all with git by doing.

```bash
git clone --recurse-submodules https://github.com/cpp-lln-lab/localizer_auditory_motion.git
```



## Contributors ✨

Thanks goes to these wonderful people
([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/mohmdrezk"><img src="https://avatars2.githubusercontent.com/u/9597815?v=4" width="100px;" alt=""/><br /><sub><b>Mohamed Rezk</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/localizer_auditory_motion/commits?author=mohmdrezk" title="Code">💻</a> <a href="#design-mohmdrezk" title="Design">🎨</a> <a href="#ideas-mohmdrezk" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://remi-gau.github.io/"><img src="https://avatars3.githubusercontent.com/u/6961185?v=4" width="100px;" alt=""/><br /><sub><b>Remi Gau</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/localizer_auditory_motion/commits?author=Remi-Gau" title="Code">💻</a> <a href="#design-Remi-Gau" title="Design">🎨</a> <a href="#ideas-Remi-Gau" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/cpp-lln-lab/localizer_auditory_motion/issues?q=author%3ARemi-Gau" title="Bug reports">🐛</a> <a href="#userTesting-Remi-Gau" title="User Testing">📓</a> <a href="https://github.com/cpp-lln-lab/localizer_auditory_motion/pulls?q=is%3Apr+reviewed-by%3ARemi-Gau" title="Reviewed Pull Requests">👀</a> <a href="#question-Remi-Gau" title="Answering Questions">💬</a> <a href="#infra-Remi-Gau" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-Remi-Gau" title="Maintenance">🚧</a></td>
    <td align="center"><a href="https://github.com/marcobarilari"><img src="https://avatars3.githubusercontent.com/u/38101692?v=4" width="100px;" alt=""/><br /><sub><b>marcobarilari</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/localizer_auditory_motion/commits?author=marcobarilari" title="Code">💻</a> <a href="#design-marcobarilari" title="Design">🎨</a> <a href="#ideas-marcobarilari" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/cpp-lln-lab/localizer_auditory_motion/issues?q=author%3Amarcobarilari" title="Bug reports">🐛</a> <a href="#userTesting-marcobarilari" title="User Testing">📓</a> <a href="https://github.com/cpp-lln-lab/localizer_auditory_motion/pulls?q=is%3Apr+reviewed-by%3Amarcobarilari" title="Reviewed Pull Requests">👀</a> <a href="#question-marcobarilari" title="Answering Questions">💬</a> <a href="#infra-marcobarilari" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-marcobarilari" title="Maintenance">🚧</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors)
specification. Contributions of any kind welcome!
