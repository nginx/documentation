---
description: License information for open source components included in the NGINX
  Plus software.
docs: DOCS-471
title: Open Source Components
toc: true
weight: 500
type:
- reference
---

Open source components included in the F5 NGINX Plus (package name is `nginx-plus`) are:


- nginx/OSS 1.27.4, distributed under 2-clause BSD license.

  Homepage: <https://nginx.org>

  Copyright © 2002-2021 Igor Sysoev

  Copyright © 2011-2025 NGINX, Inc.

  All rights reserved.

  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
  - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

- Internal MD5 implementation based on Alexander Peslyak's public domain implementation:

  This is an OpenSSL-compatible implementation of the RSA Data Security, Inc. MD5 Message-Digest Algorithm (RFC 1321).

  Homepage: <http://openwall.info/wiki/people/solar/software/public-domain-source-code/md5>

  Author: Alexander Peslyak, better known as Solar Designer <solar at openwall.com>

  This software was written by Alexander Peslyak in 2001.  No copyright is
  claimed, and the software is hereby placed in the public domain.
  In case this attempt to disclaim copyright and place the software in the
  public domain is deemed null and void, then the software is
  Copyright © 2001 Alexander Peslyak and it is hereby released to the
  general public under the following terms:
  - Redistribution and use in source and binary forms, with or without
modification, are permitted.

  - There's ABSOLUTELY NO WARRANTY, express or implied.

  (This is a heavily cut-down "BSD license".)

- MurmurHash algorithm (version 2), distributed under MIT license.

  Homepage: <https://github.com/aappleby/smhasher>

  Copyright © Austin Appleby

  Permission is hereby granted, free of charge, to any person
  obtaining a copy of this software and associated documentation files
  (the "Software"), to deal in the Software without restriction,
  including without limitation the rights to use, copy, modify, merge,
  publish, distribute, sublicense, and/or sell copies of the Software,
  and to permit persons to whom the Software is furnished to do so,
  subject to the following conditions:
  - The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

- Components used in status monitoring dashboard v2 only
(`dashboard.html` in `nginx-plus` package) and distributed under MIT license:


  - `@babel-core`, Babel compiler core (7.23.2)

    Homepage: <https://github.com/babel/babel/tree/master/packages/babel-core>

    Copyright © 2014-present Sebastian McKenzie and other contributors

  - `@babel/plugin-proposal-object-rest-spread`, produces spec-compliant code by using Babel's objectSpread helper (7.22.15).

    Homepage: <https://github.com/babel/babel/tree/master/packages/babel-plugin-proposal-object-rest-spread>

  - `@babel/plugin-transform-runtime`, makes helpers reference the module babel-runtime to avoid duplication across your compiled output (7.22.15).

    Homepage: <https://github.com/babel/babel/tree/master/packages/babel-plugin-transform-runtime>

  - `@babel/preset-env`, a Babel preset for each environment (7.22.15).

    Homepage: <https://github.com/babel/babel/tree/master/packages/babel-preset-env>

  - `@babel/preset-react`, a Babel preset for all React plugins (7.22.15).

    Homepage: <https://github.com/babel/babel/tree/master/packages/babel-preset-react>

  - `autoprefixer`, a PostCSS plugin to parse CSS and add vendor prefixes to CSS rules (10.4.7)

    Homepage: <https://github.com/postcss/autoprefixer>

    Copyright © 2013 Andrey Sitnik <andrey@sitnik.ru>

  - `babel-loader`, allows transpiling JavaScript files using Babel and webpack (9.1.3).

    Homepage: <https://github.com/babel/babel-loader>

    Copyright © 2014-2019 Luís Couto <hello@luiscouto.pt>


  - `babel-plugin-istanbul`, a babel plugin that adds istanbul instrumentation to ES6 code (6.1.1).

    Homepage: <https://github.com/istanbuljs/babel-plugin-istanbul>

    Copyright © 2016, Istanbul Code Coverage

  - `core-js`, a modular standard library for JavaScript (3.22.8).

    Homepage: <https://github.com/zloirock/core-js>

    Copyright © 2014-2022 Denis Pushkarev

  - `css-loader`, interprets `@import` and `url()`
like `import/require()` and will resolve them (6.8.1).

    Homepage: <https://github.com/webpack-contrib/css-loader>

    Copyright © JS Foundation and other contributors

  - `cssnano`, a modular minifier, built on top of the PostCSS ecosystem (5.1.11).

    Homepage: <https://github.com/cssnano/cssnano/>

    Copyright © Ben Briggs <beneb.info@gmail.com>

  - `eslint`, a tool for identifying and reporting on patterns found in ECMAScript/JavaScript code (8.49.0).

    Homepage: <https://www.npmjs.com/package/eslint>

    Copyright OpenJS Foundation and other contributors, <www.openjsf.org>

  - `eslint-config-airbnb`, exports some ESLint configurations (19.0.4).

    Homepage: <https://www.npmjs.com/package/eslint-config-airbnb>

    Copyright © 2012 Airbnb

  - `eslint-plugin-import`, supports linting of ES2015+ (ES6+) import/export syntax and prevent issues with misspelling of file paths and import names (2.28.1).

    Homepage: <https://www.npmjs.com/package/eslint-plugin-import>

    Copyright © 2015 Ben Mosher

  - `eslint-plugin-jsx-a11y`, static AST checker for accessibility rules on JSX elements (6.5.1).

    Homepage: <https://www.npmjs.com/package/eslint-plugin-jsx-a11y>

     Copyright © 2016 Ethan Cohen

  - `eslint-plugin-react`, react specific linting rules for eslint (7.33.2).

    Homepage: <https://www.npmjs.com/package/eslint-plugin-react>

    Copyright © 2014 Yannick Croissant

  - `eslint-webpack-plugin`, uses eslint to find and fix problems in the JavaScript code (4.0.1).

    Homepage: <https://www.npmjs.com/package/eslint-webpack-plugin>

    Copyright JS Foundation and other contributors

  - `history`, manage session history with JavaScript (4.10.1).

    Homepage: <https://github.com/ReactTraining/history>

    Copyright © React Training 2016-2020, Copyright © Remix Software 2020-2021

  - `html-inline-css-webpack-plugin`, converts external stylesheet to embedded stylesheet, aka document stylesheet (1.11.1).

    Homepage: <https://github.com/Runjuu/html-inline-css-webpack-plugin>

    Copyright © 2018 Huang

  - `html-webpack-plugin`, simplifies creation of HTML files to serve your webpack bundles (5.5.0).

    Homepage: <https://github.com/jantimon/html-webpack-plugin>

    Copyright © JS Foundation and other contributors

  - `mini-css-extract-plugin`, extracts CSS into separate files (2.6.0).

    Homepage: <https://github.com/webpack-contrib/mini-css-extract-plugin>

    Copyright © JS Foundation and other contributors

  - `postcss`, a tool for transforming styles with JS plugins (8.4.31).

    Homepage: <https://github.com/postcss/postcss>

    Copyright 2013 Andrey Sitnik &lt;<andrey@sitnik.ru>&gt;

  - `postcss-loader`, PostCSS loader for webpack (7.3.3).

    Homepage: <https://github.com/postcss/postcss-loader>

    Copyright © JS Foundation and other contributors

  - `postcss-url`, PostCSS plugin to rebase url(), inline or copy asset (10.1.3).

    Homepage: <https://github.com/postcss/postcss-url>

    Copyright © 2014 Maxime Thirouin

  - `preact`, fast 3kb React alternative with the same ES6 API (10.7.3).

    Homepage: <https://github.com/developit/preact>

    Copyright © 2015-present Jason Miller

  - `react-dev-utils`, utilities used by Create React App (12.0.1).

    Homepage: <https://github.com/facebook/create-react-app>

    Copyright © 2013-present, Facebook, Inc.

  - `regenerator-runtime`, standalone runtime for Regenerator-compiled generator and async functions (0.14.1).

    Homepage: <https://github.com/facebook/regenerator>

    Copyright © 2014-present, Facebook, Inc.

  - `style-loader`, injects CSS into the DOM (3.3.1).

    Homepage: <https://github.com/webpack-contrib/style-loader>

    Copyright © JS Foundation and other contributors

  - `webpack`, a bundler for javascript and friends (5.88.2).

    Homepage: <https://github.com/webpack/webpack>

    Copyright © JS Foundation and other contributors

  - `webpack-cli`, provides the interface of options webpack uses in its configuration file (4.10.0).

    Homepage: <https://github.com/webpack/webpack-cli>

    Copyright © JS Foundation and other contributors

  - `whatwg-fetch`, a window.fetch JavaScript polyfill (2.0.4).

    Homepage: <https://github.com/github/fetch>

    Copyright © 2014-2016 GitHub, Inc.

    The MIT License

    Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
    - The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

- Components used in status monitoring dashboard v2 only (`dashboard.html` in `nginx-plus` package) and distributed under 3-clause BSD license and Apache 2.0 license:

  - `babel-plugin-react-css-modules`, transforms styleName to className using compile time CSS module resolution (3.4.2), distributed under 3-clause BSD license.

    Homepage: <https://github.com/gajus/babel-plugin-react-css-modules>

    Copyright © 2016, Gajus Kuizinas (<http://gajus.com/>)

    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    - Neither the name of the Gajus Kuizinas (<http://gajus.com/>) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL ANUARY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  - `npm-font-open-sans`, Open Sans font family - incl. usage of CSS, SCSS, LESS (1.1.0), distributed under Apache 2.0 license.

    Homepage: <https://github.com/dasrick/npm-font-open-sans>

    Copyright © Steve Matteson

  Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at <http://www.apache.org/licenses/LICENSE-2.0>

  Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


Optional add-on and third-party modules provided with NGINX Plus may include
additional open-source components. The licenses for these components are included in the installation package
for each module.
