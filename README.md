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

- Update property
```ruby
Immobilienscout::API::Property.update(is24_id, {params})
```

_Notes:_

You have to send all attributes, also if only one attribute has changed. Otherwise Immobilienscout cannot interpret if a missing attribute should be filled in with NULL or not.

`is24_id` is the id returned by Immobilienscout when you first created the property.

If you have provided a custom id, you can use `"ext-#{custom_id}"` instead of the is24_id.


- Delete property
```ruby
Immobilienscout::API::Property.destroy(is24_id)
```

- Show property
```ruby
Immobilienscout::API::Property.show(is24_id)
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

 - Retrieve all attachments for a specific property
```ruby
Immobilienscout::API::Attachment.retrieve_all(is24_id)
```

 - Delete an attachment for a specific property
```ruby
Immobilienscout::API::Attachment.destroy(is24_id, attachment_id)
```

#### Report
- Get scout report
```ruby
Immobilienscout::API::Report.retrieve(is24_id, date_from, date_to)
```

#### IMPORTANT: Check Immobilienscout API Documentation about the needed params.


## Immobilienscout API

 https://api.immobilienscout24.de/our-apis/import-export.html
