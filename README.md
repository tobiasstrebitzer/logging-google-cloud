## Logging Google Cloud Appender
* [Homepage](http://rubygems.org/gems/logging-google-cloud)
* [Github Project](https://github.com/tobiasstrebitzer/logging-google.cloud)

### Description

The Logging Google Cloud Appender provides a way to send log messages from your
Ruby application to Google Cloud Logging.

### Installation

```
gem install logging-google-cloud
```

The Logging module is not yet available in the latest gcloud release on rubygems.
You need to manually install the [latest gcloud-ruby version from here](https://github.com/GoogleCloudPlatform/gcloud-ruby)

### Examples

This example creates and configures a google cloud logging appender and sends verious log messages.

```ruby
require "logging"
require "logging/appenders/gcl"

Logging.init(Logging::Appenders::GoogleCloudLogging::SEVERITY_NAMES)
logger = Logging::Logger.new("Dronejob")
logger.add_appenders(Logging.appenders.gcl 'Google Cloud Logging', 
  project_id: "project-id",
  log_name: "log-name", 
  resource_type: "gce_instance",
  resource_labels: {"instance_id" => "instance-id", "zone" => "us-central1-b"}, 
  buffer_size: '3',
  immediate_at: 'error, fatal'

logger.debug("debug message")
logger.info("info message")
logger.notice("notice message")
logger.warning("warning message")
logger.error("error message")
logger.critical("critical message")
logger.alert("alert message")
logger.emergency("emergency message")
```

### License

The MIT License

Copyright (c) 2016 Tobias Strebitzer

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
