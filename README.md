
## Installation

You can install overwatch-collection as a gem:

    gem install overwatch-collection

Or download the source:

    git clone https://github.com/danryan/overwatch-collection.git
    
### 
## Features

### Resources

A resource is anything you want to instrument. Typically (as with other monitoring apps), a resource is a server, but it can be anything that can send JSON over HTTP.

### Snapshots

When a snapshot is recorded, it's socked away in its raw form so you can come back at a later time and review the exact state of a given resource without having to piece individual metrics together.

### Metrics

Snapshots are also broken up and saved as individual attribute/value pairs, which enables you to track a particular attribute over a given period of time. 



## Roadmap

* Documentation. Like, seriously.
* Log to STDOUT like a proper service.
* Callbacks! Decide what happens after data gets collected.
* Taggable resources and snapshots
* Let config file be, er, configurable
* Add a User model for authentication/authorization
