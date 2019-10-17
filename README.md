# Immobilienscout gem

[![Build Status](https://travis-ci.com/homeday-de/immobilienscout.svg?branch=master)](https://travis-ci.com/homeday-de/immobilienscout)
[![Gem Version](https://badge.fury.io/rb/immobilienscout.svg)](https://badge.fury.io/rb/immobilienscout)
[![GitHub license](https://img.shields.io/github/license/homeday-de/immobilienscout)](https://github.com/homeday-de/immobilienscout/blob/master/LICENSE.txt)

This is an interface for Immobilienscout API

## Example
Set up your keys in `immobilienscout.rb` inside initializers.
```ruby
Immobilienscout.configure do |config|
  config.consumer_key = 'consumer_key'
  config.consumer_secret = 'consumer_secret'
  config.access_token = 'access_token'
  config.access_token_secret = 'access_token_secret'
  config.use_sandbox = true
end

```

## Methods

#### Property
 - Create property
```ruby
Immobilienscout::API::Property.create({params})
```

- Publish property
```ruby
Immobilienscout::API::Property.publish({params})
```

- Delete property
```ruby
Immobilienscout::API::Property.destroy(is24_id)
```

#### Attachment
 - Add attachments to property
```ruby
Immobilienscout::API::Attachment.add(is24_id, binary_file, {metadata})
```

 - Order attachments for a specific property
```ruby
Immobilienscout::API::Attachment.put_order(is24_id, {params})
```

#### Report
- Get scout report
```ruby
Immobilienscout::API::Report.retrieve(is24_id, date_from, date_to)
```

#### IMPORTANT: Check Immobilienscout API Documentation about the needed params.


## Immobilienscout API

 https://api.immobilienscout24.de/our-apis/import-export.html
