PipeCleaner
----

PipeCleaner is a cloud-based collaboration tool and executive report dashboard for sharing status updates on projects using assembly-line processes. Any number of pipelines may be created, with any number of stages, which always apply in the same order. Work items are defined global, not per-pipeline, and thus may put through multiple pipelines simultaneously without interference.


Use
====
A User's Manual ships with the product, and is available for unauthenticated access at http://<hostname>/guide

Also see the doc/ directory for additional diagrams and materials.

Developer Quick-Start
====

* git clone git://github.com/tgen/pipecleaner.git
* cd pipecleaner
* bundle install
* rake db:migrate
* rake db:seed
* rails s

See the Gemfile for underlying libraries and components. SQLite3 will be used as the database by default.

Copyright
====

Copyright (c) 2013 TGen. See LICENSE.txt for further details.
